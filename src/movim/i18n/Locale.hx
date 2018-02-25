package movim.i18n;

import hxIni.IniManager;
import hxIni.IniManager.Ini;

class Locale {
    private static var _instance : Locale;
    public var translations : Map<String,String>;
    public var language : String;
    public var hash : Map<String,Map<String,String>> = new Map();

    private function new() : Void {
        this.loadIni(IniManager.loadFromString(Main.ini_file('locales/locales.ini')), 'locales/locales.ini');

        var w : Array<String> = Locale.load_widgets_ini();
        for(file in w) {
            this.loadIni(IniManager.loadFromString(file), 'app/unknow/locales.ini'); //TODO: correct widget name
        }
    }

    macro public static function load_widgets_ini() {
      var files : Array<haxe.macro.Expr.ExprOf<String>> = [];
      for(widget in sys.FileSystem.readDirectory('nagora/app/widgets')) {
        if( sys.FileSystem.exists('nagora/app/widgets/' + widget + '/locales.ini') ) {
          files.push(macro $v{sys.io.File.getContent('nagora/app/widgets/' + widget + '/locales.ini')});
        }
      }

      return macro $a{files};
    }

    /**
     * @desc Load a locales ini file and merge it with hash attribute
     * @param $file The path of the fie
     */
    private function loadIni(ini : Map<String,Map<String,String>>, file : String) {
      //var ini : Map<String,Map<String,String>> = IniManager.loadFromString(Main.ini_file(file));
      for( key in ini.keys() ) {
        if( hash[key] == null ) {
          hash[key] = ini[key];
        } else {
          for( key2 in ini[key].keys() ) {
            if( hash[key][key2] == null ) {
              hash[key][key2] = ini[key][key2];
            } else {
              Main.log.log('Warning', 'Locale file ' + file + ' is triying to assing a value thats is assigned: ' + key + key2);
            }
          }
        }
      }
    }

    public static function start() : Locale {
        if(Locale._instance == null) {
            Locale._instance = new Locale();
        }

        return Locale._instance;
    }

    /**
     * @desc Return an array containing all the presents languages in i18n
     */

    public function getList() {
        var lang_list = Languages.get_lang_list();
        var dir = sys.FileSystem.readDirectory(Main.dirs.locales);
        var po : Map<String,String> = new Map();
        for(files in dir) {
            var explode = files.split('.');
            if(explode.pop() == 'po' && lang_list[explode[0]] != null) {
                po[explode[0]] = lang_list[explode[0]];
            }
        }

        po.set('en', 'English');

        return po;
    }

    /**
     * @desc Translate a key
     * @param $key The key to translate
     * @param $args Arguments to pass to sprintf
     */
    public function translate(key : String, ?args:Array<String>) : String {
        if(key == null || key == '') return key;

        var arr = key.split('.');
        if(this.hash[arr[0]] != null && this.hash[arr[0]][arr[1]] != null) {
            var string = '';
            var skey = this.hash[arr[0]][arr[1]];

            if(this.language == 'en') {
                var string = skey;
            } else if(this.translations[skey] != null) {
                string = this.translations[skey];
            } else {
                if(this.language != 'en') {
                    Main.log.log('Info', 'Locale: Translation not found in ['+this.language+'] for "'+key+'" : "'+skey+'"');
                }
                if(Std.is(skey, String)) {
                    string = skey;
                } else {
                    Main.log.log('Warning', 'Locale: Double definition for "'+key+'" got '+skey);
                    //string = skey[0];
                }
            }

            if(args != null) { //TODO
                args.unshift(string);
                string = 'Not implemented'; //call_user_func_array("sprintf", args);
                Main.log.log('Error', 'Not implemented');
            }

            return string;
        } else {
          Main.log.log('Error', 'Locale: Translation key "'+key+'" not found');
          return '';
        }
    }

    /**
     * @desc Auto-detects the language from the user browser
     */
    public function detect(?accepted:String) : Null<String> {
        var langs : Map<String,String> = new Map();

        var languages = if(accepted != null) accepted else ''; //TODO _SERVER.getset('HTTP_ACCEPT_LANGUAGE');

        var matcher = ~/([a-z]{1,8}(-[a-z]{1,8})?)\s*(;\s*q\s*=\s*(1|0\.[0-9]+))?/i;


        while (matcher.match(languages)) {
          if(matcher.matched(4) != '') langs.set(matcher.matched(1), matcher.matched(4));
          languages = matcher.matchedRight();
        }

        for( key in langs.keys() ) {
            if(sys.FileSystem.exists(Main.dirs.locales + key + '.po')) {
                this.language = key;
                return null;
            }

            var exploded = key.split('-');
            key = exploded[0];

            if(sys.FileSystem.exists(Main.dirs.locales + key + '.po')) {
                this.language = key;
                return null;
            }

            this.language = 'en';
        }

        return this.language;
    }

    /**
     * @desc Load a specific language
     * @param $language The language key to load
     */
    public function load(language : String) : Void {
        this.language = language;
        this.loadPo();
    }

    /**
     * @desc Parses a .po file based on the current language
     */
    public function loadPo() : Void {
        var pofile = Main.dirs.locales + this.language + '.po';
        if(!sys.FileSystem.exists(pofile)) {
            return;
        }

        // Parsing the file.
        var handle = sys.io.File.read(pofile, false);

        this.translations = new Map();

        var msgid = "";
        var msgstr = "";

        var last_token = "";
        var comment_m = ~/#^msgctxt#/;
        var id_m = ~/#^msgid#/;
        var str_m = ~/#^msgstr#/;

        while(handle.eof() == false) {
            var line = handle.readLine();
            if(line.substr(0, 1) == "#" || StringTools.trim(StringTools.rtrim(line)) == "" || comment_m.match(line)) {
                continue;
            }

            if(id_m.match(line)) {
                if(last_token == "msgstr") {
                    this.translations[msgid] = msgstr;
                }
                last_token = "msgid";
                msgid = this.getQuotedString(line);
            }
            else if(str_m.match(line)) {
                last_token = "msgstr";
                msgstr = this.getQuotedString(line);
            } else {
                last_token += this.getQuotedString(line);
            }
        }
        if(last_token == "msgstr") {
            this.translations[msgid] = msgstr;
        }

        handle.close();
    }

    private function getQuotedString(string) : String {
        var string_m = ~/'#"(.+)"#'/;
        string_m.match(string);

        if(string_m.matched(1) != null) {
          return string_m.matched(1);
        } else {
          Main.log.log('Warning', 'error getting quoted string "' + string + '", when loading a locale');
          return ' ';
        }
    }
}
