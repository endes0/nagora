package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;

class AdminController extends Base {
    override public function load() : Void {
        this.session_only = false;
    }

    override public function dispatch() : Void {
        if(Main.config['Sessionx']['admin'] != null && Main.config['Sessionx']['session'] == 'true') {
            this.page.setTitle(Locale.start().translate('page.administration'));
        } else {
            this.name = 'adminlogin';
        }
    }
}
