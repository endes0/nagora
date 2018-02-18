<?php
use Movim\Controller\Base;

class AdminloginController extends Base
{
    function load()
    {
        $this->session_only = false;
    }

    function dispatch()
    {
        $this->page->setTitle(__('page.administration'));

        $cd = new \Modl\ConfigDAO;
        $config = $cd->get();

        if(isset($_POST['username'])
        && $config->username == $_POST['username']
        && (password_verify($_POST['password'], $config->password)
            || $config->password == sha1($_POST['password']))) {
            $_SESSION['admin'] = true;
            $this->name = 'admin';
        }
    }
}
