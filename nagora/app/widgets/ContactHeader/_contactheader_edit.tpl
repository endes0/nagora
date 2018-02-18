<section>
    <h3>{$c->__('edit.title')}</h3>
    <form name="manage">
        <div>
            <input
                name="alias"
                id="alias"
                class="tiny"
                placeholder="{$c->__('edit.alias')}"
                {if="$contact->rostername"}
                    value="{$contact->rostername}"
                {else}
                    value="{$contact->jid}"
                {/if}"/>
            <label for="alias">{$c->__('edit.alias')}</label>
        </div>
        <div>
            <datalist id="group_list" style="display: none;">
                {if="is_array($groups)"}
                    {loop="$groups"}
                        <option value="{$value}"/>
                    {/loop}
                {/if}
            </datalist>
            <input
                name="group"
                list="group_list"
                id="group"
                class="tiny"
                placeholder="{$c->__('edit.group')}"
                value="{$contact->groupname}"/>
            <label for="group">{$c->__('edit.group')}</label>
        </div>
        <input type="hidden" name="jid" value="{$contact->jid}"/>
    </form>
</section>
<div>
    <button onclick="Dialog_ajaxClear()" class="button flat">
        {$c->__('button.cancel')}
    </button>
    <button
        name="submit"
        class="button flat"
        onclick="{$submit} Dialog_ajaxClear()">
        {$c->__('button.save')}
    </button>
</div>
