{component name="configurable_page.field" entity="products" tab="detailed" section="availability" field="out_of_stock_actions"}
    <div class="control-group">
        <label class="control-label" for="elm_out_of_stock_actions">{__("out_of_stock_actions")}:</label>
        <div class="controls">
            <select class="span3" name="product_data[out_of_stock_actions]" id="elm_out_of_stock_actions">
                <option value="N" {if $product_data.out_of_stock_actions == "N"}selected="selected"{/if}>{__("none")}</option>
                <option value="B" {if $product_data.out_of_stock_actions == "B"}selected="selected"{/if}>{__("buy_in_advance")}</option>
                <option value="S" {if $product_data.out_of_stock_actions == "S"}selected="selected"{/if}>{__("sign_up_for_notification")}</option>
                <option value="R" {if $product_data.out_of_stock_actions == "R"}selected="selected"{/if}>{__("request_analog")}</option>
            </select>
            <p class="muted description">{__("tt_views_products_update_out_of_stock_actions")}</p>
        </div>
    </div>
{/component}