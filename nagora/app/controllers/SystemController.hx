package app.controllers;

import movim.controller.Base;

class SystemController extends Base {
    public function load() : Void {
        this.session_only = false;
        this.raw = true;
    }

    public function dispatch() : Void {
    }
}
