package movim;

import movim.controller.Base;

class Route extends Base {
    public var _routes : Map<String,Array<String>>;
    private var _page : String;

    public function new() : Void {
        this._routes = [
                'about'         => ['x'],
                'account'       => [],
                'accountnext'   => ['s', 'err'],
                'ajax'          => [],
                'admin'         => [],
                'blog'          => ['f', 'i'],
                'chat'          => ['f', 'r'],
                'community'     => ['s', 'n', 'i'],
                'conf'          => [],
                'contact'       => ['s'],
                'disconnect'    => ['err'],
                'feed'          => ['s', 'n'],
                'help'          => [],
                'infos'         => [],
                'login'         => ['i'],
                'main'          => [],
                'node'          => ['s', 'n', 'i'],
                'news'          => ['s', 'n', 'i'],
                'post'          => ['s', 'n', 'i'],
                'picture'       => ['url'],
                'popuptest'     => [],
                'publish'       => ['s', 'n', 'i', 'sh'],
                'room'          => ['r'],
                'share'         => ['url'],
                'system'        => [],
                'tag'           => ['t', 'i'],
                'visio'         => ['f', 's'],
            ];

            super();
    }

    public function find() : String { //TODO
        /*this.fix(php.Web.getParams(), _SERVER.get('QUERY_STRING'));

        gets = php.Web.getParams().keys();
        uri = gets[0];
        php.Web.getParams()[uri] = null;
        request = uri.split('/'); */

        this._page = ''; //request.shift();

        if (this._routes[this._page] != null) {
            var route = this._routes[this._page];
        }

        /*if (request.length > 0 && route.length > 0) {
            i = 0;
            for (key in route) {
                if (request[i] != null) {
                    php.Web.getParams()[key] = request[i];
                }
                i++;
            }
        }*/

        if (this._page == null || this._page == 'main') {
            this._page = 'news';
        }

        if (this._routes[this._page] == null) {
            this._page = 'notfound';
        }

        return this._page;
    }

    public static function urlize(page : String, ?params:Array<String>, ?tab:String) : String {
        var r = new Route();
        var routes = r._routes;

        if(page == 'root') return ''; //TODO BASE_URI;

        if (routes[page] != null) {
            var uri = '';

            if (tab != null) {
                tab = '#'+tab;
            } else {
                //We construct a classic URL if the rewriting is disabled
                uri = /*BASE_URI + */'?'+ page; //TODO
            }

            if (params != null && params.length > 0) {
                for (value in params) {
                    uri += '/' + value;
                }
            }

            return uri+tab;
        } else {
            throw 'Route not set for the page ' + page;
        }
    }

    private function fix(source : String, discard:Bool=true) : Map<String,String> {
        var result : Map<String,String> = new Map();

        var p = ~/(^|(?<=&))[^=([&])+/;
        while (p.match(source)) {
          result.set(StringTools.urlDecode(p.matched(1)), StringTools.urlDecode(p.matched(2)));
          source = p.matchedRight();
        }

        return result;
    }
}
