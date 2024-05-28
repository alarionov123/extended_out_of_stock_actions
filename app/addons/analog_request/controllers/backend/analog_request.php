<?php
/***************************************************************************
 *                                                                          *
 *   (c) 2004 Vladimir V. Kalynyak, Alexey V. Vinokurov, Ilya M. Shalnev    *
 *                                                                          *
 * This  is  commercial  software,  only  users  who have purchased a valid *
 * license  and  accept  to the terms of the  License Agreement can install *
 * and use this program.                                                    *
 *                                                                          *
 ****************************************************************************
 * PLEASE READ THE FULL TEXT  OF THE SOFTWARE  LICENSE   AGREEMENT  IN  THE *
 * "copyright.txt" FILE PROVIDED WITH THIS DISTRIBUTION PACKAGE.            *
 ****************************************************************************/

use Tygh\Enum\NotificationSeverity;
use Tygh\Registry;

defined('BOOTSTRAP') or die('Access denied');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if ($mode === 'delete') {
        if ($_REQUEST['request_id']) {
            fn_delete_analog_request($_REQUEST['request_id']);
        }
    }

    if ($mode === 'update_status') {
        if (!empty($_REQUEST['id']) && !empty($_REQUEST['status'])) {
            db_query('UPDATE ?:request_analog SET status = ?s WHERE request_id = ?i', $_REQUEST['status'], $_REQUEST['id']);
            fn_set_notification(NotificationSeverity::NOTICE, __('notice'), __('status_changed'));
        }

        if (empty($_REQUEST['return_url'])) {
            exit;
        } else {
            return [CONTROLLER_STATUS_REDIRECT, $_REQUEST['return_url']];
        }
    }
    return [CONTROLLER_STATUS_OK, 'analog_request.manage'];
}

if ($mode === 'manage') {
    $params = array_merge(
        ['items_per_page' => Registry::get('settings.Appearance.admin_elements_per_page')],
        $_REQUEST
    );

    $params['company_id'] = Registry::get('runtime.company_id');

    list($requests, $search) = fn_analog_request_get_requests($params, DESCR_SL);

    $statuses = db_get_list_elements('call_requests', 'status', true, DESCR_SL, 'call_requests.status.');
    $order_statuses = fn_get_statuses(STATUSES_ORDER);

    Tygh::$app['view']
        ->assign('requests', $requests)
        ->assign('search', $search)
        ->assign('request_statuses', $statuses)
        ->assign('order_statuses', $order_statuses);
}
