package movim.widget;

//use Rain\Tpl;
import movim.controller.Ajax;
import movim.User;

@:autoBuild(hhp.TemplateBuilder.build())
class Base {
    private var js : Array<String> = [];     // Contains javascripts
    private var css : Array<String> = [];    // Contains CSS files
    private var rawcss : Array<String> = []; // Contains raw CSS files links
    private var ajax : Ajax;        // Contains ajax client code
    private var user : User;
    private var name : String;
    private var pure : Bool;        // To render the widget without the container

    private var _view : String;
    private var view : Map<String, Dynamic>;

    public var events : Map<String,Array<String>> = new Map();
    public var filters : Map<String, String> = new Map();

    // Meta tags
    public var title : String;
    public var image : String;
    public var description : String;
    public var url : String = null;
    public var links : Array<String> = [];

    private var _buffer : String = '';
    private var _isLayoutDisabled : Bool = false;
    private var data : Dynamic;

    /**
     * Initialises Widget stuff.
     */
    public function new(light:Bool=false, ?view : String) {
        if(view != null) this._view = view;

        this.user = new User();
        this.load();

        this.name = Type.getClassName(Type.getClass(this));

        // If light loading enabled, we stop here
        if(light) return;

        // Put default widget init here.
        this.ajax = Ajax.getInstance();

        if(!this.ajax.isRegistered(this.name)) {
            // Generating Ajax calls.
            var meths = Reflect.fields(this);

            var ajax = ~/#^ajax#/;
            var ajax_http = ~/#^ajaxHttp#/;
            for(method in meths) {
                if(ajax.match(method)) {
                    /*var pars = method.getParameters();
                    params = [];
                    for(param in pars) {
                        params[] = param.name;
                    }*/

                    this.ajax.defun(
                        this.name,
                        method,
                        [],//params,
                        ajax_http.match(method)
                    );
                }
            }
        }

        this.view = Macro.prebuild_all_widgets(movim.widget.Base);
    }

    public function supported(key) : Bool {
        return this.user.isSupported(key);
    }

    public function route(page : String, ?params:Array<String>, ?tab:String) : String {
        return movim.Route.urlize(page, params, tab);
    }

    public function rpc() : Void { //TODO
        //return movim.RPC.call(+++args);
    }

    public function load() : Void {}

    /**
     * Generates the widget's HTML code.
     */
    public function build() : String {
        return this.draw();
    }

    /**
     * Get the current view name
     */
    public function getView() : String {
        return this._view;
    }

    /**
     * Get the current view name
     */
    public function getUser() : User{
        return this.user;
    }

    /*
     * @desc Preload some sourcecode for the draw method
     */
    public function display() : Void {}

    /**
     *  @desc Return the template's HTML code
     */
    public function draw() : String {
        this.display();
        var view : Base = this.view[this.name];
        var out : String = view.execute();
        return StringTools.trim(out);
    }

    /*private function tpl() : Void {
        config = [
            'tpl_dir'       => APP_PATH+'widgets/'+this.name+'/',
            'cache_dir'     => CACHE_PATH,
            'tpl_ext'       => 'tpl',
            'auto_escape'   => false
        ];

        view = new Tpl;
        view.objectConfigure(config);
        view.assign('c', this);

        return view;
    } */

    /**
     * @brief Returns the path to the specified widget file.
     * @param file is the file's name to make up the path for.
     * @param fspath is optional, returns the OS path if true, the URL by default.
     */
     private function respath(file : String, fspath:Bool=true, parent:Bool=false) : String {
       var folder : String = '';
        if(parent == false) {
            folder = Type.getClassName(Type.getClass(this));
        } else {
            folder =  Type.getClassName(Type.getSuperClass(Type.getClass(this)));
        }

        var path = 'nagora/app/widgets/' + folder + '/' + file;

        if(fspath) {
            //path = path;
        } else {
            path = StringTools.urlEncode(path);
        }

        return path;
    }

    public function getName() : String {
        return this.name;
    }

    /**
     * @brief Returns the javascript ajax call.
     */
    private function call(funcname : String) : Dynamic {
        return this.makeCall([funcname]);
    }

    private function makeCall(params : Array<String>, ?widget:String) : Dynamic {
        if(widget != null) {
            widget = this.name;
        }

        var funcname = params.shift();

        var cl = Type.createInstance(Type.resolveClass(this.name), []);
        return Reflect.callMethod(cl, Reflect.field(cl, funcname), params);
    }

    /**
     * @brief Adds a javascript file to this widget.
     */
    private function addjs(filename : String) : Void {
        this.js.push(this.respath(filename));
    }

    /**
     * @brief returns the list of javascript files to be loaded for the widget.
     */
    public function loadjs() : Array<String> {
        return this.js;
    }

    /**
     * @brief Adds a CSS file to this widget.
     */
    private function addcss(filename : String) : Void {
        this.css.push(this.respath(filename));
    }

    /**
     * @brief Adds a CSS to the page.
     */
    private function addrawcss(url : String) : Void {
        this.rawcss.push(url);
    }

    /**
     * @brief returns the list of javascript files to be loaded for the widget.
     */
    public function loadcss() : Array<String> {
        return this.css.concat(this.rawcss);
    }

    /*
     * @brief Fetch and return get variables
     */
    /*private function get(name) : Void
    {
        if(isset(php.Web.getParams()[name])) {
            return htmlentities(php.Web.getParams()[name]);
        } else {
            return false;
        }
    }*/

    /**
     * @brief Registers an event handler.
     * @param $type The event key
     * @param $function The function to call
     * @param $filter Only call this function if the session notif_key is good
     */
    private function registerEvent(type : String, func : String, ?filter : String) {
        if(this.events[type] == null) {
            this.events[type] = [func];
        } else {
            this.events[type].push(func);
        }

        if(filter != null) {
            this.filters[func] = filter;
        }
    }

    public function echo (v:Dynamic) : Void {
       this._buffer += (v == null ? '' : Std.string(v));
   }

    public inline function getBuffer () : String {
       return this._buffer;
    }

    public function execute () : String {
       return this._buffer;
    }

    public function clearBuffer () : Void {
       this._buffer = '';
    }

    public function disableLayout () : Void {
       this._isLayoutDisabled = true;
    }
}
