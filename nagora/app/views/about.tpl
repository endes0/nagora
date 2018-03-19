<main>
    <section>
        <div>
            <header>
                <ul class="list middle">
                    <li>
                        <span class="primary active icon gray">
                            <a href="#" onclick="Main.change_page('main')">
                                <i class="zmdi zmdi-arrow-left"></i>
                            </a>
                        </span>
                        <p class="center"><?php this.echo(Locale.start().translate('page.about')); ?></p>
                    </li>
                </ul>
            </header>
            <?hhp this.widget('Tabs');?>

            <?hhp this.widget('About');?>
            <?hhp this.widget('Help');?>
            <?hhp this.widget('Caps');?>
        </div>
    </section>
</main>
