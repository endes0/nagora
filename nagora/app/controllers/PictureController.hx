package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;

class PictureController extends Base {
    override public function load() : Void {
        this.session_only = true;
        this.raw = true;
    }

    override public function dispatch() : Void {
    }
