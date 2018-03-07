package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;

class ConfController extends Base {
    override public function load() : Void {
        this.session_only = true;
    }

    override public function dispatch() : Void {
        this.page.setTitle(Locale.start().translate('page.configuration'));
    }
}
