<div class="hidden" id="request_analog_{$object_id}" title="{__("request_analog")}">
    <form action="{""|fn_url}" method="post" class="{if !$no_ajax}cm-ajax{/if} cm-form-dialog-closer" name="request_analogs_{$object_id}" id="form_form_{$object_id}">
        <input type="hidden" name="result_ids" value="new_thread_message_{$object_id},threads_container" />
        <input type="hidden" name="redirect_url" value="{if $redirect_url}{$redirect_url}{else}{$config.current_url}{/if}" />
        <input type="hidden" name="call_data[product_id]" value="{$product.product_id}" />
        <div class="ty-analog-items">
            {include file="blocks/products/products_scroller_advanced.tpl" items=fn_extended_out_of_stock_actions_get_analogues($object_id) block=fn_scroller_properties() hide_wishlist_button=true hide_compare_list_button=true}
        </div>
        <div id="new_request_analog_{$object_id}">
            <div class="ty-control-group">
                <label class="ty-control-group__title" for="call_data_{$id}_name">{__("your_name")}</label>
                <input id="call_data_{$id}_name" size="50" class="ty-input-text-full" type="text" name="call_data[name]" value="{$call_data.name}" />
            </div>
            <div class="ty-control-group">
                <label for="call_data_{$id}_quantity" class="ty-control-group__title">{__("quantity")}</label>
                <input id="call_data_{$id}_quantity" class="ty-input-text-full" size="50" type="text" name="call_data[quantity]" value="{$call_data.quantity}" />
            </div>
            <div class="ty-control-group">
                <label for="call_data_{$id}_phone" class="ty-control-group__title cm-phone cm-required">{__("phone")}</label>
                <input id="call_data_{$id}_phone" class="ty-input-text-full" size="50" type="text" name="call_data[phone]" value="{$call_data.phone}" />
            </div>
            <div class="ty-control-group">
                <label for="call_data_{$id}_email" class="ty-control-group__title cm-email cm-required">{__("email")}</label>
                <input id="call_data_{$id}_email" class="ty-input-text-full" size="50" type="text" name="call_data[email]" value="{$call_data.email}" />
            </div>
            <br>
            <!--new_request_analog_{$object_id}--></div>
        <div class="buttons-container">
            {include file="buttons/button.tpl" but_text=__("send") but_meta="ty-btn__primary ty-btn__big cm-form-dialog-closer ty-btn" but_role="submit" but_name="dispatch[extended_out_of_stock_actions.request_analog]"}
        </div>
    </form>
</div>
