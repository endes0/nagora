package app.controllers;

import movim.controller.Base;
import movim.i18n.Locale;
import movim.User;

class NewsController extends Base {
    override public function load() : Void {
        this.session_only = true;
    }

    override public function dispatch() : Void {
        this.page.setTitle(Locale.start().translate('page.news'));

        var user = new User();

        if(!user.isSupported('pubsub')) {
            this.redirect('contact');
        }

        if(!user.isLogged()) {
          //TODO
            /*pd = new \Modl\PostnDAO;
            p  = pd.get(
                this.fetchGet('s'),
                this.fetchGet('n'),
                this.fetchGet('i')
            );*/
            var p = null;

            if(p != null) {
                if(p.isMicroblog()) {
                    this.redirect('blog', [p.origin, p.nodeid]);
                } else {
                    this.redirect('node', [p.origin, p.node, p.nodeid]);
                }
            } else {
                this.redirect('login');
            }
        }
    }
}
