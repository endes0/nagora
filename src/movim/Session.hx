
package movim;

class Session {
    static var instance : Session;
    static var sid : String = null;
    var values : Map<String, String> = new Map();

    /**
     * Gets a session handle.
     */
    public static function start() {
        if (Session.instance == null) {
            Session.instance = new Session();
        }

        return Session.instance;
    }

    public function new() {
    }

    /**
     * Gets a session variable. Returns false if doesn't exist.
     */
    public function get(varname: String) : String {
        if (this.values.exists(varname)) {
            return haxe.Unserializer.run(haxe.crypto.Base64.decode(this.values[varname]).toString());
        }
        return null;
    }

    /**
     * Sets a session variable. Returns $value.
     */
    public function set(varname: String, value: String) : String {
        var value = haxe.crypto.Base64.encode(haxe.io.Bytes.ofString(haxe.Serializer.run(value)));
        this.values[varname] = value;

        return value;
    }

    /**
     * Deletes a variable from the session.
     */
    public function remove(varname: String) : Void {
        this.values[varname] = null;
    }

    /**
     * Deletes all this session container (not the session!)
     */
    public static function dispose() : Bool{
        if (Session.instance != null) {
            Session.instance = null;
            return true;
        }
        return false;
    }
}
