<?php

use Moxl\Xec\Action\Presence\Chat;
use Moxl\Xec\Action\Presence\Away;
use Moxl\Xec\Action\Presence\DND;
use Moxl\Xec\Action\Presence\XA;
use Moxl\Xec\Action\Presence\Unavailable;

use Moxl\Xec\Action\Roster\GetList;

use Moxl\Xec\Action\Pubsub\GetItems;
use Moxl\Xec\Action\Storage\Get;

use Moxl\Stanza\Stream;

use Movim\Session;

class Presence extends \Movim\Widget\Base
{
    function load()
    {
        $this->addcss('presence.css');
        $this->addjs('presence.js');
        $this->registerEvent('avatar_get_handle', 'onMyPresence');
        $this->registerEvent('mypresence', 'onMyPresence');
        $this->registerEvent('session_up', 'onSessionUp');
        $this->registerEvent('session_down', 'onSessionDown');
    }

    function onSessionUp()
    {
        $p = new Chat;
        $p->request();
    }

    function onSessionDown()
    {
        $p = new Away;
        $p->request();
    }

    function onMyPresence($packet)
    {
        $html = $this->preparePresence();
        $this->rpc('MovimTpl.fill', '#presence_widget', $html);
        Notification::append(null, $this->__('status.updated'));
    }

    function start()
    {
        $this->rpc('Notification.inhibit', 15);

        // http://xmpp.org/extensions/xep-0280.html
        \Moxl\Stanza\Carbons::enable();

        // We refresh the roster
        $r = new GetList;
        $r->request();

        // We refresh the messages
        $c = new Chats;
        $c->ajaxGetHistory();

        $this->ajaxClear();
        $this->onSessionUp();
        $this->ajaxServerCapsGet();
        $this->ajaxBookmarksGet();
        $this->ajaxFeedRefresh();
        $this->ajaxServerDisco();
        $this->ajaxProfileRefresh();
    }

    function ajaxClear()
    {
        $pd = new \Modl\PresenceDAO;
        $pd->clearPresence();
    }

    function ajaxLogout()
    {
        $this->rpc('Presence.clearQuick');

        $ed = new \Modl\EncryptedPassDAO;
        $ed->delete();

        $session = Session::start();
        $p = new Unavailable;
        $p->setType('terminate')
          ->setResource($session->get('resource'))
          ->setTo($session->get('jid'))
          ->request();

        Stream::end();
    }

    function ajaxGetPresence()
    {
        $html = $this->preparePresence();
        if($html) $this->rpc('MovimTpl.fill', '#presence_widget', $html);
    }

    function ajaxConfigGet() {
        $s = new Get;
        $s->setXmlns('movim:prefs')
          ->request();
    }

    // We get the server capabilities
    function ajaxServerCapsGet()
    {
        $session = Session::start();
        $c = new \Moxl\Xec\Action\Disco\Request;
        $c->setTo($session->get('host'))
          ->request();
    }

    // We discover the server services
    function ajaxServerDisco()
    {
        $session = Session::start();
        $c = new \Moxl\Xec\Action\Disco\Items;
        $c->setTo($session->get('jid'))
          ->request();

        $c->setTo($session->get('host'))
          ->request();
    }

    // We refresh the profile
    function ajaxProfileRefresh()
    {
        $session = Session::start();
        $a = new \Moxl\Xec\Action\Avatar\Get;
        $a->setTo($session->get('jid'))
          ->request();

        $v = new \Moxl\Xec\Action\Vcard4\Get;
        $v->setTo($session->get('jid'))
          ->request();
    }

    // We refresh the bookmarks
    function ajaxBookmarksGet()
    {
        $session = Session::start();
        $b = new \Moxl\Xec\Action\Bookmark\Get;
        $b->setTo($session->get('jid'))
          ->request();
    }

    // We refresh our personnal feed
    function ajaxFeedRefresh()
    {
        // Replace me with GetItemsId when moving from Metronome
        $r = new GetItems;
        $r->setTo($this->user->getLogin())
          ->setNode('urn:xmpp:microblog:0')
          ->request();
    }

    function preparePresence()
    {
        $cd = new \Modl\ContactDAO;
        $pd = new \Modl\PresenceDAO;

        $session = Session::start();

        // If the user is still on a logued-in page after a daemon restart
        if($session->get('jid') == false) {
            $this->rpc('MovimUtils.disconnect');
            return false;
        }

        $presence = $pd->getPresence($session->get('jid'), $session->get('resource'));

        $presencetpl = $this->tpl();

        $contact = $cd->get();
        if($contact == null) {
            $contact = new \Modl\Contact;
        }

        if($presence == null) {
            $presence = new \Modl\Presence;
        }

        $presencetpl->assign('me', $contact);
        $presencetpl->assign('presence', $presence);
        $presencetpl->assign('presencetxt', getPresencesTxt());

        $html = $presencetpl->draw('_presence', true);

        return $html;
    }

    function display()
    {
        $cd = new \Modl\ContactDAO;
        $contact = $cd->get();
        if($contact == null) {
            $contact = new \Modl\Contact;
        }

        $this->view->assign('me', $contact);
    }
}

?>
