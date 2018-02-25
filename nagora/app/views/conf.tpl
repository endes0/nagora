<?hhp this.widget('Search');?>
<?hhp this.widget('VisioLink');?>
<?hhp this.widget('Notification');?>
<?hhp this.widget('Onboarding');?>

<nav class="color dark">
    <?hhp this.widget('Presence');?>
    <?hhp this.widget('Navigation');?>
</nav>

<main>
    <section>
        <div>
            <header>
                <ul class="list middle">
                    <li>
                        <span id="menu" class="primary icon active gray" >
                            <i class="zmdi zmdi-menu on_mobile" onclick="MovimTpl.toggleMenu()"></i>
                            <i class="zmdi zmdi-settings on_desktop"></i>
                        </span>
                        <p class="center"><?php this.echo(Locale.start().translate('page.configuration')); ?></p>
                    </li>
                </ul>
            </header>

            <?hhp this.widget('Tabs');?>
            <?hhp this.widget('Vcard4');?>
            <?hhp if(this.user.isSupported('pubsub')) { ?>
                <?hhp this.widget('Avatar');?>
                <?hhp this.widget('Config');?>
            <?hhp } ?>
            <?hhp this.widget('Account');?>
            <?hhp this.widget('AdHoc');?>
        </div>
    </section>
</main>
