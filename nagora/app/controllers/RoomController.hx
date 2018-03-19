package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;

class RoomController extends Base {
    override public function load() : Void {
    }

    override public function dispatch() : Void {
        this.page.setTitle(Locale.start().translate('page.room'));
    }
}
