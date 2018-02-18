<?php

use Respect\Validation\Validator;
use Movim\User;

include_once WIDGETS_PATH.'Post/Post.php';

class Blog extends \Movim\Widget\Base
{
    public $_paging = 8;

    private $_from;
    private $_node;
    private $_item;
    private $_id;
    private $_contact;
    private $_messages = [];
    private $_page;
    private $_mode;
    private $_tag;

    function load()
    {
        $this->links = [];

        if($this->_view == 'node') {
            $this->_from = $this->get('s');
            $this->_node = $this->get('n');

            if(!$this->validateServerNode($this->_from, $this->_node)) return;

            $pd = new \Modl\InfoDAO;
            $this->_item = $pd->get($this->_from, $this->_node);
            $this->_mode = 'group';

            $this->url = $this->route('node', [$this->_from, $this->_node]);

            $this->links[] = [
                'rel' => 'alternate',
                'type' => 'application/atom+xml',
                'href' => $this->route('feed', [$this->_from, $this->_node])
            ];

            if(!$this->get('i')) {
                $this->links[] = [
                    'rel' => 'alternate',
                    'type' => 'application/atom+xml',
                    'href' => 'xmpp:' . rawurlencode($this->_from) . '?;node=' . rawurlencode($this->_node)
                ];
            }
        } elseif($this->_view == 'tag' && $this->validateTag($this->get('t'))) {
            $this->_mode = 'tag';
            $this->_tag = strtolower($this->get('t'));
            $this->title = '#'.$this->_tag;
        } else {
            $this->_from = $this->get('f');

            $cd = new \Modl\ContactDAO;
            $this->_contact = $cd->get($this->_from, true);

            if(filter_var($this->_from, FILTER_VALIDATE_EMAIL)) {
                $this->_node = 'urn:xmpp:microblog:0';
            } else {
                return;
            }

            $this->_mode = 'blog';

            $this->url = $this->route('blog', $this->_from);

            $this->links[] = [
                'rel' => 'alternate',
                'type' => 'application/atom+xml',
                'href' => $this->route('feed', [$this->_from])
            ];

            if(!$this->get('i')) {
                $this->links[] = [
                    'rel' => 'alternate',
                    'type' => 'application/atom+xml',
                    'href' => 'xmpp:' . rawurlencode($this->_from) . '?;node=' . rawurlencode($this->_node)
                ];
            }
        }

        $pd = new \Modl\PostnDAO;

        if($this->_id = $this->get('i')) {
            if(Validator::stringType()->between('1', '100')->validate($this->_id)) {
                if(isset($this->_tag)) {
                    $this->_messages = $pd->getPublicTag($this->_tag, $this->_id * $this->_paging, $this->_paging + 1);
                } else {
                    $this->_messages = $pd->getNodeUnfiltered($this->_from, $this->_node, $this->_id * $this->_paging, $this->_paging + 1);
                }
                $this->_page = $this->_id + 1;
            } elseif(Validator::stringType()->length(5, 100)->validate($this->_id)) {
                $this->_messages[0] = $pd->getPublicItem($this->_from, $this->_node, $this->_id);

                if(is_object($this->_messages[0])) {
                    $this->title = $this->_messages[0]->title;

                    $description = stripTags($this->_messages[0]->contentcleaned);
                    if(!empty($description)) {
                        $this->description = truncate($description, 100);
                    }

                    $attachments = $this->_messages[0]->getAttachments();
                    if($attachments && array_key_exists('pictures', $attachments)) {
                        $this->image = urldecode($attachments['pictures'][0]['href']);
                    }
                }

                if($this->_view == 'node') {
                    $this->url = $this->route('node', [$this->_from, $this->_node, $this->_id]);
                } else {
                    $this->url = $this->route('blog', [$this->_from, $this->_id]);
                }

                $this->links[] = [
                    'rel' => 'alternate',
                    'type' => 'application/atom+xml',
                    'href' => 'xmpp:'
                        . rawurlencode($this->_from)
                        . '?;node='
                        . rawurlencode($this->_node)
                        . ';item='
                        . rawurlencode($this->_id)
                ];
            }
        } else {
            $this->_page = 1;
            if(isset($this->_tag)) {
                $this->_messages = $pd->getPublicTag($this->_tag, 0, $this->_paging + 1);
            } else {
                $this->_messages = $pd->getNodeUnfiltered($this->_from, $this->_node, 0, $this->_paging + 1);
            }
        }

        if(count($this->_messages) == $this->_paging + 1) {
            array_pop($this->_messages);
        } else {
            $this->_page = null;
        }

        if($this->_node == 'urn:xmpp:microblog:0') {
            $this->user = new User($this->_from);

            $cssurl = $this->user->getDumpedConfig('cssurl');
            if(isset($cssurl)
            && $cssurl != ''
            && Validator::url()->validate($cssurl)) {
                $this->addrawcss($cssurl);
            }
        }
    }

    public function preparePost($p)
    {
        $pw = new Post;
        return $pw->preparePost($p, true, true);
    }

    public function prepareCard($p)
    {
        $pw = new Post;
        return $pw->preparePost($p, true, ($this->_view != 'tag'), true);
    }

    function display()
    {
        $this->view->assign('server', $this->_from);
        $this->view->assign('node', $this->_node);

        $this->view->assign('item', $this->_item);
        $this->view->assign('contact', $this->_contact);
        $this->view->assign('mode', $this->_mode);
        $this->view->assign('more', $this->_page);
        $this->view->assign('posts', $this->_messages);

        $this->view->assign('tag', $this->_tag);
    }

    private function validateServerNode($server, $node)
    {
        $validate_server = Validator::stringType()->noWhitespace()->length(6, 40);
        $validate_node = Validator::stringType()->length(3, 100);

        if(!$validate_server->validate($server)
        || !$validate_node->validate($node)
        ) return false;
        else return true;
    }

    private function validateTag($tag)
    {
        return Validator::stringType()->notEmpty()->noWhitespace()->validate($tag);
    }

    function getComments($post)
    {
        $pd = new \Modl\PostnDAO;
        return $pd->getComments($post);
    }
}
