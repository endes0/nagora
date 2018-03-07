package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;


class PopuptestController extends Base {
    override public function load() : Void {
        this.unique = true;
        this.session_only = true;
    }

    override public function dispatch() : Void {
    }
}
