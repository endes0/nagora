class Macro {

  macro public static function getVersion() : ExprOf<String> {
    return macro $v{sys.io.File.getContent('./VERSION')};
  }

  macro public static function ini_file( file : ExprOf<String> ) : ExprOf<String> {
    var str = switch(file.expr) {
           case EConst(CString(str)):
               str;
           default:
               trace( file.expr );
               throw "type should be string const";
       }
    return macro $v{sys.io.File.getContent(str)};
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

  macro public static function prebuild_all_tmp(cl : haxe.macro.Expr) {
    var map : Array<haxe.macro.Expr> = [];
    var pos = haxe.macro.Context.currentPos();

    var parent : String = switch (cl.expr) {
        case EConst(CIdent('null')) : 'hhp.Template';
        case _                      : haxe.macro.ExprTools.toString(cl);
    }
    for (name in sys.FileSystem.readDirectory('nagora/app/views')) {
      var className : String = hhp.TemplateBuilder.createClass(name, pos, parent);
      map.push(macro $v{name} => $v{haxe.macro.Context.parse('new $className()', pos)});
    }
    return macro $a{map};
  }

  macro public static function import_all_widgets() : Void {
    haxe.macro.Compiler.include('app.widgets');
    haxe.macro.Compiler.keep('app.widgets');
  }

  macro public static function import_all_controllers() : Void {
    haxe.macro.Compiler.include('app.controllers');
    haxe.macro.Compiler.keep('app.controllers');
  }
}
