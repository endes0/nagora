package app.controllers;

import movim.controller.Base;

class FeedController extends Base {
    override public function load() : Void {
        this.session_only = false;
        this.raw = true;
    }

    override public function dispatch() : Void {}
}
