<div class="sidebar-row">
<h6>{__("admin_search_title")}</h6>

{if $page_part}
    {assign var="_page_part" value="#`$page_part`"}
{/if}

<form action="{""|fn_url}{$_page_part}" name="{$product_search_form_prefix}search_form" method="get" class="cm-disable-empty-all {$form_meta}">
<input type="hidden" name="type" value="{$search_type|default:"simple"}" />
{if $smarty.request.redirect_url}
    <input type="hidden" name="redirect_url" value="{$smarty.request.redirect_url}" />
{/if}
{if $selected_section != ""}
    <input type="hidden" id="selected_section" name="selected_section" value="{$selected_section}" />
{/if}

{if $put_request_vars}
    {array_to_fields data=$smarty.request skip=["callback"]}
{/if}

{$extra nofilter}

{capture name="simple_search"}
    <div class="sidebar-field">
        <label>{__("id")}</label>
        <input type="text" name="id" size="20" value="{$search.id}" />
    </div>

    <div class="sidebar-field">
        <label>{__("person_name")}</label>
        <input type="text" name="name" size="20" value="{$search.name}" />
    </div>

    <div class="sidebar-field">
        <label>{__("phone")}</label>
        <input type="text" name="phone" size="20" value="{$search.phone}" />
    </div>

    <div class="sidebar-field">
        <label>{__("email")}</label>
        <input type="text" name="phone" size="20" value="{$search.email}" />
    </div>

{/capture}



{include file="common/advanced_search.tpl" simple_search=$smarty.capture.simple_search advanced_search=$smarty.capture.advanced_search dispatch=$dispatch view_type="products"}

</form>

</div><hr>
