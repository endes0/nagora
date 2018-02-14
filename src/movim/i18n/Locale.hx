namespace Movim\i18n;

class Locale {
    private static var _instance;
    public var translations;
    public var language;
    public var hash = [];

    private function __construct() : Void
    {
        this.loadIni(
            LOCALES_PATH + 'locales.ini',
            true,
            INI_SCANNER_RAW);

        dir = scandir(WIDGETS_PATH);
        for(widget in dir) {
            path = WIDGETS_PATH + widget + '/locales.ini';
            if(sys.FileSystem.exists(path)) {
                this.loadIni(path);
            }
        }
    }

    /**
     * @desc Load a locales ini file and merge it with hash attribute
     * @param $file The path of the fie
     */
    private function loadIni(file)
    {
        this.hash = array_merge_recursive(
            this.hash,
            parse_ini_file(
                file,
                true,
                INI_SCANNER_RAW
            )
        );
    }

    public static function start() : Void
    {
        if(!isset(/*self.*/_instance)) {
            /*self.*/_instance = new self();
        }

        return /*self.*/_instance;
    }

    /**
     * @desc Return an array containing all the presents languages in i18n
     */

    public function getList()
    {
        import/*('languages.php')*/;

        lang_list = get_lang_list();
        dir = scandir(LOCALES_PATH);
        po = [];
        for(files in dir) {
            explode = files.split('.');
            if(end(explode) == 'po'
            && lang_list.exists(explode[0])) {
                po[explode[0]] = lang_list[explode[0]];
            }
        }

        po.set('en') = 'English';

        return po;
    }

    /**
     * @desc Translate a key
     * @param $key The key to translate
     * @param $args Arguments to pass to sprintf
     */
    public function translate(key, args:Bool=false)
    {
        if(empty(key)) return key;

        arr = key.split('.');
        if(is_array(this.hash)
        && this.hash.exists(arr[0])
        && (this.hash[arr[0]]).exists(arr[1])) {
            skey = this.hash[arr[0]][arr[1]];

            if(this.language == 'en') {
                if(is_string(skey)) {
                    string = skey;
                } else {
                    string = skey[0];
                }
            } elseif(is_array(this.translations)
            && this.translations.exists(skey)
            && isset(this.translations[skey])) {
                string = this.translations[skey];
            } else {
                if(this.language != 'en') {
                    \Utils.log('Locale: Translation not found in ['+this.language+'] for "'+key+'" : "'+skey+'"');
                }
                if(is_string(skey)) {
                    string = skey;
                } else {
                    \Utils.log('Locale: Double definition for "'+key+'" got '+php.Lib.serialize(skey));
                    string = skey[0];
                }
            }

            if(args != false) {
                args.unshift(string);
                string = call_user_func_array("sprintf", args);
            }

            return string;
        } else {
            \Utils.log('Locale: Translation key "'+key+'" not found');
        }
    }

    /**
     * @desc Auto-detects the language from the user browser
     */
    public function detect(accepted:Bool=false)
    {
        langs = [];

        languages = (accepted != false) ? accepted : _SERVER.getset('HTTP_ACCEPT_LANGUAGE');

        preg_match_all(
            '/([a-z]{1,8}(-[a-z]{1,8})?)\s*(;\s*q\s*=\s*(1|0\.[0-9]+))?/i',
            languages,
            lang_parse);

        if ((lang_parse[1]).length) {
            langs = array_combine(lang_parse[1], lang_parse[4]);

            for (lang => val in langs) {
                if (val === '') langs[lang] = 1;
            }
            arsort(langs, SORT_NUMERIC);
        }

        while((list(key, value) = each(langs))) {
            if(sys.FileSystem.exists(LOCALES_PATH + key + '.po')) {
                this.language = key;
                return;
            }

            exploded = key.split('-');
            key = reset(exploded);

            if(sys.FileSystem.exists(LOCALES_PATH + key + '.po')) {
                this.language = key;
                return;
            }

            this.language = 'en';
        }

        return this.language;
    }

    /**
     * @desc Load a specific language
     * @param $language The language key to load
     */
    public function load(language)
    {
        this.language = language;
        this.loadPo();
    }

    /**
     * @desc Parses a .po file based on the current language
     */
    public function loadPo()
    {
        pofile = LOCALES_PATH+this.language+'.po';
        if(!sys.FileSystem.exists(pofile)) {
            return false;
        }

        // Parsing the file.
        handle = fopen(pofile, 'r');

        this.translations = [];

        msgid = "";
        msgstr = "";

        last_token = "";

        while(line = fgets(handle)) {
            if(line[0] == "#"
            || (line.rtrim()).trim() == ""
            || preg_match('#^msgctxt#', line)) {
                continue;
            }

            if(preg_match('#^msgid#', line)) {
                if(last_token == "msgstr") {
                    this.translations[msgid] = msgstr;
                }
                last_token = "msgid";
                msgid = this.getQuotedString(line);
            }
            else if(preg_match('#^msgstr#', line)) {
                last_token = "msgstr";
                msgstr = this.getQuotedString(line);
            }
            else {
                last_token += this.getQuotedString(line);
            }
        }
        if(last_token == "msgstr") {
            this.translations[msgid] = msgstr;
        }

        fclose(handle);
    }

    private function getQuotedString(string) : Void
    {
        matches = [];
        preg_match('#"(.+)"#', string, matches);

        if(isset(matches[1]))
            return matches[1];
    }
}
