package movim.template;

import movim.controller.Ajax;
import movim.widget.Wrapper;
import hhp.Hhp;

@:autoBuild(hhp.TemplateBuilder.build())
class Builder {
    //TODO: limit access to class builder
    public var theme : String = 'movim';
    public var _view : String = '';
    public var _title : String = '';
    public var _content : String = '';
    public var user : User;
    public var css : Array<String> = [];
    public var _scripts : Array<String> = [];
    public var _dir : String = 'ltr';
    public var _public : Bool;

    private var _buffer : String = '';
    private var _isLayoutDisabled : Bool = false;

    /**
     * Constructor. Determines whether to show the login page to the user or the
     * Movim interface.
     */
    public function new(?user : User) {
        this.user = user;

        if( Main.config['Config']['theme'] == null ) {
          Main.config['Config']['theme'] = 'material';
        }
        this.theme = Main.config['Config']['theme'];
    }

    /*public function viewsPath(file) : Void {
        return VIEWS_PATH + '/' + file;
    }*/

    /**
     * Returns or prints the link to a file.
     * @param file is the path to the file relative to the theme's root
     * @param return optionally returns the link instead of printing it if set to true
     */
    public function linkFile(file : String, _return:Bool=false) : String {
        var path = 'themes/' + this.theme + '/' + file;

        if(_return) {
            return path;
        } else {
            this.echo(path);
            return '';
        }
    }

    /**
     * Inserts the link tag for a css file.
     */
    public function themeCss(file : String) : Void {
        this.echo( '<link rel="stylesheet" href="'
            + this.linkFile(file, true) +
            "\" type=\"text/css\" />\n");
    }

    /**
     * Actually generates the page from templates.
     */
    public function build(view : String, _public:Bool=false) : String {
        this._view = view;
        this._public = _public;

        var template : Dynamic = Macro.prebuild_all_tmp(movim.template.Builder).get(this._view+'.tpl'); //hhp.Hhp.render('views/' + template, null, this);
        template.theme = this.theme;
        template._view = this._view;
        template._title = this._title;
        template._content = this._content;
        template.user = this.user;
        template.css = this.css;
        template._scripts = this._scripts;
        template._dir = this._dir;
        template._public = this._public;

        var outp : String = template.execute();

        var scripts = this.printCss();
        if(!_public) {
            scripts += this.printScripts();
        }

        outp = StringTools.replace(outp, '<%scripts%>', scripts);

        return outp;
    }

    /**
     * Sets the page's title.
     */
    public function setTitle(name)
    {
        _title = name;
    }

    /**
     * Displays the current title.
     */
    public function title() : Void {
        var widgets = Wrapper.getInstance();
        if(widgets.title != '' && widgets.title != null) {
            _title += ' - ' + widgets.title;
        }

        this.echo(_title);
    }

    /**
     * Displays the current title.
     */
    public function dir() : Void {
        if( this.user != null ) {
          this.user.reload(true);
          var lang = this.user.getConfig('language');

          if(['ar', 'he', 'fa'].indexOf(lang) != -1) {
              this._dir = 'rtl';
          }
        }

        this.echo(this._dir);
    }

