<?php

use Moxl\Xec\Action\Presence\Muc;
use Moxl\Xec\Action\Bookmark\Get;
use Moxl\Xec\Action\Bookmark\Set;

use Respect\Validation\Validator;

class Chats extends \Movim\Widget\Base
{
    function load()
    {
        $this->addcss('chats.css');
        $this->addjs('chats.js');
        $this->registerEvent('invitation', 'onMessage');
        $this->registerEvent('carbons', 'onMessage');
        $this->registerEvent('message', 'onMessage');
        $this->registerEvent('presence', 'onPresence', 'chat');
        $this->registerEvent('composing', 'onComposing');
        $this->registerEvent('paused', 'onPaused');
    }

    function onMessage($packet)
    {
        $message = $packet->content;

        if($message->type != 'groupchat') {
            // If the message is from me
            if($message->session == $message->jidto) {
                $from = $message->jidfrom;
            } else {
                $from = $message->jidto;
            }

            $this->ajaxOpen($from, false);
        }
    }

    function onPresence($packet)
    {
        $contacts = $packet->content;
        if($contacts != null){
            $c = $contacts[0];
            $chats = \Movim\Cache::c('chats');
            if(is_array($chats) &&  array_key_exists($c->jid, $chats)) {
                $this->rpc('MovimTpl.replace', '#' . cleanupId($c->jid.'_chat_item'), $this->prepareChat($c->jid));
                $this->rpc('Chats.refresh');

                $n = new Notification;
                $n->ajaxGet();
            }
        }
    }

    function onComposing($array)
    {
        $this->setState($array, $this->__('chats.composing'));
    }

    function onPaused($array)
    {
        $this->setState($array, $this->__('chats.paused'));
    }

    private function setState($array, $message)
    {
        list($from, $to) = $array;
        if($from == $this->user->getLogin()) {
            $jid = $to;
        } else {
            $jid = $from;
        }

        $this->rpc('MovimTpl.replace', '#' . cleanupId($jid.'_chat_item'), $this->prepareChat($jid, $message));
        $this->rpc('Chats.refresh');
    }

    function ajaxGet()
    {
        $this->rpc('MovimTpl.fill', '#chats_widget_list', $this->prepareChats());
        $this->rpc('Chats.refresh');
    }

    /**
     * @brief Get history
     */
    function ajaxGetHistory($jid = false)
    {
        $g = new \Moxl\Xec\Action\MAM\Get;
        $md = new \Modl\MessageDAO;

        if($jid == false) {
            $message = $md->getLastItem();

            if(!empty($message)) {
                $g->setStart(strtotime($message->published)+10);
            }

            $g->setLimit(150);
            $g->request();
        } elseif($this->validateJid($jid)) {
            $messages = $md->getContact(echapJid($jid), 0, 1);

            $g->setJid(echapJid($jid));

            if(!empty($messages)) {
                // We add a little delay of 10sec to prevent some sync issues
                $g->setStart(strtotime($messages[0]->published)+10);
            }

            $g->request();
        }
    }

    function ajaxOpen($jid, $history = true)
    {
        if(!$this->validateJid($jid)) return;

        $chats = \Movim\Cache::c('chats');
        if($chats == null) $chats = [];

        unset($chats[$jid]);

        if(/*!array_key_exists($jid, $chats)
                && */$jid != $this->user->getLogin()) {
            $chats[$jid] = 1;

            if($history) $this->ajaxGetHistory($jid);

            \Movim\Cache::c('chats', $chats);
            $this->rpc('Chats.prepend', $jid, $this->prepareChat($jid));
        }
    }

    function ajaxClose($jid)
    {
        if(!$this->validateJid($jid)) return;

        $chats = \Movim\Cache::c('chats');
        unset($chats[$jid]);
        \Movim\Cache::c('chats', $chats);

        $this->rpc('MovimTpl.remove', '#' . cleanupId($jid . '_chat_item'));

        $this->rpc('Chats.refresh');
        $this->rpc('Chat.empty');
        $this->rpc('MovimTpl.hidePanel');
    }

    /**
     * @brief Display the add chat form
     */
    function ajaxAdd()
    {
        $view = $this->tpl();

        $cd = new \Modl\ContactDAO;
        $chats = \Movim\Cache::c('chats');

        if(!isset($chats)) $chats = [];

        $view->assign('chats', array_keys($chats));
        $view->assign('top', $cd->getTop(15));
        $view->assign('presencestxt', getPresencesTxt());

        Dialog::fill($view->draw('_chats_add', true), true);
    }

    /**
     * @brief Display the extended list
     */
    function ajaxAddExtend()
    {
        $view = $this->tpl();

        $cd = new \Modl\ContactDAO;
        $contacts = $cd->getRosterSimple();
        $view->assign('contacts', $contacts);

        $this->rpc('MovimTpl.fill', '#add_extend', $view->draw('_chats_add_extend', true));
    }

    function prepareChats()
    {
        $chats = \Movim\Cache::c('chats');

        $view = $this->tpl();

        if(!isset($chats)) {
            return '';
        }

        $view->assign('chats', array_reverse($chats));

        return $view->draw('_chats', true);
    }

    function prepareChat($jid, $status = null)
    {
        if(!$this->validateJid($jid)) return;

        $view = $this->tpl();

        $cd = new \Modl\ContactDAO;
        $md = new \Modl\MessageDAO;
        $cad = new \Modl\CapsDAO;

        $presencestxt = getPresencesTxt();

        $cr = $cd->getRosterItem($jid);
        if(isset($cr)) {
            if($cr->value != null) {
                $view->assign('presence', $presencestxt[$cr->value]);
            }
            $view->assign('contact', $cr);
            $view->assign('caps', $cad->get($cr->node.'#'.$cr->ver));
        } else {
            $view->assign('contact', $cd->get($jid));
            $view->assign('caps', null);
        }

        $view->assign('status', $status);

        $m = $md->getContact($jid, 0, 1);
        if(isset($m)) {
            $view->assign('message', $m[0]);
        }

        $html = $view->draw('_chats_item', true);

        unset($view);

        return $html;
    }

    private function validateJid($jid)
    {
        return (Validator::stringType()
            ->noWhitespace()
            ->length(6, 80)
            ->validate($jid));
    }
}
