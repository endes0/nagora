<?php
use Movim\Controller\Base;

class AccountnextController extends Base
{
    function load()
    {
        $this->session_only = false;
    }

    function dispatch()
    {
        $this->page->setTitle(__('page.account_creation'));
    }
}
