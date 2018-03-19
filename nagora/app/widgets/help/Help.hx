package app.widgets.help;

import js.Browser;

class Help extends movim.widget.Base {
    override public function load() : Void {
      Main.post_display.push(function() : Void {
        #if hxnodejs
          Browser.document.getElementById('AddChatroom').onclick = this.ajaxAddChatroom;
        #end
      });
    }

    public function ajaxAddChatroom() : Void {
        //TODO: RPC
        /*this.rpc(
            'MovimUtils.redirect',
            this.route('chat', ['movim@conference.movim.eu', 'room'])
        );*/
    }

    override public function display() : Void {
        //TODO: db
        /*id = new \Modl\InfoDAO;
        this.view.assign('info', id.getJid(this.user.getServer()));*/
    }
}
