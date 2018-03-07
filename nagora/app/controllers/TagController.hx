package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;

class TagController extends Base {
    public function load() : Void {
        this.session_only = false;
    }

    public function dispatch() : Void {
        this.page.setTitle(Locale.start().translate('page.tag'));
    }
}
