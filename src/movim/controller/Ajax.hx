package movim.controller;

class Ajax extends Base {
    private var funclist : Map<String,Map<String,String>> = new Map();
    private static var instance : Ajax;
    private var widgetlist = [];

    public function __construct() : Void
    {
        super.new();
    }

    public static function getInstance() : Ajax {
        if (Ajax.instance == null) {
            Ajax.instance = new Ajax();
        }

        return Ajax.instance;
    }

    /**
     * Generates the javascript part of the ajax.
     */
    public function genJs() : String{
        if (this.funclist.length < 1) {
            return '';
        }

        buffer = '<script type="text/javascript">';
        for (key in this.funclist.key()) {
            var parlist = this.funclist[key].get('params').join(', ');

            buffer += 'function ' + this.funclist[key].get('object') + '_'
                + this.funclist[key].get('funcname') + "(${parlist}) {";
            buffer += (if(this.funclist[key].getset('http')) " return MovimWebsocket.sendAjax('" else "MovimWebsocket.send('") +
                this.funclist[key].get('object') + "', '" +
                this.funclist[key].get('funcname') + "', [${parlist}]);}\n";
        }

        return buffer + "</script>\n";
    }

    /**
     * Check if the widget is registered
     */
    public function isRegistered(widget : String) : Bool{
        return this.widgetlist.exists(widget);
    }

    /**
     * Defines a new function.
     */
    public function defun(widget : String, funcname : String, params : Array<String> , http:Bool=false) {
        this.widgetlist.push(widget);
        this.funclist[widget+funcname] = [
            'object' => widget,
            'funcname' => funcname,
            'params' => params,
            'http' => http
        ];
    }
}
