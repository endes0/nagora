<?hhp if(this.action != null) { ?>
<a href="#" onclick="Main.openurl(<?hhp this.echo(this.action); ?>)">
<?hhp } else if(this.onclick != null) { ?>
<a href="#" onclick="app.widgets.notification.Notification.make_onclick(<?hhp this.echo(this.onclick); ?>);">
<?hhp } ?>
    <ul class="list">
        <li>
        <?hhp if(this.picture != null) { ?>
            <span class="primary icon bubble"><img src="<?hhp this.echo(this.picture); ?>"></span>
        <?hhp } ?>
        <p><?hhp this.echo(this.title); ?></p>
        <?hhp if(this.body != null) { ?>
            <p><?hhp this.echo(this.body); ?></p>
        <?hhp } ?>
        </li>
    </ul>
<?hhp if(this.action != null || this.onclick != null) { ?>
</a>
<?hhp } ?>
