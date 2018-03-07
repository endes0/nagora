package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;

class AboutController extends Base {
    public function new() : Void {
      super();
    }

    override public function load() : Void {
        this.session_only = false;
    }

    override public function dispatch() : Void {
        this.page.setTitle(Locale.start().translate('page.about'));
    }
}
