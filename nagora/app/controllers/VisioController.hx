package app.controllers;

import movim.controller.Base;


class VisioController extends Base {
    public function load() : Void {
        this.unique = true;
        this.session_only = true;
    }

    public function dispatch() : Void {
    }
}
