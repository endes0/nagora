<main>
    <section>
        <div>
            <header>
                <ul class="list middle">
                    <li>

                        <span class="primary active icon gray">
                            <a href="<?hhp this.echo(movim.Route.urlize('main')); ?>">
                                <i class="zmdi zmdi-arrow-left"></i>
                            </a>
                        </span>
                        <p class="center"><?hhp this.echo(movim.i18n.Locale.start().translate('page.administration')); ?></p>
                    </li>
                </ul>
            </header>
            <?hhp this.widget('AdminLogin');?>
        </div>
    </section>
</main>
