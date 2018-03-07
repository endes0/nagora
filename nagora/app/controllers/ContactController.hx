package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;
import movim.User;

class ContactController extends Base {
    override public function load() : Void {
        this.session_only = true;
    }

    override public function dispatch() : Void {
        this.page.setTitle(Locale.start().translate('page.contacts'));

        var user = new User();
        if(!user.isLogged() && this.fetchGet('s') != '') {
            this.redirect('blog', [this.fetchGet('s')]);
        }
    }
}
