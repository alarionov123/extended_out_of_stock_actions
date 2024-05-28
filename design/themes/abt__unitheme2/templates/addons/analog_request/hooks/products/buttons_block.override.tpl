{* Adds a new condition rule - $product.out_of_stock_actions === "R" *}

{if (
$product.zero_price_action != "R"
|| $product.price != 0
)
&& (
$settings.General.inventory_tracking == "YesNo::NO"|enum
|| $allow_negative_amount === "YesNo::YES"|enum
|| (
$product_amount > 0
&& $product_amount >= $product.min_qty
)
|| $product.tracking == "ProductTracking::DO_NOT_TRACK"|enum
|| $product.is_edp == "YesNo::YES"|enum
|| $product.out_of_stock_actions == "OutOfStockActions::BUY_IN_ADVANCE"|enum
|| $product.out_of_stock_actions === "R"
)
|| (
$product.has_options
&& !$show_product_options
)}

    {if $smarty.capture.buttons_product|trim != '&nbsp;'}
        {if $product.avail_since <= $smarty.const.TIME || (
        $product.avail_since > $smarty.const.TIME && $product.out_of_stock_actions == "OutOfStockActions::BUY_IN_ADVANCE"|enum
        )}
            {$smarty.capture.buttons_product nofilter}
        {/if}
    {/if}

{elseif ($settings.General.inventory_tracking !== "YesNo::NO"|enum && $allow_negative_amount !== "YesNo::YES"|enum && (($product_amount <= 0 || $product_amount < $product.min_qty) && $product.tracking != "ProductTracking::DO_NOT_TRACK"|enum) && $product.is_edp != "Y")}
    {hook name="products:out_of_stock_block"}
    {$show_qty = false}
    {if !$details_page}
        {if (!$product.hide_stock_info && !(($product_amount <= 0 || $product_amount < $product.min_qty) && ($product.avail_since > $smarty.const.TIME)))}
            <button disabled class="ty-btn ty-btn__tertiary" id="out_of_stock_info_{$obj_prefix}{$obj_id}"><span><i
                            class="ut2-icon-use_icon_cart"></i><bdi>{$out_of_stock_text}</bdi></span></button>
        {/if}
    {elseif ($product.out_of_stock_actions == "OutOfStockActions::SUBSCRIBE"|enum)}
        <div id="subscribe_form_wrapper"><!--subscribe_form_wrapper--></div>
        <script>
            (function (_, $) {
                $.ceAjax('request', fn_url('products.subscription_form?product_id={$product.product_id}'), {
                    hidden: true,
                    result_ids: 'subscribe_form_wrapper'
                });
            }(Tygh, Tygh.$));
        </script>
        {include file="common/image_verification.tpl" option="track_product_in_stock"}
    {/if}
    {/hook}
{/if}

{if $show_list_buttons}
    {capture name="product_buy_now_`$obj_id`"}
        {$compare_product_id = $product.product_id}

        {hook name="products:buy_now"}
        {if $settings.General.enable_compare_products == "YesNo::YES"|enum}
            {include file="buttons/add_to_compare_list.tpl" product_id=$compare_product_id}
        {/if}
        {/hook}
    {/capture}
    {$capture_buy_now = "product_buy_now_`$obj_id`"}

    {if $smarty.capture.$capture_buy_now|trim}
        {$smarty.capture.$capture_buy_now nofilter}
    {/if}
{/if}

{* Uncomment these lines in the overrides hooks for back-passing $cart_button_exists variable to the product_data template *}
{*if $cart_button_exists}
    {capture name="cart_button_exists"}Y{/capture}
{/if*}