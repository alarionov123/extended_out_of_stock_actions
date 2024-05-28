<?php

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if ($mode === 'request_analog') {

        $return_url = !empty($_REQUEST['redirect_url']) ? $_REQUEST['redirect_url'] : '';
        if (!empty($_REQUEST['call_data'])) {
            $call_data = $_REQUEST['call_data'];

            $product_data = !empty($_REQUEST['product_data']) ? $_REQUEST['product_data'] : [];

            if ($res = fn_extended_out_of_stock_actions_create_request($call_data, Tygh::$app['session']['auth'])) {
                fn_set_notification('N', __('notice'), __('extended_out_of_stock_actions.request_created'));
            } else {
                fn_set_notification('N', __('notice'), __('extended_out_of_stock_actions.something_went_wrong'));
            }
        }

        return [CONTROLLER_STATUS_OK, fn_url($return_url)];
    }
}