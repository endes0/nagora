package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;
import movim.User;

class LoginController extends Base {
    override public function load() : Void {
        this.session_only = false;
    }

    override public function dispatch() : Void {
        this.page.setTitle(Locale.start().translate('page.login'));

        var user = new User();
        if(user.isLogged()) {
            if(this.fetchGet('i') != null && this.fetchGet('i').length > 7) {
              //TODO
                /*var invitation = \Modl\Invite.get(this.fetchGet('i'));
                this.redirect('chat', [invitation.resource, 'room']);*/
                throw 'invitation not implemeted';
            } else {
                this.redirect('root');
            }
        }
    }
}
