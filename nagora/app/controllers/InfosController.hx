package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;

class InfosController extends Base {
    override public function load() : Void {
        //php.Web.setHeader('Content-type: application/json');
        this.session_only = false;
        this.raw = true;
    }

    override public function dispatch() : Void {}
}
