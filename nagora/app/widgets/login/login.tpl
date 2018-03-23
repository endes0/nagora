<div id="login_widget">
    <script type="text/javascript">
        /*if(typeof navigator.registerProtocolHandler == 'function') {
            navigator.registerProtocolHandler('xmpp',
                                          '{$c->route("share")}/%s',
                                          'Movim');
        }*/

        Login.domain = '<?hhp this.echo(this.data.domain); ?>';
    </script>

    <div id="form" class="dialog">
        <section>
            <h3><?hhp this.echo(movim.i18n.Locale.start().translate('page.login')); ?></h3>
            <?hhp if(this.data.invitation != null) { ?>
                <br />
                <ul class="list middle">
                    <li>
                        <//?hhp var url = $contact->getPhoto('m') ?>
                        <?hhp if(/*this.data.url != null*/false) { ?>
                            <span class="primary icon bubble" style="background-image: url(<?hhp this.echo(this.data.url); ?>);">
                            </span>
                        <?hhp } else { ?>
                            <span class="primary icon bubble color <//?hhp $contact->jid|stringToColor ?>">
                                <//?hhp $contact->getTrueName()|firstLetterCapitalize ?>
                            </span>
                        <?hhp } ?>
                        <p></p>
                        <p class="all"><?hhp this.echo(movim.i18n.Locale.start().translate('form.invite_chatroom'/*, $contact->getTrueName()*/)); ?> - <//?hhp $invitation->resource ?></p>
                    </li>
                </ul>
            <?hhp } ?>

            <form
                method="post" action="login"
                name="login">
                <div>
                    <input type="text" id="complete" tabindex="-1"/>
                    <input type="text" pattern="^[^\u0000-\u001f\u0020\u0022\u0026\u0027\u002f\u003a\u003c\u003e\u0040\u007f\u0080-\u009f\u00a0]+@[a-z0-9.-]+\.[a-z]{2,10}$" name="username" id="username" autofocus required
                        placeholder="username@server.com"/>
                    <label for="username"><?hhp this.echo(movim.i18n.Locale.start().translate('form.username')); ?></label>
                </div>
                <div>
                    <input type="password" name="password" id="password" required
                        placeholder="<?hhp this.echo(movim.i18n.Locale.start().translate('form.password')); ?>"/>
                    <label for="password"><?hhp this.echo(movim.i18n.Locale.start().translate('form.password')); ?></label>
                </div>
                <div>
                    <ul class="list thin">
                        <li>
                            <p class="center">
                                <input
                                    type="submit"
                                    disabled
                                    data-loading="<?hhp this.echo(movim.i18n.Locale.start().translate('button.connecting')); ?>…"
                                    value="<?hhp this.echo(movim.i18n.Locale.start().translate('page.login')); ?>"
                                    class="button color"/>
                                <a class="button flat" href="#" onclick="Main.change_page('account')">
                                    <?hhp this.echo(movim.i18n.Locale.start().translate('button.sign_up')); ?>
                                </a>
                            </p>
                        </li>
                    </ul>
                </div>
            </form>

            <?hhp if(this.data.info != null && this.data.info != '') { ?>
            <ul class="list thin card">
                <li class="info">
                    <p></p>
                    <p class="center normal"><?hhp this.echo(this.data.info); ?></p>
                </li>
            </ul>
            <?hhp } ?>

            <?hhp if(this.data.whitelist != null && this.data.whitelist != '') { ?>
            <ul class="list thin">
                <li class="info">
                    <p></p>
                    <p class="center normal"><?hhp this.echo(movim.i18n.Locale.start().translate('form.whitelist_info')); ?> : <?hhp this.echo(this.data.whitelist); ?></p>
                </li>
            </ul>
            <?hhp } ?>

            <span class="info"><?hhp this.echo(movim.i18n.Locale.start().translate('form.connected')); ?> <?hhp this.echo(this.data.connected); ?> / <?hhp this.echo(this.data.pop); ?></span>
        </section>
    </div>

    <div id="error" class="dialog actions">
        <?hhp this.echo(this.data.error); ?>
    </div>

    <footer>
    </footer>
</div>
