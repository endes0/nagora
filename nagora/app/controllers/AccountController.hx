package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;

class AccountController extends Base {
    override public function load() : Void{
        this.session_only = false;
    }

    override public function dispatch() : Void {
        //requestURL('http://localhost:1560/disconnect/', 2, ['sid' => Main.session_id]); not necesary

        this.page.setTitle(Locale.start().translate('page.account_creation'));
    }
}
