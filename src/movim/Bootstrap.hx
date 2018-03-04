
package movim;

import easylog.EasyLogger;

class Bootstrap {

    public function new() : Void {}

    public function boot() : Void {
        //define all needed constants
        this.setConstants();

        //mb_internal_encoding("UTF-8");

        //First thing to do, define error management (in case of error forward)
        this.setLogs();

        //Check if vital system need is OK
        this.checkSystem();

        /*this.loadCommonLibraries();
        this.loadDispatcher();
        this.loadHelpers();*/

        var loadmodlsuccess : Bool = this.loadModl();

        this.setTimezone();
        //this.setLogLevel();

        if (loadmodlsuccess) {
            this.startingSession();
            this.loadLanguage();
        } else {
            throw 'Error loading Modl';
        }
    }

    private function checkSystem() : Void {
        var listWritableFile : Array<String> = [
            Main.dirs.log + 'Error.log',
            Main.dirs.log + 'Warning.log',
            Main.dirs.log + 'Info.log',
            Main.dirs.log + 'Debug.log',
            Main.dirs.cache + '/test.tmp',
        ];
        var errors : Array<String> = [];

        if (!sys.FileSystem.exists(Main.dirs.cache)) {
          try {
            sys.FileSystem.createDirectory(Main.dirs.cache);
          } catch(e:Dynamic) {
            errors.push('Couldn\'t create directory cache:' + e);
          }
        }
        if (!sys.FileSystem.exists(Main.dirs.log)) {
          try {
            sys.FileSystem.createDirectory(Main.dirs.log);
          } catch(e:Dynamic) {
            errors.push('Couldn\'t create directory log:' + e);
          }
        }
        if (!sys.FileSystem.exists(Main.dirs.config)) {
          try {
            sys.FileSystem.createDirectory(Main.dirs.config);
          } catch(e:Dynamic) {
            errors.push('Couldn\'t create directory config:' + e);
          }
        }
        if (!sys.FileSystem.exists(Main.dirs.users)) {
          try {
            sys.FileSystem.createDirectory(Main.dirs.users);
            #if nodejs
              sys.io.File.saveContent(Main.dirs.users + '/index.html', ' ');
            #end
          } catch(e:Dynamic) {
            errors.push('Couldn\'t create directory users:' + e);
          }
        } else {
          #if nodejs
            if (sys.FileSystem.exists(Main.dirs.users + '/index.html')) {
              sys.io.File.saveContent(Main.dirs.users + '/index.html', sys.io.File.getContent(Main.dirs.users + '/index.html'));
            } else {
              sys.io.File.saveContent(Main.dirs.users + '/index.html', ' ');
            }
          #else
            sys.io.File.append(Main.dirs.users + '/index.html').close();
          #end
        }

        if (errors.length > 0) {
          errors.push('We\'re unable to write to app folder: check rights');
        }

        for(fileName in listWritableFile) {
            if (!sys.FileSystem.exists(fileName)) {
              try {
                #if nodejs
                  sys.io.File.saveContent(fileName, ' ');
                #else
                  sys.io.File.write(fileName).close();
                #end
              } catch(e:Dynamic) {
                errors.push('We\'re unable to write to ' + fileName + ': check rights (Error:' + e + ')');
              }
            } else {
              try {
                #if nodejs
                  sys.io.File.saveContent(fileName, sys.io.File.getContent(fileName));
                #else
                  sys.io.File.append(fileName).close();
                #end
              } catch(e:Dynamic) {
                errors.push('We\'re unable to write to file ' + fileName + ': check rights (Error:' + e + ')');
              }
            }
        }
        if (errors.length > 0) {
            throw errors.join("\n<br />");
        }
    }

    private function setConstants() : Void {
        Main.app = {
          title: 'Movim',
          name: 'movim',
          version: Macro.getVersion(),
          small_picture_limit: 320000
        };

        Main.dirs = {
          themes: 'themes/',
          users: 'users/',
          locales: 'locales/',
          cache: 'cache/',
          log: 'log/',
          config: 'config/'
        };
    }