    /**
     * Display some meta tag defined in the widgets using Facebook OpenGraph
     */
    /* public function meta() : Void{
        var dom = new \DOMDocument('1.0', 'UTF-8');
        dom.formatOutput = true;

        metas = dom.createElement('xml');
        dom.appendChild(metas);

        widgets = Wrapper.getInstance();

        if(isset(widgets.title)) {
            meta = dom.createElement('meta');
            meta.setAttribute('property', 'og:title');
            meta.setAttribute('content', widgets.title);
            metas.appendChild(meta);

            meta = dom.createElement('meta');
            meta.setAttribute('name', 'twitter:title');
            meta.setAttribute('content', widgets.title);
            metas.appendChild(meta);
        }
        if(isset(widgets.image)) {
            meta = dom.createElement('meta');
            meta.setAttribute('property', 'og:image');
            meta.setAttribute('content', widgets.image);
            metas.appendChild(meta);

            meta = dom.createElement('meta');
            meta.setAttribute('name', 'twitter:image');
            meta.setAttribute('content', widgets.image);
            metas.appendChild(meta);
        }
        if(isset(widgets.description)) {
            meta = dom.createElement('meta');
            meta.setAttribute('property', 'og:description');
            meta.setAttribute('content', widgets.description);
            metas.appendChild(meta);

            meta = dom.createElement('meta');
            meta.setAttribute('name', 'twitter:description');
            meta.setAttribute('content', widgets.description);
            metas.appendChild(meta);

            meta = dom.createElement('meta');
            meta.setAttribute('name', 'description');
            meta.setAttribute('content', widgets.description);
            metas.appendChild(meta);
        } else {
            cd = new \Modl\ConfigDAO;
            config = cd.get();

            meta = dom.createElement('meta');
            meta.setAttribute('name', 'description');
            meta.setAttribute('content', config.description);
            metas.appendChild(meta);
        }
        if(isset(widgets.url)) {
            meta = dom.createElement('meta');
            meta.setAttribute('property', 'og:url');
            meta.setAttribute('content', widgets.url);
            metas.appendChild(meta);
        }

        if(isset(widgets.links)) {
            for(l in widgets.links) {
                link = dom.createElement('link');
                link.setAttribute('rel',  l.get('rel'));
                link.setAttribute('type', l.get('type'));
                link.setAttribute('href', l.get('href'));
                metas.appendChild(link);
            }
        }

        meta = dom.createElement('meta');
        meta.setAttribute('property', 'og:type');
        meta.setAttribute('content', 'article');
        metas.appendChild(meta);

        meta = dom.createElement('meta');
        meta.setAttribute('property', 'twitter:card');
        meta.setAttribute('content', 'summary_large_image');
        metas.appendChild(meta);

        meta = dom.createElement('meta');
        meta.setAttribute('property', 'twitter:site');
        meta.setAttribute('content', 'MovimNetwork');
        metas.appendChild(meta);

        echo StringTools.stripTags(dom.saveXML(dom.documentElement), '<meta><link>');
    } */

    public function addScript(script : String) : Void {
        _scripts.push(StringTools.urlEncode('app/assets/js/' + script));
    }

    /**
     * Inserts the link tag for a css file.
     */
    public function addCss(file) : Void {
        this.css.push(this.linkFile('css/' + file, true));
    }

    public function scripts() : Void {
        this.echo('<%scripts%>');
    }

    public function printScripts() : String {
        var out = '';
        var widgets = Wrapper.getInstance();
        var scripts = _scripts.concat(widgets.loadjs());
        for(script in scripts) {
             out += '<script type="text/javascript" src="'
                 + script +
                 '"></script>'+"\n";
        }

        var ajaxer = Ajax.getInstance();
        out += ajaxer.genJs();

        return out;
    }

    public function printCss() : String {
        var out = '';
        var widgets = Wrapper.getInstance();
        var csss = this.css.concat(widgets.loadcss()); // Note the 3rd s, there are many.
        for(css_path in csss) {
            out += '<link rel="stylesheet" href="'
                + css_path +
                "\" type=\"text/css\" />\n";
        }
        return out;
    }

    public function setContent(data : String) : Void {
        this._content += data;
    }

    public function content() : Void {
        this.echo(this._content);
    }

    /**
     * Loads up a widget and prints it at the current place.
     */
    public function widget(name) : Void {
        var widgets = Wrapper.getInstance();
        widgets.setView(this._view);

        this.echo(widgets.runWidget(name, 'build', []));
    }

    public function echo (v:Dynamic) : Void {
       this._buffer += (v == null ? '' : Std.string(v));
   }

   public inline function getBuffer () : String {
       return this._buffer;
   }

   public function execute () : String {
       return this._buffer;
   }

   public function clearBuffer () : Void {
       this._buffer = '';
   }

   public function disableLayout () : Void {
       this._isLayoutDisabled = true;
}
}
