<ul id="bottomnavigation" class="navigation color dark">
    <li onclick="MovimTpl.toggleMenu()">
        <span class="primary icon"><i class="zmdi zmdi-menu"></i></span>
    </li>
    {if="$c->supported('pubsub')"}
        <li {if="$page == 'news'"}class="active"{/if}
            onclick="MovimUtils.reload('{$c->route('news')}')"
            title="{$c->__('page.news')}"
        >
            <span class="primary icon"><i class="zmdi zmdi-receipt"></i></span>
            <span data-key="news" class="counter"></span>
        </li>
    {/if}
    <li {if="$page == 'contact'"}class="active"{/if}
        onclick="MovimUtils.reload('{$c->route('contact')}')"
        title="{$c->__('page.contacts')}"
    >
        <span class="primary icon"><i class="zmdi zmdi-accounts"></i></span>
        <span data-key="invite" class="counter"></span>
    </li>
    <li {if="$page == 'community'"}class="active"{/if}
        onclick="MovimUtils.reload('{$c->route('community')}')"
        title="{$c->__('page.communities')}"
    >
        <span class="primary icon"><i class="zmdi zmdi-group-work"></i></span>
        <span class="counter"></span>
    </li>
    <li {if="$page == 'chat'"}class="active"{/if}
        onclick="MovimUtils.reload('{$c->route('chat')}')"
        title="{$c->__('page.chats')}"
    >
        <span class="primary icon"><i class="zmdi zmdi-comments"></i></span>
        <span data-key="chat" class="counter"></span>
    </li>
</ul>
