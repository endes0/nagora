<div id="admingen" class="tabelem padded_top_bottom" title="{$c->__('admin.general')}">
<form name="admin" id="adminform" action="#" method="post">
    <br />
    <h3>{$c->__('admin.general')}</h3>
    <div>
        <label for="da">{$c->__('general.language')}</label>
        <div class="select">
            <select id="locale" name="locale">
                <option value="en">English (default)</option>
                {loop="$langs"}
                    <option value="{$key}"
                            dir="auto"
                    {if="$conf->locale == $key"}
                        selected="selected"
                    {/if}>
                        {$value}
                    </option>
                {/loop}
            </select>
        </div>
    </div>

    <div>
        <div class="select">
            <select id="loglevel" name="loglevel">
                {loop="$logs"}
                    <option value="{$key}"
                    {if="$conf->loglevel == $key"}
                        selected="selected"
                    {/if}>
                        {$value}
                    </option>
                {/loop}
            </select>
        </div>
        <label for="loglevel">{$c->__('general.log_verbosity')}</label>
    </div>

    <div>
        <div class="select">
            <select id="timezone" name="timezone">
                {loop="$timezones"}
                    <option value="{$key}"
                    {if="$conf->timezone == $key"}
                        selected="selected"
                    {/if}>
                        {$value}
                    </option>
                {/loop}
            </select>
        </div>
        <label for="timezone">{$c->__('general.timezone')} - <span class="dTimezone">{$c->date($conf->timezone)}</span></label>
    </div>

    <div>
        <ul class="list thick">
            <li class="wide">
                <span class="control">
                    <div class="checkbox">
                        <input
                            {if="$conf->restrictsuggestions"}
                                checked
                            {/if}
                            type="checkbox"
                            id="restrictsuggestions"
                            name="restrictsuggestions"/>
                        <label for="restrictsuggestions"></label>
                    </div>
                </span>
                <p>{$c->__('restrictsuggestions.title')}</p>
                <p class="all">{$c->__('restrictsuggestions.text')}</p>
            </li>
        </ul>
    </div>

    <br />

    <h3>{$c->__('xmpp.title')}</h3>

    <div>
        <input type="text" name="xmppdomain" id="xmppdomain" placeholder="server.tld" value="{$conf->xmppdomain}" />
        <label for="xmppdomain">{$c->__('xmpp.domain')}</label>
    </div>

    <div>
        <textarea type="text" name="xmppdescription" id="xmppdescription" placeholder="{$c->__('xmpp.description')}" />{$conf->xmppdescription}</textarea>
        <label for="xmppdescription">{$c->__('xmpp.description')}</label>
    </div>

    <div>
        <div class="select">
            <select id="xmppcountry" name="xmppcountry">
                <option value="">{$c->__('xmpp.country_pick')}</option>
                {loop="$countries"}
                    <option value="{$key}"
                    {if="$conf->xmppcountry == $key"}
                        selected="selected"
                    {/if}>
                        {$value}
                    </option>
                {/loop}
            </select>
        </div>
        <label for="xmppcountry">{$c->__('xmpp.country')}</label>
    </div>

    <br />

    <h3>{$c->__('whitelist.title')}</h3>

    <div>
        <input type="text" name="xmppwhitelist" id="xmppwhitelist" placeholder="{$c->__('whitelist.label')}" value="{$conf->xmppwhitelist}" />
        <label for="xmppwhitelist">{$c->__('whitelist.label')}</label>
    </div>

    <ul class="list thick">
        <li>
            <span class="primary icon bubble color blue">
                <i class="zmdi zmdi-info"></i>
            </span>
            <p>{$c->__('whitelist.info1')}</p>
            <p>{$c->__('whitelist.info2')}</p>
        </li>
    </ul>

    <br />
    <h3>{$c->__('information.title')}</h3>

    <div>
        <textarea type="text" name="description" id="description" placeholder="{$conf->description}"/>{$conf->description}</textarea>
        <label for="description">{$c->__('information.description')}</label>
    </div>
    <div class="clear"></div>

    <div>
        <textarea type="text" name="info" id="info" placeholder="{$c->__('information.label')}" />{$conf->info}</textarea>
        <label for="info">{$c->__('information.label')}</label>
    </div>

    <ul class="list thick">
        <li>
            <span class="primary icon bubble color blue">
                <i class="zmdi zmdi-info"></i>
            </span>
            <p>{$c->__('information.info1')}</p>
            <p>{$c->__('information.info2')}</p>
        </li>
    </ul>

    <br />
    <h3>{$c->__('credentials.title')}</h3>

    <div>
        <label for="username">{$c->__('credentials.username')}</label>
        <input type="text" id="username" name="username" value="{$conf->username}"/>
    </div>
    <div class="clear"></div>

    <div>
        <input type="password" id="password" name="password" value="" placeholder="{$c->__('credentials.password')}"/>
        <label for="password">{$c->__('credentials.password')}</label>
    </div>
    <div>
        <input type="password" id="repassword" name="repassword" value="" placeholder="{$c->__('credentials.re_password')}"/>
        <label for="repassword">{$c->__('credentials.re_password')}</label>
    </div>

    <input
    type="submit"
    class="button color green oppose"
    value="{$c->__('button.save')}"/>
    <div class="clear"></div>
</form>
</div>
