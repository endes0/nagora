<section>
    <h3>{$c->__('roster.add_title')}</h3>
    <ul class="list">
        <li>
            <form name="add" onsubmit="return false;">
                <div>
                    <input
                        name="searchjid"
                        id="searchjid"
                        type="email"
                        title="{$c->__('roster.jid')}"
                        placeholder="user@server.tld"
                        {if="$jid != null"}
                            value="{$jid}"
                        {/if}
                        onkeyup="{$search}"
                    />
                    <label for="searchjid">{$c->__('roster.add_contact_info1')}</label>
                    <p class="error"></p>
                </div>
                <div>
                    <input
                        name="alias"
                        id="alias"
                        class="tiny"
                        placeholder="{$c->__('edit.alias')}"
                    />
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
                    />
                    <label for="group">{$c->__('edit.group')}</label>
                </div>
            </form>
        </li>
    </ul>
    <div id="search_results">

    </div>
</section>
<div>
    <button onclick="Dialog_ajaxClear()" class="button flat">
        {$c->__('button.close')}
    </button>
    <button onclick="Roster_ajaxAdd(MovimUtils.formToJson('add'))" class="button flat">
        {$c->__('button.add')}
    </button>
</div>
