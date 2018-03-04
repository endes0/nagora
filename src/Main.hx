
/**
 * @file Main
 * This file is part of Movim.
 *
 * @brief Prepares all the needed fixtures and fires up the main request
 * handler.
 *
 * @author endes <endes@disroot.org>
 *
 * Copyright (C)2018 endes
 * Copyright (C)2013 Movim Project
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * @mainpage
 *
 * Movim is an XMPP-based communication platform. It uses a widget-based UI
 * system. A widget is a combination of server-side and client-side scripts that
 * interact though a custom xmlrpc protocol.
 *
 * Movim's core is designed to ease the implementation of XMPP web-based clients,
 * using massively asynchronous javascript and abstracting XMPP calls into an
 * events-based API.
 */

import movim.Bootstrap;
import movim.controller.Front;
import movim.widget.Wrapper;

class Main {
  public static var dirs : {cache : String,
    log : String,
    config : String,
    users: String,
    themes: String,
    locales: String};
  public static var app : {title: String,
    name: String,
    version: String,
    small_picture_limit: Int};
  public static var api : String = 'https://api.movim.eu/';
  public static var timezone : datetime.Timezone;
  public static var log : easylog.EasyLogger;

  public static var session_id : String;
  public static var config(default, set) : Map<String,Map<String,String>>;
  static function set_config(v:Map<String,Map<String,String>>) : Map<String,Map<String,String>> {
    if( Main.config != null ) {
      try {
        #if nodejs
          Jsinimanager.writeToFile(v, Main.dirs.config + 'config.ini');
        #else
          hxIni.IniManager.writeToFile(v, Main.dirs.config + 'config.ini');
        #end
      } catch(e:Dynamic) {
        throw 'Error saving config file, posibily was corrupted in this saving process. Error: ' + e;
      }
    }
    Main.config = v;
    return v;
  }

  public function new() {
    try {
      var bootstrap = new Bootstrap();
      bootstrap.boot();
    } catch(e:Dynamic) {
      trace(e);
      trace( haxe.CallStack.toString(haxe.CallStack.exceptionStack()) );
      throw ( 'Oops, something went wrong, please check the log files' );
    }

    var rqst = new Front();
    rqst.handle();

    Wrapper.getInstance();
    // Closing stuff
    Wrapper.destroyInstance();
  }

  public static function display( content : String ) : Void {
    #if js
    js.Browser.document.body.innerHTML = content;
    #end
  }

  static function main() {
    new Main();
  }
}
