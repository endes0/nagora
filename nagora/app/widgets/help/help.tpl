<div class="tabelem" title="<?hhp this.echo(movim.i18n.Locale.start().translate('page.help')); ?>" id="help_widget">
    <ul class="list thick block divided">
        <li class="subheader">
            <p><?hhp this.echo(movim.i18n.Locale.start().translate('apps.question')); ?></p>
        </li>
        <li class="block">
            <span class="primary icon bubble color green">
                <i class="zmdi zmdi-android"></i>
            </span>
            <p><?hhp this.echo(movim.i18n.Locale.start().translate('apps.phone')); ?><p>
            <p class="all">
                <?hhp this.echo(movim.i18n.Locale.start().translate('apps.android')); ?>
                <br />
                <a class="button flat" href="#" onclick="Main.openurl('https://play.google.com/store/apps/details?id=com.movim.movim')">
                    <i class="zmdi zmdi-google-play"></i> Play Store
                </a>
                <a class="button flat" href="#" onclick="Main.openurl('https://f-droid.org/packages/com.movim.movim/')">
                    <i class="zmdi zmdi-android-alt"></i> F-Droid
                </a>
                <br />
                <?hhp this.echo(movim.i18n.Locale.start().translate('apps.recommend')); ?> Conversations
                <br />
                <a class="button flat" href="#" onclick="Main.openurl('https://play.google.com/store/apps/details?id=eu.siacs.conversations')">
                    <i class="zmdi zmdi-google-play"></i> Play Store
                </a>
                <a class="button flat" href="#" onclick="Main.openurl('https://f-droid.org/packages/eu.siacs.conversations/')">
                    <i class="zmdi zmdi-android-alt"></i> F-Droid
                </a>
            </p>
        </li>
        <li class="block">
            <span class="primary icon bubble color purple">
                <i class="zmdi zmdi-desktop-windows"></i>
            </span>
            <p><?hhp this.echo(movim.i18n.Locale.start().translate('apps.computer')); ?><p>
            <p class="all">
                <a href="#" onclick="Main.openurl('https://movim.eu/#apps')">
                    <?hhp this.echo(movim.i18n.Locale.start().translate('apps.computer_text')); ?>
                </a>
            </p>
        </li>
    </ul>
    <?hhp if(this.data != null) { ?>
    <?hhp if(this.data.info.adminaddresses != null || this.data.info.abuseaddresses != null || this.data.info.supportaddresses != null || this.data.info.securityaddresses != null) { ?>
        <hr />
        <ul class="list thin flex">
            <li class="subheader block large">
                <p class="normal"><?hhp this.echo(movim.i18n.Locale.start().translate('contact.title')); ?></p>
            </li>
            <hr />
            //TODO: remove duplicates
            <?hhp var addresses : Array<String> = this.data.info.adminaddresses.concat(this.data.info.abuseaddresses).concat(this.data.info.supportaddresses).concat(this.data.info.securityaddresses); ?>
            <?hhp for(value in addresses) { ?>
                <li class="block">
                    <?hhp var parsed = #if hxnodejs
                                          new js.html.URL(value);
                                       #end ?>
                    <?hhp if(parsed.protocol == 'xmpp') { ?>
                        <?hhp if(parsed.search != null && parsed.search == 'join') { ?>
                        <span class="primary icon gray">
                            <i class="zmdi zmdi-comments"></i>
                        </span>
                        <p class="normal">
                            <a href="<?hhp this.echo(this.route('chat', [parsed.pathname, 'room'])); ?>">
                                <?hhp this.echo(parsed.pathname); ?>
                            </a>
                        </p>
                        <?hhp } else { ?>
                        <span class="primary icon gray">
                            <i class="zmdi zmdi-comment"></i>
                        </span>
                        <p class="normal">
                            <a href="<?hhp this.echo(this.route('chat', parsed.pathname)); ?>">
                                <?hhp this.echo(parsed.pathname); ?>
                            </a>
                        </p>
                        <?hhp } ?>
                    <?hhp } else { ?>
                        <span class="primary icon gray">
                            <i class="zmdi zmdi-email"></i>
                        </span>
                        <p class="normal">
                            <a href="<?hhp this.echo(value); ?>" target="_blank" rel="noopener noreferrer">
                                <?hhp this.echo(parsed.pathname); ?>
                            </a>
                        </p>
                    <?hhp } ?>
                </li>
            <?hhp } ?>
        </ul>
    <?hhp } ?>
    <?hhp } ?>
    <hr />
    <ul class="list divided middle">
        <li class="subheader">
            <p><?hhp this.echo(movim.i18n.Locale.start().translate('page.help')); ?></p>
        </li>
        <li class="block">
            <span class="primary icon gray">
                <i class="zmdi zmdi-comment-text-alt"></i>
            </span>
            <p><?hhp this.echo(movim.i18n.Locale.start().translate('chatroom.question')); ?></p>
            <p class="all">
                <a id="AddChatroom" href="#">
                    <?hhp this.echo(movim.i18n.Locale.start().translate('chatroom.button')); ?> movim@conference.movim.eu
                </a>
            </p>
        </li>
    </ul>
</div>
