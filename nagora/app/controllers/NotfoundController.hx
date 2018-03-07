package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;

class NotfoundController extends Base {
    override public function load() : Void {
        this.session_only = false;
    }

    override public function dispatch() : Void {
        this.page.setTitle(Locale.start().translate('title.not_found', [Main.app.title]));
    }
}
