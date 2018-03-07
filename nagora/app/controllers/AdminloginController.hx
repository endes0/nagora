package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;

class AdminloginController extends Base {
    override public function load() : Void {
        this.session_only = false;
    }

    override public function dispatch() : Void {
        this.page.setTitle(Locale.start().translate('page.administration'));

        var config = Main.config['Config'];

        #if nodejs
          var user = ~/(?:\?|&)username=([^\?&])/;
          var pass = ~/(?:\?|&)password=([^\?&])/;
          if( user.match(js.Browser.location.search) && pass.match(js.Browser.location.search) &&
              config['username'] == user.matched(1) && config['password'] == haxe.crypto.Sha1.encode(pass.matched(1))) {
            Main.config['Sessionx']['admin'] = 'true';
            this.name = 'admin';
          }
        #end
    }
}
