<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title><?php $this->title(); ?></title>

    <meta name="theme-color" content="#1C1D5B" />
    <meta http-equiv="Content-Security-Policy" content="font-src <?php echo BASE_URI; ?>; frame-src *.youtube.com; script-src <?php echo BASE_URI; ?> 'unsafe-inline' 'unsafe-eval'">

    <?php $this->meta(); ?>

    <meta name="application-name" content="Movim">
    <link rel="shortcut icon" href="<?php $this->linkFile('img/favicon.ico');?>" />
    <link rel="icon" type="image/png" href="<?php $this->linkFile('img/app/48.png');?>" sizes="48x48">
    <link rel="icon" type="image/png" href="<?php $this->linkFile('img/app/96.png');?>" sizes="96x96">
    <link rel="icon" type="image/png" href="<?php $this->linkFile('img/app/128.png');?>" sizes="128x128">
    <script src="<?php echo BASE_URI; ?>app/assets/js/favico.js"></script>
    <script src="<?php echo \Movim\Route::urlize('system'); ?>"></script>

    <meta name="viewport" content="width=device-width, user-scalable=no">

    <?php
        $this->addCss('style.css');
        $this->addCss('notification.css');
        $this->addCss('header.css');
        $this->addCss('listn.css');
        $this->addCss('grid.css');
        $this->addCss('article.css');
        $this->addCss('form.css');
        $this->addCss('icon.css');
        $this->addCss('dialog.css');
        $this->addCss('drawer.css');
        $this->addCss('card.css');
        $this->addCss('table.css');
        $this->addCss('color.css');
        $this->addCss('block.css');
        $this->addCss('menu.css');
        $this->addCss('fonts.css');
        $this->addCss('title.css');
        $this->addCss('typo.css');
        $this->addCss('scrollbar.css');
        $this->addCss('material-design-iconic-font.min.css');

        $this->scripts();
    ?>
    </head>
    <body dir="<?php $this->dir();?>"
          class="<?php if(!$this->public && (new \Movim\User)->getConfig('nightmode')) { ?>nightmode<?php } ?>">
        <noscript>
            <style type="text/css">
                nav {display:none;} #content {display: none;}
            </style>
            <div class="warning" style="width: 500px; margin: 0 auto;">
            <?php echo __('global.no_js'); ?>
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
                        <?php echo __('error.websocket'); ?>
                    </p>
                </li>
            </ul>
        </div>
        <?php $this->widget('Dialog');?>
        <?php $this->widget('Drawer');?>
        <?php $this->widget('Preview');?>
        <?php $this->content();?>
    </body>
</html>
