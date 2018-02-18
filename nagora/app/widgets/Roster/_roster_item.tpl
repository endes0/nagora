<li
    id="{$contact->jid|cleanupId}"
    title="{$contact->jid}{if="$contact->value"} - {$presences[$contact->value]}{/if}"
    name="{$contact->getSearchTerms()}"
    class="block"
    onclick="
        MovimUtils.redirect('{$c->route('contact', $contact->jid)}')
    ">
    {$url = $contact->getPhoto('s')}
    {if="$url"}
        <span class="primary icon bubble
            {if="$contact->value == null || $contact->value > 4"}disabled{/if}
            {if="$contact->value"}
                status {$presencestxt[$contact->value]}
            {/if}"
            style="background-image: url({$url});">
        </span>
    {else}
        <span class="primary icon bubble color {$contact->jid|stringToColor}
            {if="$contact->value == null || $contact->value > 4"}disabled{/if}
            {if="$contact->value"}
                status {$presencestxt[$contact->value]}
            {/if}"
        ">
            {$contact->getTrueName()|firstLetterCapitalize}
        </span>
    {/if}
    {if="$contact->rostersubscription != 'both'"}
    <span class="control icon gray">
        {if="$contact->rostersubscription == 'to'"}
            <i class="zmdi zmdi-arrow-in"></i>
        {elseif="$contact->rostersubscription == 'from'"}
            <i class="zmdi zmdi-arrow-out"></i>
        {else}
            <i class="zmdi zmdi-block"></i>
        {/if}
    </span>
    {/if}
    <p class="normal line">{$contact->getTrueName()}</p>
    {if="$contact->groupname"}
    <p>
        <span class="tag color {$contact->groupname|stringToColor}">
            {$contact->groupname}
        </span>
    </p>
    {/if}
</li>
