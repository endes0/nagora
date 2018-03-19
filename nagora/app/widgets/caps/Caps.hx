package app.widgets.caps;

import app.helpers.Utils;

class Caps extends movim.widget.Base {
    private var _table : Map<String,Array<String>> = new Map();
    private var _nslist : Map<String,Map<String,String>> = new Map();

    override public function load() : Void {
        this.addcss('caps.css');
    }

    public function isImplemented(client : Array<String>, key: String) : String {
        if(client.indexOf(this._nslist[key]['ns']) != -1) {
            return '
                <td
                    class="yes '+this._nslist[key]['category']+'"
                    title="XEP-'+key+': '+this._nslist[key]['name']+'">'+
                    key+'
                </td>';
        } else {
            return '
                <td
                    class="no  '+this._nslist[key]['category']+'"
                    title="XEP-'+key+': '+this._nslist[key]['name']+'">'+
                    key+'
                </td>';
        }
    }

    override public function display() : Void {
        //TODO: db
        /*cd = new \modl\CapsDAO;
        clients = cd.getClients();*/
        var clients : Array<{name:String, features: Array<String>}> = [];

        var oldname = '';

        for(c in clients) {
            var clientname = c.name.split(' ').shift().split('#').shift();

            if(oldname == clientname) continue;

            if(this._table[c.name] == null) {
                this._table[c.name] = [];
            }

            for(f in c.features) {
                if(this._table[c.name].indexOf(f) == -1) {
                    this._table[c.name].push(f);
                }
            }

            oldname = clientname;
        }

        this._nslist = Utils.getXepNamespace();

        this.view[this.name].data = {
          table: this._table,
          nslist: this._nslist
        };
    }
}
