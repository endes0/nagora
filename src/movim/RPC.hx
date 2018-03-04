package Movim;

import movim.widget.Wrapper;

class RPC {
    /*public static function call(funcname : String, args : Array<Dynamic>) : Void {
        writeOut([
            'func' => funcname,
            'params' => args,
        ]);
    }*/

    /**
     * Handles incoming requests.
     */
    public function handleJSON(request : {widget : String, func : String, params : Array<Dynamic>}) : Void {
        if(request.widget == null) return;

        var w =new Wrapper();
        w.runWidget(request.widget, request.func, request.params);
    }
}
