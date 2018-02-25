<?hhp if(this.user.isLogged()) { ?>
    <?hhp this.widget('Search');?>
    <?hhp this.widget('Notification');?>
    <?hhp this.widget('VisioLink');?>

    <nav class="color dark">
        <?hhp this.widget('Presence');?>
        <?hhp this.widget('Navigation');?>
    </nav>
<?php } ?>

<main style="background-color: var(--movim-background);">
    <section>
        <?hhp if(this.user.isLogged()) { ?>
            <aside>
                <?hhp this.widget('NewsNav');?>
            </aside>
        <?hhp } ?>
        <div>
            <?hhp this.widget('Blog');?>
        </div>
    </section>
</main>
