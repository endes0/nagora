<?hhp this.widget('Notification');?>
<main>
    <section>
        <div>
            <header>
                <ul class="list middle">
                    <li>
                        <span class="primary active icon gray">
                            <a href="<?php echo \Movim\Route::urlize('account'); ?>">
                                <i class="zmdi zmdi-arrow-left"></i>
                            </a>
                        </span>
                        <p class="center"><?hhp this.echo(Locale.start().translate('page.account_creation')); ?></p>
                    </li>
                </ul>
            </header>
            <?hhp this.widget('AccountNext');?>
        </div>
    </section>
</main>
