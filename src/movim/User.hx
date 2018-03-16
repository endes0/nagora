
package movim;

import movim.i18n.Locale;
import movim.types.Server;

class User {
    public var caps : Array<String>;
    public var userdir : String;

    /**
     * Class constructor. Reloads the user's session or attempts to authenticate
     * the user.
     */
    public function new(?username:String) {
        var s = Session.start();
        if (username != null) {
            s.set('username', username);
            this.userdir = Main.dirs.users + username + '/';
        }
    }

    /**
     * @brief Reload the user configuration
     */
    public function reload(language:Bool=false) {
        var session = Main.config['Sessionx'];

        if (session != null) {
            if (language) {
                var lang = this.getConfig('language');
                if (lang != null) {
                    var l = Locale.start();
                    l.load(lang);
                }
            }

            var ser : Server = if(Main.config['Caps'][session['host']] != null) haxe.Unserializer.run(Main.config['Caps'][session['host']]) else null;
          if (ser != null) {
                this.caps = ser.features;
            }
        }
    }

    /**
     * Checks if the user has an open session.
     */
    public function isLogged() : Bool {
        var s = Session.start();
        return s.get('jid') != null;
    }

    public function createDir() : Void {
        var s = Session.start();
        if (s.get('jid') != null) {
            this.userdir = Main.dirs.users + s.get('jid') + '/';

            if (!sys.FileSystem.isDirectory(this.userdir)) {
                sys.FileSystem.createDirectory(this.userdir);
                #if nodejs
                  sys.io.File.saveContent(this.userdir + 'index.html', ' ');
                #else
                  sys.io.File.write(this.userdir + 'index.html').close();
                #end
            }
        }
    }

    public function getLogin() : String {
        var s = Session.start();
        return s.get('jid');
    }

    public function getServer() : String {
        var s = Session.start();
        return s.get('host');
    }

    public function getUser() : String {
        var s = Session.start();
        return s.get('username');
    }

    public function setConfig(config : Map<String,String>) : Void {
        var s = Main.config['Setting'];

        if (config.get('language') != null) {
            s['language'] = config.get('language');
        }

        if (config.get('cssurl') != null) {
            s['cssurl']   = config.get('cssurl');
        }

        if (config.get('nsfw') != null) {
            s['nsfw']     = config.get('nsfw');
        }

        if (config.get('nightmode') != null) {
            s['nightmode']= config.get('nightmode');
        }

        this.createDir();

        //sys.io.File.putContent(this.userdir+'config.dump', php.Lib.serialize(config)); PHP serialization only works on PHP (XD), so I use Haxe serialization
        sys.io.File.saveContent(this.userdir+'config.dump', haxe.Serializer.run(config));

        this.reload(true);
    }

    public function getConfig(?key:String) : Dynamic {
        var s = Main.config['Setting'];

        if (key == null) {
            return s;
        }

        if (s[key] != null) {
            return s[key];
        } else {
          Main.log.log('Warning', 'Attemping to getting an null setting key: ' + key);
          return null;
        }
    }

    public function getDumpedConfig() : Map<String,String> {
        if (!sys.FileSystem.exists(this.userdir+'config.dump')) {
            return new Map();
        }

        // var config = php.Lib.unserialize(sys.io.File.getContent(this.userdir+'config.dump')); same as line 109
        var config : Map<String,String> = haxe.Unserializer.run(sys.io.File.getContent(this.userdir+'config.dump'));


        return config;
    }

    public function getDumpedConfigKey(key:String) : String {
        // var config = php.Lib.unserialize(sys.io.File.getContent(this.userdir+'config.dump')); same as line 109
        var config : Map<String,String> = haxe.Unserializer.run(sys.io.File.getContent(this.userdir+'config.dump'));

        if (config[key] != null) {
            return config[key];
        } else {
          Main.log.log('Warning', 'Attemping to getting an unexistent config key: ' + key);
          return null;
        }
    }

    public function isSupported(key) : Bool {
        this.reload();
        if (this.caps != null) {
            switch (key) {
                case 'pubsub':
                    return this.caps.indexOf('http://jabber.org/protocol/pubsub#persistent-items') != -1;
                case 'upload':
                    var ser : Server = haxe.Unserializer.run(Main.config['Caps'][this.getServer()]);
                    if( ser != null && ser.features.indexOf('xmpp') != null && ser.features.indexOf('http') != null && ser.features.indexOf('upload') != null && ser.features.indexOf('urn') != null ) {
                      return true;
                    } else if( ser == null ) {
                      Main.log.log('Error', 'Unknow user server: ' + this.getServer());
                    } else {
                      return false;
                    }
                default:
                    return false;
            }
        }
        if (key == 'anonymous') {
            var session = Session.start();
            return session.get('mechanism') == 'ANONYMOUS';
        }
        return false;
    }
}