    /* private function loadCommonLibraries() : Void {
        // XMPPtoForm lib
        import /*LIB_PATH . 'XMPPtoForm.php'*/;

        // SDPtoJingle and JingletoSDP lib :)
        /* import LIB_PATH . 'SDPtoJingle.php';
        import LIB_PATH . 'JingletoSDP.php';
    } */

    /*private function loadHelpers() : Void {
        for (file in glob(HELPERS_PATH + '*Helper.php')) {
            require file;
        }
    }*/

    /*private function loadDispatcher() : Void
    {
        import APP_PATH . 'widgets/Notification/Notification.php';
    }*/

    /**
     * Loads up the language, either from the User or default.
     */
    public function loadLanguage() : Void{
        var user = new User();

        var config = Main.config['Config'];

        var l = movim.i18n.Locale.start();

        var lang = null;
        if (user.isLogged()) {
          var lang = user.getConfig('language');
        }

        if (lang != null) {
            l.load(lang);
        } else if (Sys.environment()['language'] != null) {
            l.detect(Sys.environment()['language']);
            l.loadPo();
        } else {
            l.load(config['locale']);
        }
    }

    private function setLogs() : Void {
      Main.log = new EasyLogger(Main.dirs.log + "[logType].log");
      Main.log.consoleOutput = true;
    }

    private function setTimezone() : Void {
      Main.timezone = datetime.Timezone.local();
    }

    private function loadModl() : Bool {
        #if nodejs
          Main.config = Jsinimanager.loadFromFile(Main.dirs.config + 'config.ini');
        #else
          Main.config = hxIni.IniManager.loadFromFile(Main.dirs.config + 'config.ini');
        #end
        if(Main.config == null) Main.config = new Map();

        for( part in ['Config', 'Presence', 'Contact', 'Privacy', 'RosterLink', 'Cache', 'Postn', 'Info', 'EncryptedPass', 'Subscription', 'SharedSubscription', 'Caps', 'Invite', 'Message', 'Sessionx', 'Setting', 'Conference', 'Tag', 'Url'] ) {
          if( !Main.config.exists(part) ) {
            Main.config[part] = new Map();
          }
        }

        Main.session_id = Main.config['Sessionx']['session'];

        return true;
    }

    private function startingSession() : Void {
        if (Main.session_id != null) {
            var req = new haxe.Http('http://localhost:1560/exists/');
            req.addParameter('sid', Main.session_id);
            req.onData = function( d : String ) : Void {
              var process : Bool = if(d == 'true') true else false;

              var session = Main.config['Sessionx'];

              if (session != null) {
                  // There a session in the DB but no process
                  if (!process) {
                      Main.config['Sessionx'] = new Map();
                      return;
                  }

                  var s = Session.start();
                  s.set('jid', session['jid']);
                  s.set('host', session['host']);
                  s.set('username', session['username']);
              } else if (process) {
                  // A process but no session in the db
                  var req = new haxe.Http('http://localhost:1560/disconnect/');
                  req.addParameter('sid', Main.session_id);
                  req.onError = function( e:String ) : Void {
                    Main.log.log(EasyLogger.Warning, "Error on disconnecting daemon: " + e);
                  }
                  req.request(true);
              }
            }
            req.onError = function( e:String ) : Void {
              Main.log.log(EasyLogger.Error, "Error on checking id in the daemon: " + e);
            }
            req.request(true);
        }
    }

    public static function getWidgets() : Array<String> {
        //TODO: completar
        return ['Account','AccountNext','Ack','AdHoc','Avatar','Bookmark',
        'Communities','CommunityAffiliations','CommunityConfig','CommunityData',
        'CommunityHeader','CommunityPosts','CommunitiesServer','CommunitiesServers',
        'Chat','Chats','Config','ContactData','ContactHeader','Dialog','Drawer',
        'Header','Init','Login','LoginAnonymous','Menu','Notifs','Invitations',
        'Post','PostActions','Presence','PublishBrief','Rooms',
        'Roster','Stickers','Upload','Vcard4','Visio','VisioLink'];
    }
}
