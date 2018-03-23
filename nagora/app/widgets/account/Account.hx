package app.widgets.account;

import app.helpers.StringHelper;

class Account extends movim.widget.Base {
    override public function load() : Void {
        //TODO: js to haxe
        this.addjs('account.js');
        //this.registerEvent('register_changepassword_handle', 'onPasswordChanged');
        //this.registerEvent('register_remove_handle', 'onRemoved');
        //this.registerEvent('register_get_handle', 'onRegister', 'account');
    }

    public function onPasswordChanged() : Void {
        //TODO: Notification and RPC(from JS)
        /*this.rpc('Account.resetPassword');
        Notification.append(null, Locale.start().translate('account.password_changed'));*/
    }

    public function onRemoved() : Void {
        //TODO messages(db)
        /*md = new Modl\MessageDAO;
        md.clearMessage();*/
        //TODO posts(db)
        /*pd = new Modl\PostnDAO;
        pd.deleteNode(this.user.getLogin(), 'urn:xmpp:microblog:0');*/
        //TODO: RPC
        //this.rpc('Presence_ajaxLogout');
    }

    public function onRegister(pkg : {from : String, content: {x: Dynamic, actions: String, attributes: Array<String>}}) : Void {
        var content = pkg.content;

        if(content.x != null) {
            //TODO: xml to html
            /*xml = new \XMPPtoForm();
            form = xml.getHTML(content.x.asXML());*/

            //TODO: Dialog
            /*Dialog.fill(hhp.Hhp.render('nagora/app/widgets/Account/_account_form.tpl', {
                        form : form,
                        from : pkg.from,
                        attributes : content.attributes,
                        actions : content.actions
                      }), true);*/
        }

    }

    public function ajaxChangePassword(form : js.html.FormData) : Void {
        var p1 : String = form.get('password');
        var p2 : String = form.get('password_confirmation');

        if(p1.length > 5 && p1.length < 41
        && p2.length > 5 && p2.length < 41) {
            if(p1 == p2) {
                var arr = StringHelper.explodeJid(this.user.getLogin());

                //TODO: xmpp
                /*var cp = new ChangePassword();
                cp.setTo(arr.get('server'))
                   .setUsername(arr.get('username'))
                   .setPassword(p1)
                   .request();*/
            } else {
                //TODO: Notification and RPC(from JS)
                /*this.rpc('Account.resetPassword');
                Notification.append(null, this.__('account.password_not_same'));*/
            }
        } else {
            //TODO: Notification and RPC(from JS)
            /*this.rpc('Account.resetPassword');
            Notification.append(null, this.__('account.password_not_valid'));*/
        }
    }

    public function ajaxRemoveAccount() : Void {
        //TODO: RPC
        //this.rpc('Presence.clearQuick');
        //TODO: Dialog
        /*Dialog.fill(hhp.Hhp.render('nagora/app/widgets/Account/_account_remove.tpl', {
                    jid : this.user.getLogin(),
                  }), true);*/
    }

    public function ajaxClearAccount() : Void {
        //TODO: Dialog
        /*Dialog.fill(hhp.Hhp.render('nagora/app/widgets/Account/_account_clear.tpl', {
                    jid : this.user.getLogin(),
                  }), true);*/
    }

    public function ajaxClearAccountConfirm() : Void {
        this.onRemoved();
    }

    public function ajaxRemoveAccountConfirm() : Void {
        //TODO: xmpp
        /*da = new Remove;
        da.request();*/
    }

    public function ajaxGetRegistration(server : String) : Void {
        if(!this.validateServer(server)) return;

        //TODO: xmpp
        /*da = new Get;
        da.setTo(server)
           .request();*/
    }

    public function ajaxRegister(server : String, form : js.html.FormData) : Void {
        if(!this.validateServer(server)) return;
        //TODO: xmpp
        /*s = new Set;
        s.setTo(server)
          .setData(form)
          .request();*/
    }

    private function validateServer(server : String) : Bool {
        if(server.length < 6 || server.length > 80 || server.indexOf(' ') == -1) return false else return true;
    }

    override public function display() : Void {
        //TODO: db
        /*id = new \Modl\InfoDAO;
        this.view.assign('gateway', id.getGateways(this.user.getServer()));*/
    }
}
