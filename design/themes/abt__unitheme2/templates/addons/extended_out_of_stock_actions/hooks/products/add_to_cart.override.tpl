{* Replaces default Add to cart button with the Request analog button in case if a product is out of stock and the out of stock action set as Request analog *}

{if
    $product.out_of_stock_actions === "R"
    && ($product.amount <= 0
    || $product.amount < $product.min_qty)
    }
        <div>
            {include file="addons/extended_out_of_stock_actions/views/form_button.tpl" object_id=$product.product_id}
        </div>
    {else}
        {if $settings.abt__ut2.product_list.product_variations.allow_variations_selection[$settings.abt__device] === "YesNo::YES"|enum && $product.has_options && !$show_product_options && !$details_page}
            {if $settings.abt__device == "mobile"}
                <span class="ty-btn ut2-btn__options ty-btn__primary ty-btn__add-to-cart cm-ab-load-select-variation-content" data-ca-product-id="{$product.product_id}"><span class="ty-icon ut2-icon-use_icon_cart"></span><bdi>{__("add_to_cart")}</bdi></span>
            {else}
                {ab__hide_content bot_type="ALL"}
                {include file="common/popupbox.tpl"
                    href="products.ut2_select_variation?product_id={$product.product_id}"
                    text=__("add_to_cart")
                    id="ut2_select_options_{$obj_prefix}{$product.product_id}"
                    link_text=__("add_to_cart")
                    link_icon="ut2-icon-use_icon_cart"
                    link_icon_first=true
                    link_meta="ty-btn ut2-btn__options ty-btn__primary ty-btn__add-to-cart"
                    content=""
                    dialog_additional_attrs=["data-ca-product-id" => $product.product_id, "data-ca-dialog-purpose" => "ut2_select_options"]
                }
                {/ab__hide_content}
            {/if}

            {$cart_button_exists = true}
        {else}
            {hook name="products:add_to_cart_but_id"}
                {$_but_id="button_cart_`$obj_prefix``$obj_id`"}
            {/hook}

            {if $extra_button}{$extra_button nofilter}&nbsp;{/if}
            
            {include file="buttons/add_to_cart.tpl" but_id=$_but_id but_name="dispatch[checkout.add..`$obj_id`]" but_role=$but_role block_width=$block_width obj_id=$obj_id product=$product but_meta=$add_to_cart_meta}

            {$cart_button_exists = true}
        {/if}
        {/if}
