
/**
 * @file index.php
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


  public function new() {
    try {
      var bootstrap = new Bootstrap();
      bootstrap.boot();
    } catch(e:Dynamic) {
      trace(e);
      trace( 'Oops, something went wrong, please check the log files' );
    }

    var rqst = new Front();
    rqst.handle();

    Wrapper.getInstance(false);
    // Closing stuff
    Wrapper.destroyInstance();
  }

  macro private static function getVersion() : haxe.macro.Expr.ExprOf<String> {
    return macro $v{sys.io.File.getContent('../VERSION')};
  }

  macro public static function ini_file( file : String ) : ExprOf<String> {
    return macro $v{sys.io.File.getContent(file)};
  }

  static function main() {
    new Main();
  }
}
