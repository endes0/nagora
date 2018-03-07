package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;

class AccountnextController extends Base {
    override public function load() : Void {
        this.session_only = false;
    }

    override public function dispatch() : Void {
        this.page.setTitle(Locale.start().translate('page.account_creation'));
    }
}
