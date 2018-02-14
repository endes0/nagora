<?php
namespace Movim\Template;

use Movim\Controller\Ajax;
use Movim\Widget\Wrapper;

class Builder
{
    private $theme = 'movim';
    private $_view = '';
    private $title = '';
    private $content = '';
    private $user;
    private $css = [];
    private $scripts = [];
    private $dir = 'ltr';
    private $public;

    /**
     * Constructor. Determines whether to show the login page to the user or the
     * Movim interface.
     */
    function __construct($user = null)
    {
        $this->user = $user;

        $cd = new \Modl\ConfigDAO;
        $config = $cd->get();
        $this->theme = $config->theme;
    }

    function viewsPath($file)
    {
        return VIEWS_PATH . '/' . $file;
    }

    /**
     * Returns or prints the link to a file.
     * @param file is the path to the file relative to the theme's root
     * @param return optionally returns the link instead of printing it if set to true
     */
    function linkFile($file, $return = false)
    {
        $path = urilize('themes/' . $this->theme . '/' . $file);

        if($return) {
            return $path;
        } else {
            echo $path;
        }
    }

    /**
     * Inserts the link tag for a css file.
     */
    function themeCss($file)
    {
        echo '<link rel="stylesheet" href="'
            . $this->linkFile($file, true) .
            "\" type=\"text/css\" />\n";
    }

    /**
     * Actually generates the page from templates.
     */
    function build($view, $public = false)
    {
        $this->_view = $view;
        $this->public = $public;
        $template = $this->_view.'.tpl';

        ob_start();

        require($this->viewsPath($template));
        $outp = ob_get_clean();

        $scripts = $this->printCss();
        if(!$public) {
            $scripts .= $this->printScripts();
        }

        $outp = str_replace('<%scripts%>',
                            $scripts,
                            $outp);

        return $outp;
    }

    /**
     * Sets the page's title.
     */
    function setTitle($name)
    {
        $this->title = $name;
    }

    /**
     * Displays the current title.
     */
    function title()
    {
        $widgets = Wrapper::getInstance();
        if(isset($widgets->title)) {
            $this->title .= ' - ' . $widgets->title;
        }
        echo $this->title;
    }

    /**
     * Displays the current title.
     */
    function dir()
    {
        $this->user->reload(true);
        $lang = $this->user->getConfig('language');

        if(in_array($lang, ['ar', 'he', 'fa'])) {
            $this->dir = 'rtl';
        }

        echo $this->dir;
    }

    /**
     * Display some meta tag defined in the widgets using Facebook OpenGraph
     */
    function meta()
    {
        $dom = new \DOMDocument('1.0', 'UTF-8');
        $dom->formatOutput = true;

        $metas = $dom->createElement('xml');
        $dom->appendChild($metas);

        $widgets = Wrapper::getInstance();

        if(isset($widgets->title)) {
            $meta = $dom->createElement('meta');
            $meta->setAttribute('property', 'og:title');
            $meta->setAttribute('content', $widgets->title);
            $metas->appendChild($meta);

            $meta = $dom->createElement('meta');
            $meta->setAttribute('name', 'twitter:title');
            $meta->setAttribute('content', $widgets->title);
            $metas->appendChild($meta);
        }
        if(isset($widgets->image)) {
            $meta = $dom->createElement('meta');
            $meta->setAttribute('property', 'og:image');
            $meta->setAttribute('content', $widgets->image);
            $metas->appendChild($meta);

            $meta = $dom->createElement('meta');
            $meta->setAttribute('name', 'twitter:image');
            $meta->setAttribute('content', $widgets->image);
            $metas->appendChild($meta);
        }
        if(isset($widgets->description)) {
            $meta = $dom->createElement('meta');
            $meta->setAttribute('property', 'og:description');
            $meta->setAttribute('content', $widgets->description);
            $metas->appendChild($meta);

            $meta = $dom->createElement('meta');
            $meta->setAttribute('name', 'twitter:description');
            $meta->setAttribute('content', $widgets->description);
            $metas->appendChild($meta);

            $meta = $dom->createElement('meta');
            $meta->setAttribute('name', 'description');
            $meta->setAttribute('content', $widgets->description);
            $metas->appendChild($meta);
        } else {
            $cd = new \Modl\ConfigDAO;
            $config = $cd->get();

            $meta = $dom->createElement('meta');
            $meta->setAttribute('name', 'description');
            $meta->setAttribute('content', $config->description);
            $metas->appendChild($meta);
        }
        if(isset($widgets->url)) {
            $meta = $dom->createElement('meta');
            $meta->setAttribute('property', 'og:url');
            $meta->setAttribute('content', $widgets->url);
            $metas->appendChild($meta);
        }

        if(isset($widgets->links)) {
            foreach($widgets->links as $l) {
                $link = $dom->createElement('link');
                $link->setAttribute('rel',  $l['rel']);
                $link->setAttribute('type', $l['type']);
                $link->setAttribute('href', $l['href']);
                $metas->appendChild($link);
            }
        }

        $meta = $dom->createElement('meta');
        $meta->setAttribute('property', 'og:type');
        $meta->setAttribute('content', 'article');
        $metas->appendChild($meta);

        $meta = $dom->createElement('meta');
        $meta->setAttribute('property', 'twitter:card');
        $meta->setAttribute('content', 'summary_large_image');
        $metas->appendChild($meta);

        $meta = $dom->createElement('meta');
        $meta->setAttribute('property', 'twitter:site');
        $meta->setAttribute('content', 'MovimNetwork');
        $metas->appendChild($meta);

        echo strip_tags($dom->saveXML($dom->documentElement), '<meta><link>');
    }

    function addScript($script)
    {
        $this->scripts[] = urilize('app/assets/js/' . $script);
    }

    /**
     * Inserts the link tag for a css file.
     */
    function addCss($file)
    {
        $this->css[] = $this->linkFile('css/' . $file, true);
    }

    function scripts()
    {
        echo '<%scripts%>';
    }

    function printScripts()
    {
        $out = '';
        $widgets = Wrapper::getInstance();
        $scripts = array_merge($this->scripts, $widgets->loadjs());
        foreach($scripts as $script) {
             $out .= '<script type="text/javascript" src="'
                 . $script .
                 '"></script>'."\n";
        }

        $ajaxer = Ajax::getInstance();
        $out .= $ajaxer->genJs();

        return $out;
    }

    function printCss()
    {
        $out = '';
        $widgets = Wrapper::getInstance();
        $csss = array_merge($this->css, $widgets->loadcss()); // Note the 3rd s, there are many.
        foreach($csss as $css_path) {
            $out .= '<link rel="stylesheet" href="'
                . $css_path .
                "\" type=\"text/css\" />\n";
        }
        return $out;
    }

    function setContent($data)
    {
        $this->content .= $data;
    }

    function content()
    {
        echo $this->content;
    }

    /**
     * Loads up a widget and prints it at the current place.
     */
    function widget($name)
    {
        $widgets = Wrapper::getInstance();
        $widgets->setView($this->_view);

        echo $widgets->runWidget($name, 'build');
    }
}
