package movim.controller;

import movim.template.Builder;
import movim.Route;
import movim.User;

class Base {
    public var name : String = 'main';          // The name of the current page
    public var unique : Bool = false;         // Only one WS for this page
    var session_only(default,null) : Bool = false;// The page is protected by a session ?
    var raw(default,null) : Bool = false;         // Display only the content ?
    var _public(default,null) : Bool = false;      // It's a public page
    var page(default,null) : Builder;

    public function new() : Void {
        this.page = new Builder(new User());
    }

    /**
     * Returns the value of a $_GET variable. Mainly used to avoid getting
     * notices from PHP when attempting to fetch an empty variable.
     * @param  name is the desired variable's name.
     * @return the value of the requested variable, or FALSE.
     */
    private function fetchGet(name) : String { //TODO
        if (/*$_GET*/php.Web.getParams()[name] != null) {
            return /*$_GET*/php.Web.getParams()[name];
        } else {
            return null;
        }
    }

    /**
     * Returns the value of a $_POST variable. Mainly used to avoid getting
     * notices from PHP when attempting to fetch an empty variable.
     * @param  name is the desired variable's name.
     * @return the value of the requested variable, or FALSE.
     */
    private function fetchPost(name) : String {
      if (/*$_GET*/php.Web.getParams()[name] != null) {
          return /*$_GET*/php.Web.getParams()[name];
      } else {
          return null;
      }
    }

    public function checkSession() : Void {
        if (this.session_only) {
            var user = new User();

            if (!user.isLogged()) {
                this.name = 'login';
            }
        }
    }

    public function redirect(page : String, params:Bool=false) : Void { //TODO
        var url = Route.urlize(page, params);
        php.Web.setHeader('Location: '+ url);
    }

    public function display() : Void {
        this.page.addScript('movim_utils.js');
        this.page.addScript('movim_base.js');
        this.page.addScript('movim_electron.js');

        if (!this._public) {
            this.page.addScript('movim_tpl.js');
            this.page.addScript('movim_websocket.js');
        }

        var user = new User();
        var content = new Builder(user);

        if (this.raw) { //TODO: display
            //echo content.build(this.name);
        } else {
            var built = content.build(this.name);
            this.page.setContent(built);

            //TODO: display
            //echo this.page.build('page', this._public);
        }
    }
}
