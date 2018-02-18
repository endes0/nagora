<?php

use Respect\Validation\Validator;
use Modl\PostnDAO;
use Modl\ContactDAO;

class Search extends \Movim\Widget\Base
{
    function load()
    {
        $this->addjs('search.js');
        $this->addcss('search.css');
    }

    function ajaxRequest()
    {
        $view = $this->tpl();
        $view->assign('empty', $this->prepareSearch(''));

        $cd = new ContactDAO;
        $view->assign('contacts', $cd->getRoster());
        $view->assign('presencestxt', getPresencesTxt());

        Drawer::fill($view->draw('_search', true), true);
        $this->rpc('Search.init');
    }

    function prepareSearch($key)
    {
        $view = $this->tpl();

        $validate_subject = Validator::stringType()->length(1, 15);
        if(!$validate_subject->validate($key)) {
            $view->assign('empty', true);
        } else {
            $view->assign('empty', false);
            $view->assign('presencestxt', getPresencesTxt());

            $posts = false;

            if($this->user->isSupported('pubsub')) {
                $pd = new PostnDAO;
                $posts = $pd->search($key);
            }

            $view->assign('posts', $posts);

            if(!$posts) $view->assign('empty', true);
        }

        if(!empty($key)) {
            $cd = new \Modl\ContactDAO;
            $contacts = $cd->searchJid($key);

            if($contacts)
                $view->assign('contacts', $contacts);
            if(Validator::email()->validate($key)) {
                $c = new \Modl\Contact($key);
                $c->jid = $key;
                $view->assign('contacts', [$c]);
            }
        } else {
            $view->assign('contacts', null);
        }

        return $view->draw('_search_results', true);
    }

    function ajaxSearch($key)
    {
        $this->rpc('MovimTpl.fill', '#results', $this->prepareSearch($key));
        $this->rpc('Search.searchClear');
    }

    function ajaxChat($jid)
    {
        $contact = new ContactActions;
        $contact->ajaxChat($jid);
    }
}
