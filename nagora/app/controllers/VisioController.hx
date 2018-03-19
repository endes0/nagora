package app.controllers;

import movim.controller.Base;


class VisioController extends Base {
    override public function load() : Void {
        this.unique = true;
        this.session_only = true;
    }

    override public function dispatch() : Void {
    }
}
