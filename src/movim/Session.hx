
package movim;

class Session {
    static var instance(default,null) : Session;
    static var sid(default,null) : String = null;
    var values(default,null) : Map<String, String> = [];

    /**
     * Gets a session handle.
     */
    public static function start() {
        if (Session.instance == null) {
            Session.instance = new Session();
        }

        return Session.instance;
    }

    /**
     * Gets a session variable. Returns false if doesn't exist.
     */
    public function get(varname: String) : String {
        if (this.values.exists(varname)) {
            return haxe.Unserializer.run(haxe.crypto.Base64.decode(this.values[varname])).toString();
        }
        return null;
    }

    /**
     * Sets a session variable. Returns $value.
     */
    public function set(varname: String, value: String) : String {
        var value = haxe.crypto.Base64.encode(haxe.io.Bytes.fromString(haxe.Serializer.run(value)));
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
