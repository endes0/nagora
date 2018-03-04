package movim.controller;

import movim.Route;
import app.controllers.*;

class Front extends Base {
    public function handle() : Void {
        var r = new Route();
        this.runRequest(r.find());
    }

    public function loadController(request:String) : Base {
      switch request {
      /*case 'about': return new AboutController();
      case 'account': return new AccountController();
      case 'accountnext': return new AccountnextController();
      case 'admin': return new AdminController();
      case 'adminlogin': return new AdminloginController();
      case 'blog': return new BlogController();
      case 'chat': return new ChatController();
      case 'community': return new CommunityController();
      case 'conf': return new ConfController();
      case 'contact': return new ContactController();
      case 'disconnect': return new DisconnectController();
      case 'feed': return new FeedController();
      case 'help': return new HelpController();
      case 'infos': return new InfosController();
      case 'login': return new LoginController();
      case 'news': return new NewsController();
      case 'node': return new NodeController();
      case 'notfound': return new NotfoundController();
      case 'picture': return new PictureController();
      case 'popuptest': return new PopuptestController();
      case 'post': return new PostController();
      case 'room': return new RoomController();
      case 'share': return new ShareController();
      case 'system': return new SystemController();
      case 'tag': return new TagController();
      case 'visio': return new VisioController(); */
      case _:
        Main.log.log('Error', "Requested controller " + request + "Controller doesn't exist.");
        throw 'Error loading Controller, see logs.';
      }

    }

    /**
     * Here we load, instanciate and execute the correct controller
     */
    public function runRequest(request : String, ?json : Dynamic) : Void {
        if(request == 'ajax') {
            var req = new haxe.Http('http://localhost:1560/ajax/');
            req.addParameter('sid', Main.session_id);
            req.addParameter('json', StringTools.urlEncode(Std.string(json)));
            req.onError = function( e:String ) : Void {
              Main.log.log(easylog.EasyLogger.Warning, "Error on ajax request to daemon: " + e);
            }
            req.request(true);
            return;
        }

        var c = this.loadController(request);

        //Cookie.refresh();

        if (Reflect.hasField(c, 'load')) {
            c.name = request;
            //TODO c.load();
            Reflect.callMethod(c, Reflect.field(c, 'load'), []);
            c.checkSession();
            //TODO c.dispatch();
            Reflect.callMethod(c, Reflect.field(c, 'dispatch'), []);

            // If the controller ask to display a different page
            if (request != c.name) {
                var new_name = c.name;
                c = this.loadController(new_name);
                c.name = new_name;
                Reflect.callMethod(c, Reflect.field(c, 'load'), []);
                Reflect.callMethod(c, Reflect.field(c, 'dispatch'), []);
            }

            // We display the page !
            c.display();
        } else {
          Main.log.log(easylog.EasyLogger.Error, "Could not call the load method on the current controller");
        }
    }
}
