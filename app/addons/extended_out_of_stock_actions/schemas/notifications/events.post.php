<?php

use Tygh\Enum\SiteArea;
use Tygh\Enum\UserTypes;
use Tygh\Notifications\Transports\Mail\MailTransport;
use Tygh\Notifications\Transports\Mail\MailMessageSchema;
use Tygh\Notifications\DataValue;
use Tygh\Registry;

defined('BOOTSTRAP') or die('Access denied');

$schema['extended_out_of_stock_actions.request_created'] = [
    'group'     => 'extended_out_of_stock_actions.subj',
    'name'      => [
        'template' => 'extended_out_of_stock_actions.event.request_created.name',
        'params'   => [],
    ],
    'receivers' => [
        UserTypes::ADMIN => [
            MailTransport::getId() => MailMessageSchema::create([
                'area'             => SiteArea::ADMIN_PANEL,
                'from'             => 'default_company_orders_department',
                'to'               => 'company_orders_department',
                'template_code'    => 'extended_out_of_stock_actions_email_template',
                'legacy_template'  => 'addons/extended_out_of_stock_actions/extended_out_of_stock_actions.tpl',
                'company_id'       => DataValue::create('request_data.company_id'),
                'to_company_id'    => DataValue::create('request_data.company_id'),
                'to_storefront_id' => DataValue::create('request_data.storefront_id'),
                'language_code'    => Registry::get('settings.Appearance.backend_default_language'),
            ]),
        ],
    ],
];

return $schema;
