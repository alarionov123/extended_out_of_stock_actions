<?php

use Tygh\Enum\ObjectStatuses;
use Tygh\Registry;

/**
 * Creates analogue request and send notification about it to the administrator's email
 *
 * @param array $params
 * @param array $auth
 * @return true
 */

function fn_analog_request_create_request(array $params, array $auth): bool
{
    if (fn_allowed_for('ULTIMATE')) {
        $company_id = Registry::get('runtime.company_id');
    } elseif (!empty($params['product_id'])) {
        $company_id = db_get_field('SELECT company_id FROM ?:products WHERE product_id = ?i', $params['product_id']);
    } elseif (!empty($params['company_id'])) {
        $company_id = $params['company_id'];
    } else {
        $company_id = 0;
    }

    $params['company_id'] = $company_id;
    $params['user_id'] = $auth['user_id'];

    $request_id = fn_analog_request_actions_update_request($params);

    $params['request_id'] = $request_id;

    /** @var \Tygh\Notifications\Settings\Factory $notification_settings_factory */
    $notification_settings_factory = Tygh::$app['event.notification_settings.factory'];
    $notification_rules = $notification_settings_factory->create([]);

    /** @var \Tygh\Notifications\EventDispatcher $event_dispatcher */
    $event_dispatcher = Tygh::$app['event.dispatcher'];
    $event_dispatcher->dispatch(
        'extended_out_of_stock_actions.request_created',
        ['request_data' => $params],
        $notification_rules
    );

    return true;
}

/**
 * Update analogue request according to the parameters given
 *
 * @param array $params
 * @param int $request_id
 * @return false|int|mixed
 */
function fn_analog_request_actions_update_request(array $params, int $request_id = 0): mixed
{
    if ($request_id) {
        db_query("UPDATE ?:request_analog SET ?u WHERE request_id = ?i", $params, $request_id);
    } else {
        if (empty($params['timestamp'])) {
            $params['timestamp'] = TIME;
        }
        if (empty($params['company_id']) && $company_id = Registry::get('runtime.company_id')) {
            $params['company_id'] = $company_id;
        }
        $request_id = db_query("INSERT INTO ?:request_analog ?e", $params);
    }

    return $request_id;
}

/**
 * Gets the list of requests according to the parameters given
 *
 * @param array $params
 * @return array
 */
function fn_analog_request_get_requests(array $params = []): array
{
    $params = array_merge([
        'items_per_page' => 0,
        'page' => 1,
    ], $params);

    $condition = [];

    if (isset($params['id']) && fn_string_not_empty($params['id'])) {
        $params['id'] = trim($params['id']);
        $condition[] = db_quote("request_id = ?i", $params['id']);
    }

    if (isset($params['name']) && fn_string_not_empty($params['name'])) {
        $params['name'] = trim($params['name']);
        $condition[] = db_quote("name LIKE ?l", '%' . $params['name'] . '%');
    }

    if (isset($params['phone']) && fn_string_not_empty($params['phone'])) {
        $params['phone'] = trim($params['phone']);
        $condition[] = db_quote("phone LIKE ?l", '%' . $params['phone'] . '%');
    }

    if (!empty($params['status'])) {
        $condition[] = db_quote("status = ?s", $params['status']);
    }

    if (!empty($params['company_id'])) {
        $condition[] = db_quote("company_id = ?i", $params['company_id']);
    }

    if (!empty($params['user_id'])) {
        $condition[] = db_quote("user_id = ?s", $params['user_id']);
    }
    $condition_str = $condition ? (' WHERE ' . implode(' AND ', $condition)) : '';

    $items = db_get_array(
        "SELECT *"
        . " FROM ?:request_analog"
        . $condition_str
    );

    if (!empty($items)) {
        foreach ($items as &$item) {
            if (empty($item['product_id'])) {
                continue;
            }
            $item['product_name'] = fn_get_product_name($item['product_id']);
        }
    }

    return [$items, $params];
}

/**
 * Deletes analog request
 *
 * @param int $request_id
 * @return mixed
 */
function fn_delete_analog_request(int $request_id): mixed
{
    return db_query("DELETE FROM ?:request_analog WHERE request_id = ?i", $request_id);
}

/**
 * Gets the list of analogues for a particular product_id
 * If there was a request for this product - it retrieves the analogues list from the cache
 *
 * @param int $product_id
 * @return array
 */
function fn_analog_request_get_analogues(int $product_id): array
{
    $cache_name = 'extended_out_of_stock_actions_analogues_' . $product_id;
    Registry::registerCache($cache_name, ['mws_analogues'], Registry::cacheLevel('static'));

    if (!Registry::isExist($cache_name)) {
        $analogues = db_get_field("SELECT recommend_ids FROM ?:mws_analogues WHERE product_id = ?i", $product_id);
        $params = [
            'force_get_by_ids' => true,
            'pid' => $analogues
        ];
        $products = array_filter(fn_get_products($params)[0], function ($item) {
            if (Registry::get('addons.warehouses.status') !== ObjectStatuses::ACTIVE) {
                return $item['amount'] > 0;
            }
            /** @var Tygh\Addons\Warehouses\Manager $manager */
            $manager = Tygh::$app['addons.warehouses.manager'];
            /** @var Tygh\Addons\Warehouses\ProductStock $product_stock */
            $product_stock = $manager->getProductWarehousesStock($item['product_id']);

            if (!$product_stock->hasStockSplitByWarehouses()) {
                return $item['amount'] > 0;
            }
            /** @var \Tygh\Location\Manager $manager */
            $manager = Tygh::$app['location'];
            $destination_id = $manager->getDestinationId();

            $amount = $product_stock->getAmountForDestination($destination_id);
            return $amount > 0;
        });

        if ($products) {
            $additional_params = [
                'get_icon' => true,
                'get_detailed' => true,
            ];

            fn_gather_additional_products_data($products, $additional_params);
            Registry::set($cache_name, $products);
        }
    }
    return Registry::get($cache_name) ?? [];
}

/**
 * Prepare parameters list for scroller with analogues
 *
 * @return array
 */
function fn_scroller_properties()
{
    $setting_values = Registry::get('addons.analog_request');
    return [
        'block_id' => uniqid(),
        'properties' => array(
            'not_scroll_automatically' => 'Y', // hardcoded as works incorrectly in the pop-up
            'scroll_per_page' => $setting_values['scroll_per_page'],
            'item_quantity' => $setting_values['item_quantity'],
            'outside_navigation' => $setting_values['outside_navigation'],
            'hide_add_to_cart_button' => 'Y', // hardcoded as works incorrectly in the pop-up
            'show_price' => $setting_values['show_price'],
        ),
    ];
}