<section>
    <form name="bookmarkmucadd">
        {if="isset($conference)"}
            <h3>{$c->__('rooms.edit')}</h3>
        {else}
            <h3>{$c->__('rooms.add')}</h3>
        {/if}

        <div>
            <input
                {if="isset($conference)"}
                    value="{$conference->conference}" disabled
                {elseif="isset($id)"}
                    value="{$id}" disabled
                {/if}
                name="jid"
                {if="isset($info)"}
                    placeholder="chatroom@{$info->server}"
                {else}
                    placeholder="chatroom@server.com"
                {/if}
                type="email"
                list="suggestions"
                oninput="Rooms.suggest()"
                required />
            <label>{$c->__('chatrooms.id')}</label>
        </div>

        <datalist id="suggestions">
        </datalist>

        <div>
            <input
                {if="isset($conference)"}
                    value="{$conference->name}"
                {elseif="isset($info)"}
                    value="{$info->name}"
                {/if}
                name="name"
                placeholder="{$c->__('chatrooms.name_placeholder')}"
                required />
            <label>{$c->__('chatrooms.name')}</label>
        </div>
        <div>
            <input
                {if="isset($conference) && !empty($conference->nick)"}
                    value="{$conference->nick}"
                {else}
                    value="{$username}"
                {/if}
                name="nick"
                placeholder="{$username}"/>
            <label>{$c->__('chatrooms.nickname')}</label>
        </div>
        <div>
            <ul class="list thick">
                <li class="wide">
                    <span class="control">
                        <div class="checkbox">
                            <input
                                {if="isset($conference) && $conference->autojoin"}
                                    checked
                                {/if}
                                type="checkbox"
                                id="autojoin"
                                name="autojoin"/>
                            <label for="autojoin"></label>
                        </div>
                    </span>
                    <p></p>
                    <p class="normal">{$c->__('chatrooms.autojoin')}</p>
                </li>
            </ul>
        </div>
    </section>
    <div>
        <button class="button flat" onclick="Dialog_ajaxClear()">
            {$c->__('button.cancel')}
        </button>
        <button
            class="button flat"
            onclick="Rooms_ajaxChatroomAdd(MovimUtils.formToJson('bookmarkmucadd'));">
            {if="isset($conference)"}
                {$c->__('button.edit')}
            {else}
                {$c->__('button.add')}
            {/if}
        </button>
    </div>
</div>
