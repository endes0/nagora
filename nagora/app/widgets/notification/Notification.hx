package app.widgets.notification;

import movim.Session;

class Notification extends movim.widget.Base {
    private static var onclick_funcs : Array<Void -> Void> = new Array();
    public static var inhibited : Bool = false;
    public static var tab_counter1 : Int = 0;
    public static var tab_counter2 : Int = 0;
    public static var tab_counter1_key : String = 'chat';
    public static var tab_counter2_key : String = 'news';

    override public function load() : Void {
    }

    /**
     * @brief Notify something
     * @param key The key to group the notifications
     * @param title The displayed title
     * @param body The displayed body
     * @param body The displayed URL
     * @param time The displayed time (in secondes)
     * @param action An action
     */
    static public function append(?key:String, ?title:String, ?body:String, ?picture:String, time:Int=2, ?action:String, ?group:Int, ?execute:Void->Void) : Void {
        // In this case we have an action confirmation
        if(key == null && title != null) {
            //TODO Android toast
            /*if(typeof Android !== 'undefined') {
                Android.showToast(title);
                return;
            }*/

            js.Browser.document.getElementById('toast').innerHTML = title;
            haxe.Timer.delay(function() : Void {
              js.Browser.document.getElementById('toast').innerHTML = '';
            }, 3000);
            return;
        }

        if(picture == null) {
            picture = 'themes/' + Main.config['Config']['theme'] + '/img/app/128.png';
        }

        var session = Session.start();
        var notifs : Map<String,Int> = session.get('notifs');

        if(title != null) {
            if( inhibited || js.Browser.document.hasFocus() ) {
              return;
            }

            var notification = new js.html.Notification(title, {icon: picture, body: body});

            if(action != null) {
                notification.onclick = function() {
                    js.Browser.window.location.href = action;
                    Notification.snackbarClear();
                    notification.close();
                }
            }

            if(execute != null) {
                notification.onclick = function() {
                    execute();
                    Notification.snackbarClear();
                    notification.close();
                }
            }
        }

        var notifs_key : Array<String> = session.get('notifs_key');

        if(notifs == null) notifs = new Map();

        var explode = key.split('|');
        var first = explode[0];

        // What we receive is not what it's on the screen on Android
        if(key != null && explode != notifs_key && title != null) {
            if(group != null) action = Std.string(group);
            //TODO Android
            /*if(typeof Android !== 'undefined') {
                Android.showNotification(title, body, picture, action);
                return;
            }*/
        }

        if(notifs.exists(first)) {
            notifs[first]++;
        } else {
            notifs[first] = 1;
        }

        if(notifs_key != null && explode == notifs_key) return;

        //TODO rpc
        //RPC.call('Notification.counter', first, notifs[first]);

        if(first != key) {
            if(notifs.exists(key)) {
                notifs[key]++;
            } else {
                notifs[key] = 1;
            }

            //TODO rpc
            //RPC.call('Notification.counter', key, notifs[key]);
        }

        if(title != null) {
            var n = new Notification();
            //TODO rpc
            /*RPC.call(
                'Notification.snackbar',
                n.prepareSnackbar(title, body, picture, action, execute),
                time);*/
        }

        session.set('notifs', notifs);
    }

    public static function counter(key: String, counter: Int) : Void {
      var counters = js.Browser.document.querySelectorAll('.counter');
      for(n in counters) {
          var n : js.html.Element = cast( n, js.html.Element );
          if(n.dataset.key != null
          && n.dataset.key == key) {
              n.innerHTML = Std.string(counter);
          }
      }

      Notification.setTab(key, counter);
      Notification.displayTab();
    }

    public static function setTab(key: String, counter: Int) : Void {
      if(counter == null) counter = 0;

      if(Notification.tab_counter1_key == key) {
          Notification.tab_counter1 = counter;
      }
      if(Notification.tab_counter2_key == key) {
          Notification.tab_counter2 = counter;
      }
    }

    public static function displayTab() : Void {
      if(Notification.tab_counter1 == 0 && Notification.tab_counter2 == 0) {
          js.Browser.document.title = js.Browser.document.title;

          //if(Notification.favicon != null) Notification.favicon.badge(0);
      } else {
          js.Browser.document.title =
              '('
              + Notification.tab_counter1
              + '/'
              + Notification.tab_counter2
              + ') '
              + js.Browser.document.title;

          //if(Notification.favicon != null) Notification.favicon.badge(Notification.tab_counter1 + Notification.tab_counter2);
      }
    }

    public static function refresh(keys : Map<String,Int>) : Void {
      var counters = js.Browser.document.querySelectorAll('.counter');
      for(n in counters) {
          var n : js.html.Element = cast( n, js.html.Element );
          if(n.dataset.key != null
          && keys[n.dataset.key] != null) {
              n.innerHTML = Std.string(keys[n.dataset.key]);
          }
      }

      for(key in keys.keys()) {
          var counter = keys[key];
          Notification.setTab(key, counter);
      }

      Notification.displayTab();
    }

    /**
     * @brief Clear the counter of a key
     * @param key The key to group the notifications
     */
    public function ajaxClear(key:String) : Void {
        var session = Session.start();
        var notifs : Map<String,Int> = session.get('notifs');

        if(notifs != null && notifs.exists(key)) {
            var counter = notifs[key];
            notifs[key] = null;

            Notification.counter(key, 0);

            var explode = key.split('|');
            var first = explode[0];

            if(notifs.exists(first)) {
                notifs[first] = notifs[first] - counter;

                if(notifs[first] <= 0) {
                    notifs[first] = null;
                    Notification.counter(first, 0);
                } else {
                    Notification.counter(first, notifs[first]);
                }
            }
        }

        session.set('notifs', notifs);
    }

    /**
     * @brief Get all the keys
     */
    public function ajaxGet() : Void {
        var session = Session.start();
        var notifs : Map<String,Int> = session.get('notifs');
        if(notifs != null) Notification.refresh(notifs);
    }

    /**
     * @brief Get all the keys
     */
    public function getCounter(key) : Int {
        var session = Session.start();
        var notifs : Map<String,Int> = session.get('notifs');
        if(notifs != null && notifs.exists(key)) {
            return notifs[key];
        }

        return 0;
    }

    /**
     * @brief Set the current used key (to prevent notifications on current view)
     */
    public function ajaxCurrent(key:String) : Void {
        var session = Session.start();
        var notifs_key : Array<String> = session.get('notifs_key');
        notifs_key.push(key);
        session.set('notifs_key', notifs_key);
    }

    @:expose public static function make_onclick( func : Int ) : Void {
      onclick_funcs[func]();
      snackbarClear();
    }

    public static inline function snackbarClear() : Void {
      js.Browser.document.getElementById('snackbar').innerHTML = '';
    }

    public function prepareSnackbar(title : String, ?body : String, ?picture : String, ?action : Int, ?execute : Void -> Void) : String {
        return hhp.Hhp.render('nagora/app/widgets/notification/_notification.tpl', {
                    title : title,
                    body : body,
                    picture : picture,
                    action : action,
                    onclick : if(execute != null) Notification.onclick_funcs.push(execute) else null
                  });
    }
}
