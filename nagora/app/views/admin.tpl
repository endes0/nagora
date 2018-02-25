<main>
    <section>
        <div>
            <header>
                <ul class="list middle">
                    <li>

                        <span class="primary active icon gray">
                            <a href="<?php echo \Movim\Route::urlize('main'); ?>">
                                <i class="zmdi zmdi-arrow-left"></i>
                            </a>
                        </span>
                        <p class="center"><?php this.echo(Locale.start().translate('page.administration')); ?></p>
                    </li>
                </ul>
            </header>
            <?hhp this.widget('Tabs');?>
            <?hhp this.widget('AdminTest');?>
            <?hhp this.widget('AdminMain');?>
            <?hhp this.widget('Statistics');?>
            <?hhp this.widget('Api');?>
        </div>
    </section>
</main>
