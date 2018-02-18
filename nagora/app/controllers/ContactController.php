<?php

use Movim\Controller\Base;
use Movim\User;

class ContactController extends Base
{
    function load()
    {
        $this->session_only = true;
    }

    function dispatch()
    {
        $this->page->setTitle(__('page.contacts'));

        $user = new User;
        if(!$user->isLogged() && $this->fetchGet('s')) {
            $this->redirect('blog', [$this->fetchGet('s')]);
        }
    }
}
