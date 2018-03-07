package app.controllers;

import movim.controller.Base;
import movim.Session;

class DisconnectController extends Base {
    override public function load() : Void {
        this.session_only = false;
    }

    override public function dispatch() : Void {
        // very important
        var req = new haxe.Http('http://localhost:1560/disconnect/');
        req.addParameter('sid', Main.session_id);
        req.onError = function( e:String ) : Void {
          Main.log.log('Warning', "Error on disconnecting from daemon: " + e);
        }
        req.request(true);
        Session.dispose();

        this.redirect('login');
    }
}
