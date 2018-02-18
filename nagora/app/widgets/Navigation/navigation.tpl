<ul class="list active" dir="ltr">
    {if="$c->supported('pubsub')"}
    <a class="classic"
       href="{$c->route('news')}"
       title="{$c->__('page.news')}">
        <li {if="$page == 'news' || $page == 'post'"}class="active"{/if}>
            <span class="primary icon"><i class="zmdi zmdi-receipt"></i></span>
            <span data-key="news" class="counter"></span>
            <p class="normal">{$c->__('page.news')}</p>
        </li>
    </a>
    {/if}
    <a class="classic" href="{$c->route('contact')}"
       title="{$c->__('page.contacts')}">
        <li {if="$page == 'contact'"}class="active"{/if}>
            <span class="primary icon"><i class="zmdi zmdi-accounts"></i></span>
            <span data-key="invite" class="counter"></span>
            <p class="normal">{$c->__('page.contacts')}</p>
        </li>
    </a>
    <a class="classic"
       href="{$c->route('community')}"
       title="{$c->__('page.communities')}">
        <li {if="$page == 'community'"}class="active"{/if}>
            <span class="primary icon"><i class="zmdi zmdi-group-work"></i></span>
            <span class="counter"></span>
            <p class="normal">{$c->__('page.communities')}</p>
        </li>
    </a>
    <a class="classic" href="{$c->route('chat')}"
       title="{$c->__('page.chats')}">
        <li {if="$page == 'chat'"}class="active"{/if}>
            <span class="primary icon"><i class="zmdi zmdi-comments"></i></span>
            <span data-key="chat" class="counter"></span>
            <p class="normal">{$c->__('page.chats')}</p>
        </li>
    </a>
</ul>

<ul class="list divided oppose active" dir="ltr">
    <li onclick="Search_ajaxRequest()"
        title="{$c->__('button.search')}"
    >
        <span class="primary icon">
            <i class="zmdi zmdi-search"></i>
        </span>
        <p class="normal">{$c->__('button.search')}</p>
    </li>
    <a class="classic"
       href="{$c->route('conf')}"
       title="{$c->__('page.configuration')}">
        <li {if="$page == 'conf'"}class="active"{/if}>
            <span class="primary icon">
                <i class="zmdi zmdi-settings"></i>
            </span>
            <p class="normal">{$c->__('page.configuration')}</p>
        </li>
    </a>
    <a class="classic on_mobile" href="#">
        <li onclick="MovimTpl.toggleMenu()">
            <span class="primary icon bubble"><i class="zmdi zmdi-arrow-back"></i></span>
            <p class="normal">{$c->__('button.close')}</p>
        </li>
    </a>
    <a class="classic on_desktop"
       href="{$c->route('help')}"
       title="{$c->__('page.help')}">
        <li {if="$page == 'help'"}class="active"{/if}>
            <span class="primary icon">
                <i class="zmdi zmdi-help"></i>
            </span>
            <p class="normal">{$c->__('page.help')}</p>
        </li>
    </a>
    <li class="on_desktop"
        onclick="Presence_ajaxLogout()"
        title="{$c->__('status.disconnect')}">
        <span class="primary icon"><i class="zmdi zmdi-sign-in"></i></span>
        <p class="normal">{$c->__('status.disconnect')}</p>
    </li>
</ul>

