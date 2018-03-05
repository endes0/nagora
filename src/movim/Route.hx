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

    public function find() : String {
        //this.fix(php.Web.getParams(), _SERVER.get('QUERY_STRING'));

        this._page = #if nodejs
                        js.Browser.location.pathname.split('/').pop();
                     #end

        if (this._routes[this._page] != null) {
            var route = this._routes[this._page];
        }

        if (this._page == null || this._page == 'main' || this._page == 'main.html') {
            this._page = 'about';
        }

        if (this._routes[this._page] == null) {
            this._page = 'notfound';
        }

        return this._page;
    }

    public static function urlize(page : String, ?params:Array<String>, ?tab:String) : String {
        var r = new Route();
        var routes = r._routes;

        if(page == 'root') #if nodejs
                              return js.Browser.location.origin;
                           #end

        if (routes[page] != null) {
            var uri = '';

            if (tab != null) {
                tab = '#'+tab;
            } else {
                //We construct a classic URL if the rewriting is disabled
                uri = #if nodejs
                        js.Browser.location.origin+'/'+ page;
                      #end
            }

            if (params != null && params.length > 0) {
                for (value in params) {
                    uri += '/' + StringTools.urlEncode(value);
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
