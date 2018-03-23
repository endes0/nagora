<section>
    <h3><?hhp this.echo(movim.i18n.Locale.start().translate('error.oops')); ?></h3>
    <br />
    <h4 class="gray"><?hhp this.echo(this.error); ?></h4>
</section>
<div>
    <span
        class="button flat oppose"
        onclick="Main.change_page('disconnect')">
        <?hhp this.echo(movim.i18n.Locale.start().translate('button.return')); ?>
    </span>
</div>
