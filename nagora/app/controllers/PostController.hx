package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;

class PostController extends Base {
    public function load() : Void {
        this.session_only = true;
    }

    public function dispatch() : Void {
        this.page.setTitle(Locale.start().translate('page.post'));
    }
}
