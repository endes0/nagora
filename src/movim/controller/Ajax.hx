package movim.controller;

class Ajax extends Base {
    private var funclist : Map<String,{params: Array<String>, object: String, funcname: String, http: Bool}> = new Map();
    private static var instance : Ajax;
    private var widgetlist : Array<String> = [];

    public function new() : Void {
        super();
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

        var buffer = '<script type="text/javascript">';
        for (key in this.funclist.keys()) {
            var parlist = this.funclist[key].params.join(', ');

            buffer += 'function ' + this.funclist[key].object + '_'
                + this.funclist[key].funcname + "(${parlist}) {";
            buffer += (if(this.funclist[key].http) " return MovimWebsocket.sendAjax('" else "MovimWebsocket.send('") +
                this.funclist[key].object + "', '" +
                this.funclist[key].funcname + "', [${parlist}]);}\n";
        }

        return buffer + "</script>\n";
    }

    /**
     * Check if the widget is registered
     */
    public function isRegistered(widget : String) : Bool{
        return this.widgetlist.indexOf(widget) != -1;
    }

    /**
     * Defines a new function.
     */
    public function defun(widget : String, funcname : String, params : Array<String> , http:Bool=false) {
        this.widgetlist.push(widget);
        this.funclist[widget+funcname] = {
            object: widget,
            funcname: funcname,
            params: params,
            http: http
        };
    }
}
