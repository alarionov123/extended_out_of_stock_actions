{hook name="ab__stickers:product_stickers_pre"}
  
                {if $details_page && $product.ab__stickers}
                <div class="ab-stickers-wrapper">
                {/if}
            {/hook}
                {if $product.ab__stickers}
                    {$pos = 'list'}

                    {if $smarty.request.dispatch == "products.view" && $block.type == "main"}
                        {$pos = "detailed_page"}
                        {$key_1 = "display_on_detailed_pages"}
                        {$key_2 = ""}
                    {elseif $block.type != "main" && $block.properties.template}
                        {$key_1 = "display_on_lists"}
                        {$key_2 = $block.properties.template}
                    {elseif $ab__stickers_current_tmpl}
                        {$key_1 = "display_on_lists"}
                        {$key_2 = $ab__stickers_current_tmpl}
                    {/if}

                    {$current_position = "output_position_{$pos}"}

                    {foreach $product.ab__stickers as $position}
                        {$pos_counter = 0}
                        <div class="ab-stickers-container ab-stickers-container__{$position@key}{$addons.ab__stickers.output_position} {$addons.ab__stickers.{"`$position@key``$addons.ab__stickers.output_position`_output_type"}}-filling">
                            {foreach $position as $sticker}
                            {if $sticker.sticker_id == 54 && $product.out_of_stock_actions === "R"}
                                {continue}
                            {/if}
                                {$view_type = $sticker.$key_1}
                                {if $key_2}
                                    {$view_type = $view_type.$key_2}
                                {/if}

                                {if $pos_counter < $addons.ab__stickers.{"`$position@key``$addons.ab__stickers.output_position`_max_count"}}
                                    {$pos_counter = $pos_counter + 1}
                                    <div class="ab-sticker-{$view_type|default:"full_size"}{if $sticker.style == $graphic_style} small-image-size-{$sticker.appearance.small_size_image_size} full-image-size-{$sticker.appearance.full_size_image_size}{/if}" data-ab-sticker-id="{$sticker@key}"{if $sticker.placeholders} data-placeholders='{$sticker.placeholders}'{/if}></div>
                                {/if}
                            {/foreach}
                        </div>
                    {/foreach}
                {/if}
            {if $details_page && $product.ab__stickers}
                </div>
            {/if}
