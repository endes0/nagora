
package movim;

import easylog.EasyLogger;

class Bootstrap {

    public function boot() : Void {
        //define all needed constants
        this.setConstants();

        //mb_internal_encoding("UTF-8");

        //First thing to do, define error management (in case of error forward)
        this.setLogs();

        //Check if vital system need is OK
        this.checkSystem();

        this.loadCommonLibraries();
        this.loadDispatcher();
        this.loadHelpers();

        var loadmodlsuccess : Bool = this.loadModl();

        this.setTimezone();
        this.setLogLevel();

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
        if (!sys.FileSystem.exists(Main.dirs.user)) {
          try {
            sys.FileSystem.createDirectory(Main.dirs.user);
          } catch(e:Dynamic) {
            errors.push('Couldn\'t create directory users:' + e);
          }
        } else {
          sys.io.File.write(Main.dirs.user + '/index.html').close();
        }

        if (errors.length > 0) {
          errors.push('We\'re unable to write to app folder: check rights');
        }

        for(fileName in listWritableFile) {
            if (!sys.FileSystem.exists(fileName)) {
              try {
                sys.io.File.write(fileName).close();
              } catch(e:Dynamic) {
                errors.push('We\'re unable to write to ' + fileName + ': check rights (Error:' + e + ')');
              }
            } else {
              try {
                sys.io.File.append(fileName).close();
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
        Main.app.title = 'Movim';
        Main.app.name = 'movim';
        Main.app.version = Main.getVersion();
        //Main.app.secured = this.isServerSecured();
        Main.app.small_picture_limit = 320000;

        //TODO: config storage
        if (isset(_COOKIE.get('MOVIM_SESSION_ID'))) {
            define('SESSION_ID',    _COOKIE.get('MOVIM_SESSION_ID'));
        } else {
            define('SESSION_ID',    getenv('sid'));
        }

        Main.dirs.themes = 'themes/';
        Main.dirs.user = 'users/';
        Main.dirs.locales = 'locales/';
        Main.dirs.cache = 'cache/';
        Main.dirs.log = 'log/';
        Main.dirs.config ='config/';
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

        //TODO: db
        //cd = new \Modl\ConfigDAO;
        //config = cd.get();

        var l = movim.i18n.Locale.start();

        if (user.isLogged()) {
          var lang = user.getConfig('language');
        }

        if (lang != null) {
            l.load(lang);
        } else if (Sys.enviroment['language'] != null) {
            l.detect(Sys.enviroment['language']);
            l.loadPo();
        } else {
            l.load(config.locale);
        }
    }

    private function setLogs() : Void {
      Main.log = new EasyLogger(Main.dirs.log + "[logType].log");
    }

    private function setTimezone() : Void {
      Main.timezone = datetime.Timezone.local();
    }

    private function loadModl() : Void {
      //TODO: db
        // We load Movim Data Layer
        /*db = \Modl\Modl.getInstance();
        db.setModelsPath(APP_PATH+'models');

        \Modl\Utils.loadModel('Config');
        \Modl\Utils.loadModel('Presence');
        \Modl\Utils.loadModel('Contact');
        \Modl\Utils.loadModel('Privacy');
        \Modl\Utils.loadModel('RosterLink');
        \Modl\Utils.loadModel('Cache');
        \Modl\Utils.loadModel('Postn');
        \Modl\Utils.loadModel('Info');
        \Modl\Utils.loadModel('EncryptedPass');
        \Modl\Utils.loadModel('Subscription');
        \Modl\Utils.loadModel('SharedSubscription');
        \Modl\Utils.loadModel('Caps');
        \Modl\Utils.loadModel('Invite');
        \Modl\Utils.loadModel('Message');
        \Modl\Utils.loadModel('Sessionx');
        \Modl\Utils.loadModel('Setting');
        \Modl\Utils.loadModel('Conference');
        \Modl\Utils.loadModel('Tag');
        \Modl\Utils.loadModel('Url');

        if (sys.FileSystem.exists(DOCUMENT_ROOT+'/config/db.inc.php')) {
            require DOCUMENT_ROOT+'/config/db.inc.php';
        } else {
            throw new \Exception('Cannot find config/db.inc.php file');
        }

        db.setConnectionArray(conf);
        db.connect();*/

        return true;
    }

    private function startingSession() : Void {
        if (Main.session_id != null) {
            var req = new haxe.Http('http://localhost:1560/exists/');
            req.addParameter('sid', Main.session_id);
            req.onData = function( d : String ) : Void {
              var process : Bool = if(d = 'true') true else false;

              //TODO: db
              /*var sd = new \Modl\SessionxDAO;
              var session = sd.get(Main.session_id); */

              if (session != null) {
                  // There a session in the DB but no process
                  if (!process) {
                      sd.delete(SESSION_ID);
                      return;
                  }

                  //TODO: db
                  var db = Modl.Modl.getInstance();
                  db.setUser(session.jid);

                  var s = Session.start();
                  s.set('jid', session.jid);
                  s.set('host', session.host);
                  s.set('username', session.username);
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

    public static function getWidgets() : Void {
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
