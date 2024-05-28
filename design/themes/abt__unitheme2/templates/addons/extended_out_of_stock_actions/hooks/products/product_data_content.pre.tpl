{if
    $product.out_of_stock_actions === "R"
    && ($product.amount <= 0
    || $product.amount < $product.min_qty)
}
    {$show_add_to_cart_block=true}
    {$show_add_to_cart=true}
    {$show_discount_label=false scope=parent}
    {$show_shipping_label=false scope=parent}
    {$show_product_amount=true scope=parent}
    {$show_out_of_stock_block=false scope=parent}
{/if}
