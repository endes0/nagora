<?php

class Subscribe extends \Movim\Widget\Base
{
    function load()
    {
    }

    function flagPath($country)
    {
        return BASE_URI.'themes/material/img/flags/'.strtolower($country).'.png';
    }

    function accountNext($server)
    {
        return $this->route('accountnext', [$server]);
    }

    function display()
    {
        $json = requestURL(MOVIM_API.'servers', 3, false, true);
        $json = json_decode($json);

        $cd = new \Modl\ConfigDAO;
        $this->view->assign('config', $cd->get());

        if(is_object($json) && $json->status == 200) {
            $this->view->assign('servers', $json->servers);
        }
    }
}
