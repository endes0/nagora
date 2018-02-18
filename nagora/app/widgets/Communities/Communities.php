<?php

use Respect\Validation\Validator;

class Communities extends \Movim\Widget\Base
{
    public function load()
    {
        $this->addjs('communities.js');
        $this->addcss('communities.css');
    }

    function ajaxGet()
    {
        $this->rpc('MovimTpl.fill', '#communities', $this->prepareCommunities());
    }

    function prepareCommunities()
    {
        $id = new \Modl\InfoDAO;
        $cd = new \Modl\ConfigDAO;
        $config = $cd->get();

        $view = $this->tpl();
        $view->assign('communities', $id->getItems(
            false,
            0,
            40,
            true, ($config->restrictsuggestions == true) ? $this->user->getServer() : false
        ));

        return $view->draw('_communities', true);
    }

    function getLastPublic($server, $node)
    {
        $pd = new \Modl\PostnDAO;
        return $pd->getPublic($server, $node, 0, 1)[0];
    }
}
