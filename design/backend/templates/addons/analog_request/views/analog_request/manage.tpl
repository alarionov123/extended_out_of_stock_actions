{capture name="mainbox"}

<form action="{""|fn_url}" method="post" name="manage_extended_out_of_stock_actionss_form" class="form-horizontal form-edit cm-ajax" id="manage_extended_out_of_stock_actions_form">
<input type="hidden" name="result_ids" value="pagination_contents,tools_call_request_buttons" />

{include file="common/pagination.tpl" save_current_page=true save_current_url=true div_id=$smarty.request.content_id}

{$return_url = $config.current_url|escape:"url"}
{$c_url = $config.current_url|fn_query_remove:"sort_by":"sort_order"}

{if $requests}
    {capture name="extended_out_of_stock_actions_table"}
        <div class="table-responsive-wrapper longtap-selection">
            <table width="100%" class="table table-middle table-responsive table--overflow-hidden">
            <thead>
                <tr>
                    <th class="left table__check-items-column">
                    </th>
                    <th width="15%">
                        {include file="common/table_col_head.tpl" type="id"}
                    <th width="17%">
                        {include file="common/table_col_head.tpl" type="date"}
                    </th>
                    <th width="15%">
                        {include file="common/table_col_head.tpl"
                            type="name"
                            text=__("analog_request.name")
                        }
                    </th>
                    <th width="15%">
                        {include file="common/table_col_head.tpl"
                        type="name"
                        text=__("analog_request.quantity")
                        }
                    </th>
                    <th width="25%">
                        {include file="common/table_col_head.tpl"
                        type="name"
                        text=__("analog_request.phone_or_email")
                        }
                    </th>
                </tr>
            </thead>
            {foreach $requests as $request}

                <tbody class="cm-row-item cm-row-status-{$request.status|lower} cm-longtap-target"
                       data-ca-longtap-action="setCheckBox"
                       data-ca-longtap-target="input.cm-item"
                       data-ca-id="{$request.request_id}"
                >
                    <tr>
                        <td class="left mobile-hide table__check-items-cell">
                            <input type="checkbox" name="request_ids[]" value="{$request.request_id}" class="cm-item cm-item-status-{$request.status|lower} hide" />
                        </td>
                        <td width="15%" class="table__first-column" data-th="{__("id")}">
                            {$request.request_id}
                        </td>
                        <td width="17%" data-th="{__("date")}">{$request.timestamp|date_format:"`$settings.Appearance.date_format`, `$settings.Appearance.time_format`"}</td>
                        <td width="15%" data-th="{__("analog_request.name")}">{$request.name}</td>
                        <td width="15%" data-th="{__("analog_request.quantity")}">{$request.quantity}</td>
                        <td width="15%" data-th="{__("analog_request.phone_or_email")}">{$request.phone}<br>{$request.email}</td>

                        <td class="nowrap">
                            <div class="hidden-tools">
                                {capture name="tools_list"}
                                    <li>{btn type="list" text=__("delete") href="analog_request.delete?request_id=`$request.request_id`" class="cm-confirm" method="POST"}</li>
                                {/capture}
                                {dropdown content=$smarty.capture.tools_list}
                            </div>
                        </td>

                        <td width="25%" data-th="{__("status")}" class="right nowrap">
                            <div id="requests_status_{$request.request_id}">
                                {include file="common/select_popup.tpl" popup_additional_class="dropleft" id=$request.request_id status=$request.status update_controller="analog_request" items_status=$request_statuses btn_meta="btn btn-info btn-small cr-btn-status-{$request.status}"|lower extra="&return_url={$return_url}" st_result_ids="requests_status_{$request.request_id}"}
                            <!--requests_status_{$request.request_id}--></div>
                        </td>
                    </tr>
                    <tr class="cr-table-detail">
                        <td class="mobile-hide table__check-items-cell">&nbsp;</td>
                        <td class="table__first-column {if !$request.product_id && !$request.product_name}mobile-hide"{/if}" colspan="3" valign="top">
                            {if $request.product_id}
                                <div>
                                    <span>{__("analog_request.requested_product")}:</span><br>
                                    <a href="{fn_url("products.update?product_id={$request.product_id}")}">{$request.product_name}</a>
                                </div>
                            {/if}
                        </td>

                    </tr>
                </tbody>
            {/foreach}
            </table>
        </div>
    {/capture}

    {include file="common/context_menu_wrapper.tpl"
        form="manage_extended_out_of_stock_actions_form"
        object="requests"
        items=$smarty.capture.extended_out_of_stock_actions_table
    }
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{capture name="buttons"}
    {if $requests}
        {include file="buttons/save.tpl" but_name="dispatch[analog_request.m_update]" but_role="submit-link" but_target_form="manage_extended_out_of_stock_actions_form"}
    {/if}
{/capture}

<div class="clearfix">
    {include file="common/pagination.tpl" div_id=$smarty.request.content_id}
</div>

</form>
{/capture}

{capture name="sidebar"}
    {include file="common/saved_search.tpl" dispatch="analog_request.manage" view_type="requests"}
    {include file="addons/analog_request/views/analog_request/components/requests_search_form.tpl" dispatch="analog_request.manage"}
{/capture}

{include file="common/mainbox.tpl" title=__("request_analog_list") content=$smarty.capture.mainbox buttons=$smarty.capture.buttons sidebar=$smarty.capture.sidebar content_id="analog_request"}
