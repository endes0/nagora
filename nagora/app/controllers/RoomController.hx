package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;

class RoomController extends Base {
    public function load() : Void {
    }

    public function dispatch() : Void {
        this.page.setTitle(Locale.start().translate('page.room'));
    }
}
