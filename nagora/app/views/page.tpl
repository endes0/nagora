<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title><?hhp this.title(); ?></title>

    <meta name="theme-color" content="#1C1D5B" />

    <?php $this->meta(); ?>

    <meta name="application-name" content="Movim">
    <link rel="shortcut icon" href="<?hhp this.linkFile('img/favicon.ico');?>" />
    <link rel="icon" type="image/png" href="<?hhp this.linkFile('img/app/48.png');?>" sizes="48x48">
    <link rel="icon" type="image/png" href="<?hhp this.linkFile('img/app/96.png');?>" sizes="96x96">
    <link rel="icon" type="image/png" href="<?hhp this.linkFile('img/app/128.png');?>" sizes="128x128">
    <script src="/app/assets/js/favico.js"></script>
    <script src="<?hhp this.echo(movim.Route.urlize('system')); ?>"></script>

    <meta name="viewport" content="width=device-width, user-scalable=no">

    <?hhp
        this.addCss('style.css');
        this.addCss('notification.css');
        this.addCss('header.css');
        this.addCss('listn.css');
        this.addCss('grid.css');
        this.addCss('article.css');
        this.addCss('form.css');
        this.addCss('icon.css');
        this.addCss('dialog.css');
        this.addCss('drawer.css');
        this.addCss('card.css');
        this.addCss('table.css');
        this.addCss('color.css');
        this.addCss('block.css');
        this.addCss('menu.css');
        this.addCss('fonts.css');
        this.addCss('title.css');
        this.addCss('typo.css');
        this.addCss('scrollbar.css');
        this.addCss('material-design-iconic-font.min.css');

        this.scripts();
    ?>
    </head>
    <body dir="<?hhp this.dir();?>"
          class="<?hhp if(!this._public && new movim.User().getConfig('nightmode')) { ?>nightmode<?hhp } ?>">
        <noscript>
            <style type="text/css">
                nav {display:none;} #content {display: none;}
            </style>
            <div class="warning" style="width: 500px; margin: 0 auto;">
            <?hhp this.echo(movim.i18n.Locale.start().translate('global.no_js')); ?>
            </div>
        </noscript>
        <div id="hiddendiv"></div>
        <div id="snackbar" class="snackbar"></div>
        <div id="error_websocket" class="snackbar hide">
            <ul class="list">
                <li>
                    <span class="control icon gray">
                        <i class="zmdi zmdi-code-setting"></i>
                    </span>
                    <p class="normal">
                        <?hhp this.echo(movim.i18n.Locale.start().translate('error.websocket')); ?>
                    </p>
                </li>
            </ul>
        </div>
        <?hhp this.widget('Dialog');?>
        <?hhp this.widget('Drawer');?>
        <?hhp this.widget('Preview');?>
        <?hhp this.content();?>
    </body>
</html>
