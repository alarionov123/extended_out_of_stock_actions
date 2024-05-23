{if $show_product_amount && $product.is_edp != "YesNo::YES"|enum && $settings.General.inventory_tracking !== "YesNo::NO"|enum}
    <div class="cm-reload-{$obj_prefix}{$obj_id} stock-wrap" id="product_amount_update_{$obj_prefix}{$obj_id}">
        <input type="hidden" name="appearance[show_product_amount]" value="{$show_product_amount}" />
        {if !$product.hide_stock_info}
            {if $settings.Appearance.in_stock_field == "YesNo::YES"|enum}
                {if $product.tracking != "ProductTracking::DO_NOT_TRACK"|enum}
                    {if ($product_amount > 0 && $product_amount >= $product.min_qty) && $settings.General.inventory_tracking !== "YesNo::NO"|enum || $details_page}
                        {if (
                        $product_amount > 0
                        && $product_amount >= $product.min_qty
                        || $product.out_of_stock_actions == "OutOfStockActions::BUY_IN_ADVANCE"|enum
                        )
                        && $settings.General.inventory_tracking !== "YesNo::NO"|enum
                        }
                            <div class="product-list-field">
                                <span class="ty-qty-in-stock ty-control-group__item">{__("availability")}:</span>
                                <span id="qty_in_stock_{$obj_prefix}{$obj_id}" class="ty-qty-in-stock ty-control-group__item">
                                    {if $product_amount > 0}
                                        {$product_amount}&nbsp;{__("items")}
                                    {else}
                                        <span class="on_backorder"><i class="ut2-icon-notifications_none"></i>{__("on_backorder")}</span>
                                    {/if}
                                </span>
                            </div>
                        {elseif $settings.General.inventory_tracking !== "YesNo::NO"|enum && $allow_negative_amount !== "YesNo::YES"|enum}
                            <div class="ty-control-group product-list-field">
                                {if $show_amount_label}
                                    <label class="ty-control-group__label">{__("in_stock")}:</label>
                                {/if}
                                <span class="ty-qty-out-of-stock ty-control-group__item"><i class="ut2-icon-highlight_off"></i>{$out_of_stock_text}</span>
                            </div>
                        {/if}
                    {else}

                        <div class="ty-control-group product-list-field">
                            {if $show_amount_label}
                                <label class="ty-control-group__label">{__("availability")}:</label>
                            {/if}
                            <span class="ty-qty-out-of-stock ty-control-group__item" id="out_of_stock_info_{$obj_prefix}{$obj_id}"><i class="ut2-icon-highlight_off"></i>{$out_of_stock_text}</span>
                        </div>
                    {/if}
                {/if}
            {else}
                {if (
                $product_amount <= 0
                || $product_amount < $product.min_qty
                )
                && $product.out_of_stock_actions == "R"
                }
                    <div class="ty-control-group product-list-field">
                        {if $show_amount_label}
                            <label class="ty-control-group__label">{__("availability")}:</label>
                        {/if}
                        <span class="ty-qty-out-of-stock ty-control-group__item">{$out_of_stock_text}</span>
                    </div>
                {elseif (
                $product_amount > 0
                && $product_amount >= $product.min_qty
                || $product.tracking == "ProductTracking::DO_NOT_TRACK"|enum
                )
                && $settings.General.inventory_tracking !== "YesNo::NO"|enum
                && $allow_negative_amount !== "YesNo::YES"|enum
                || $settings.General.inventory_tracking !== "YesNo::NO"|enum
                && (
                $allow_negative_amount === "YesNo::YES"|enum
                || $product.out_of_stock_actions == "OutOfStockActions::BUY_IN_ADVANCE"|enum
                )
                }
                    <div class="ty-control-group product-list-field">
                        {if $show_amount_label}
                            <label class="ty-control-group__label">{__("availability")}:</label>
                        {/if}
                        <span class="ty-qty-in-stock ty-control-group__item" id="in_stock_info_{$obj_prefix}{$obj_id}">
                            {if $product_amount > 0}
                                <i class="ut2-icon-outline-check-circle"></i>{__("in_stock")}
                            {else}
                                <span class="on_backorder"><i class="ut2-icon-notifications_none"></i>{__("on_backorder")}</span>
                            {/if}
                        </span>
                    </div>
                {elseif $settings.abt__ut2.product_list.$tmpl.show_amount[$settings.abt__device] == "YesNo::YES"|enum && (
                $product_amount <= 0
                || $product_amount < $product.min_qty
                )
                && $settings.General.inventory_tracking !== "YesNo::NO"|enum
                && $allow_negative_amount !== "YesNo::YES"|enum
                || $details_page || $product.variation_features_variants
                }
                    <div class="ty-control-group product-list-field">
                        {if $show_amount_label}
                            <label class="ty-control-group__label">{__("availability")}:</label>
                        {/if}
                        <span class="ty-qty-out-of-stock ty-control-group__item" id="out_of_stock_info_{$obj_prefix}{$obj_id}"><i class="ut2-icon-highlight_off"></i>{$out_of_stock_text}</span>
                    </div>
                {/if}
            {/if}
        {/if}
        <!--product_amount_update_{$obj_prefix}{$obj_id}--></div>

    {if ($product.avail_since > $smarty.const.TIME) && $details_page}
        {include file="common/coming_soon_notice.tpl" avail_date=$product.avail_since add_to_cart=$product.out_of_stock_actions}
    {/if}
{/if}
