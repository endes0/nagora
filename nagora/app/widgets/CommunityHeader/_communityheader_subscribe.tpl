<section>
    <form name="subscribe" onsubmit="return false;">
         <h3>{$c->__('communityheader.subscribe')}</h3>
        <div>
            <input
                name="label"
                type="text"
                title="{$c->__('communityheader.label_label')}"
                placeholder="{$c->__('communityheader.label_placeholder')}"
                {if="$info"}
                    value="{$info->name}"
                {/if}
            />
            <label for="label">{$c->__('communityheader.label_label')}</label>
        </div>

        <div class="checkbox">
            <ul class="list thick">
                <li class="wide">
                    <span class="control">
                        <div class="control action">
                            <div class="checkbox">
                                <input id="share" name="share" type="checkbox">
                                <label for="share"></label>
                            </div>
                        </div>
                    </span>
                    <p class="line">{$c->__('communityheader.share_subscription')}</p>
                    <p>{$c->__('communityheader.share_subscription_text')}</p>
                </li>
            </ul>
        </div>
    </form>
</section>
<div>
    <button onclick="Dialog_ajaxClear()" class="button flat">
        {$c->__('button.cancel')}
    </button>
    <button
        onclick="CommunityHeader_ajaxSubscribe(MovimUtils.formToJson('subscribe'), '{$server|echapJS}', '{$node|echapJS}'); Dialog_ajaxClear()"
        class="button flat">
        {$c->__('communityheader.subscribe')}
    </button>
</div>
