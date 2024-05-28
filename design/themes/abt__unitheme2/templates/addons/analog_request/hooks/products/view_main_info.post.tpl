{* The scroller on the product page *}

<div class="ty-analog-items-product">
    {include file="addons/extended_out_of_stock_actions/views/product_scroller.tpl" items=fn_extended_out_of_stock_actions_get_analogues($product.product_id) block=fn_scroller_properties() hide_wishlist_button=true hide_compare_list_button=true}
</div>
