<?php

namespace Modl;

use Respect\Validation\Validator;

use Movim\Picture;
use Movim\User;

class Postn extends Model
{
    public $origin;         // Where the post is comming from (jid or server)
    public $node;           // microblog or pubsub
    public $nodeid;         // the ID if the item

    public $aname;          // author name
    public $aid;            // author id
    public $aemail;         // author email

    public $title;          //
    public $content;        // The content
    public $contentraw;     // The raw content
    public $contentcleaned; // The cleanned content

    public $commentorigin;
    public $commentnodeid;

    public $parentorigin;
    public $parentnode;
    public $parentnodeid;

    public $published;
    public $updated;
    public $delay;

    public $picture;        // Tell if the post contain embeded pictures

    public $lat;
    public $lon;

    public $links = [];

    public $reply;

    public $hash;

    private $youtube;

    public $open;
    public $logo;
    private $openlink;

    public $nsfw = false;

    public $_struct = [
        'origin'        => ['type' => 'string','size' => 64,'key' => true],
        'node'          => ['type' => 'string','size' => 96,'key' => true],
        'nodeid'        => ['type' => 'string','size' => 96,'key' => true],
        'aname'         => ['type' => 'string','size' => 128],
        'aid'           => ['type' => 'string','size' => 64],
        'aemail'        => ['type' => 'string','size' => 64],
        'title'         => ['type' => 'text'],
        'content'       => ['type' => 'text'],
        'contentraw'    => ['type' => 'text'],
        'contentcleaned'=> ['type' => 'text'],
        'commentorigin' => ['type' => 'string','size' => 64],
        'commentnodeid' => ['type' => 'string','size' => 96],
        'parentorigin'  => ['type' => 'string','size' => 64],
        'parentnode'    => ['type' => 'string','size' => 96],
        'parentnodeid'  => ['type' => 'string','size' => 96],
        'open'          => ['type' => 'bool'],
        'published'     => ['type' => 'date'],
        'updated'       => ['type' => 'date'],
        'delay'         => ['type' => 'date'],
        'reply'         => ['type' => 'serialized'],
        'lat'           => ['type' => 'string','size' => 32],
        'lon'           => ['type' => 'string','size' => 32],
        'links'         => ['type' => 'serialized'],
        'picture'       => ['type' => 'text'],
        'hash'          => ['type' => 'string','size' => 128,'mandatory' => true],
        'nsfw'          => ['type' => 'bool']
    ];

    private $titleLimit = 200;

    public function __construct()
    {
        $this->hash = hash('sha256', openssl_random_pseudo_bytes(5));
    }

    private function extractContent($contents)
    {
        $content = '';

        foreach($contents as $c) {
            switch($c->attributes()->type) {
                case 'html':
                case 'xhtml':
                    $dom = new \DOMDocument('1.0', 'utf-8');
                    $import = @dom_import_simplexml($c->children());
                    if($import == null) {
                        $import = dom_import_simplexml($c);
                    }
                    $element = $dom->importNode($import, true);
                    $dom->appendChild($element);
                    return (string)$dom->saveHTML();
                    break;
                case 'text':
                    if(trim($c) != '') {
                        $this->contentraw = trim($c);
                    }
                    break;
                default :
                    $content = (string)$c;
                    break;
            }
        }

        return $content;
    }

    private function extractTitle($titles)
    {
        $title = '';
        foreach($titles as $t) {
            switch($t->attributes()->type) {
                case 'html':
                case 'xhtml':
                    $title = strip_tags((string)$t->children()->asXML());
                    break;
                case 'text':
                    if(trim($t) != '') {
                        $title = trim($t);
                    }
                    break;
                default :
                    $title = (string)$t;
                    break;
            }
        }

        return $title;
    }

    public function set($item, $from, $delay = false, $node = false)
    {
        if($item->item)
            $entry = $item->item;
        else
            $entry = $item;

        if($from != '')
            $this->origin = $from;

        if($node)
            $this->node = $node;
        else
            $this->node = (string)$item->attributes()->node;

        $this->nodeid = (string)$entry->attributes()->id;

        if($entry->entry->id)
            $this->nodeid = (string)$entry->entry->id;

        // Get some informations on the author
        if($entry->entry->author->name)
            $this->aname = (string)$entry->entry->author->name;
        if($entry->entry->author->uri)
            $this->aid = substr((string)$entry->entry->author->uri, 5);
        if($entry->entry->author->email)
            $this->aemail = (string)$entry->entry->author->email;

        // Non standard support
        if($entry->entry->source && $entry->entry->source->author->name)
            $this->aname = (string)$entry->entry->source->author->name;
        if($entry->entry->source && $entry->entry->source->author->uri)
            $this->aid = substr((string)$entry->entry->source->author->uri, 5);

        $this->title = $this->extractTitle($entry->entry->title);

        // Content
        if($entry->entry->summary && (string)$entry->entry->summary != '')
            $summary = '<p class="summary">'.(string)$entry->entry->summary.'</p>';
        else
            $summary = '';

        if($entry->entry && $entry->entry->content) {
            $content = $this->extractContent($entry->entry->content);
        } elseif($summary == '')
            $content = __('');
        else
            $content = '';

        $content = $summary.$content;

        if($entry->entry->updated)
            $this->updated = (string)$entry->entry->updated;
        else
            $this->updated = gmdate(SQL::SQL_DATE);

        if($entry->entry->published)
            $this->published = (string)$entry->entry->published;
        elseif($entry->entry->updated)
            $this->published = (string)$entry->entry->updated;
        else
            $this->published = gmdate(SQL::SQL_DATE);

        if($delay)
            $this->delay = $delay;

        // Tags parsing
        if($entry->entry->category) {
            $td = new \Modl\TagDAO;
            $td->delete($this->nodeid);

            if($entry->entry->category->count() == 1
            && isset($entry->entry->category->attributes()->term)) {
                $tag = new \Modl\Tag;
                $tag->nodeid = $this->nodeid;
                $tag->tag    = strtolower((string)$entry->entry->category->attributes()->term);
                $td->set($tag);

                if($tag->tag == 'nsfw') $this->nsfw = true;
            } else {
                foreach($entry->entry->category as $cat) {
                    $tag = new \Modl\Tag;
                    $tag->nodeid = $this->nodeid;
                    $tag->tag    = strtolower((string)$cat->attributes()->term);
                    $td->set($tag);

                    if($tag->tag == 'nsfw') $this->nsfw = true;
                }
            }
        }

        if(current(explode('.', $this->origin)) == 'nsfw') $this->nsfw = true;

        if(!isset($this->commentorigin)) {
            $this->commentorigin = $this->origin;
        }

        $this->content = trim($content);
        $this->contentcleaned = purifyHTML(html_entity_decode($this->content));

        if($entry->entry->geoloc) {
            if($entry->entry->geoloc->lat != 0)
                $this->lat = (string)$entry->entry->geoloc->lat;
            if($entry->entry->geoloc->lon != 0)
                $this->lon = (string)$entry->entry->geoloc->lon;
        }

        // We fill empty aid
        if($this->isMicroblog() && empty($this->aid)) {
            $this->aid = $this->origin;
        }

        // We check if this is a reply
        if($entry->entry->{'in-reply-to'}) {
            $href = (string)$entry->entry->{'in-reply-to'}->attributes()->href;
            $arr = explode(';', $href);
            $reply = [
                'origin' => substr($arr[0], 5, -1),
                'node'   => substr($arr[1], 5),
                'nodeid' => substr($arr[2], 5)
            ];

            $this->reply = $reply;
        }

        $extra = false;
        // We try to extract a picture
        $xml = \simplexml_load_string('<div>'.$this->contentcleaned.'</div>');
        if($xml) {
            $results = $xml->xpath('//img/@src');

            if(is_array($results) && !empty($results)) {
                $extra = (string)$results[0];

                $this->picture = protectPicture($extra);
                $this->setAttachments($entry->entry->link, $extra);
            } else {
                $results = $xml->xpath('//video/@poster');
                if(is_array($results) && !empty($results)) {
                    $extra = (string)$results[0];

                    $this->picture = $extra;
                    $this->setAttachments($entry->entry->link, $extra);
                }
            }

            $results = $xml->xpath('//a');
            if(is_array($results) && !empty($results)) {
                foreach($results as $link) {
                    $link->addAttribute('target', '_blank');
                }
            }
        }

        $this->setAttachments($entry->entry->link, $extra);

        if($this->isComment()) {
            $pd = new \Modl\PostnDAO;
            $p = $pd->getParent($this->origin, substr($this->node, 30));
            if($p) {
                $this->parentorigin = $p->origin;
                $this->parentnode   = $p->node;
                $this->parentnodeid = $p->nodeid;
            }
        }
    }

    private function setAttachments($links, $extra = false)
    {
        $l = [];

        foreach($links as $attachment) {
            $enc = [];
            $enc = (array)$attachment->attributes();
            $enc = $enc['@attributes'];
            array_push($l, $enc);

            if($this->picture == null
            && isset($enc['type'])
            && typeIsPicture($enc['type'])
            /*&& isSmallPicture($enc['href'])*/) {
                $this->picture = protectPicture($enc['href']);
            }

            if($enc['rel'] == 'alternate'
            && Validator::url()->validate($enc['href'])) $this->open = true;

            if((string)$attachment->attributes()->title == 'comments') {
                $url = parse_url(urldecode((string)$attachment->attributes()->href));

                if($url) {
                    $this->commentorigin = $url['path'];
                    $this->commentnodeid = substr($url['query'], 36);
                }
            }
        }

        if($extra) {
            array_push(
                $l,
                [
                    'rel' => 'enclosure',
                    'href' => $extra,
                    'type' => 'picture'
                ]);
        }

        if(!empty($l)) {
            $this->links = $l;
        }
    }

    public function getAttachments()
    {
        $attachments = null;
        $this->openlink = null;

        if(isset($this->links)) {
            $links = $this->links;
            $attachments = [
                'pictures' => [],
                'files' => [],
                'links' => []
            ];

            foreach($links as $l) {
                // If the href is not a valid URL we skip
                if(!Validator::url()->validate($l['href'])) continue;

                // Prepare the switch
                $rel = isset($l['rel']) ? $l['rel'] : null;
                switch($rel) {
                    case 'enclosure':
                        if(typeIsPicture($l['type'])) {
                            array_push($attachments['pictures'], $l);
                        } elseif($l['type'] != 'picture') {
                            array_push($attachments['files'], $l);
                        }
                        break;

                    case 'related':
                        if(preg_match('%(?:youtube(?:-nocookie)?\.com/(?:[^/]+/.+/|(?:v|e(?:mbed)?)/|.*[?&]v=)|youtu\.be/)([^"&?/ ]{11})%i', $l['href'], $match)) {
                            $this->youtube = $match[1];
                        }

                        array_push(
                            $attachments['links'],
                            [
                                'href' => $l['href'],
                                'url'  => parse_url($l['href']),
                                'title'=> (isset($l['title'])) ? $l['title'] : false,
                                'rel'  => 'related',
                                'description' => (isset($l['description'])) ? $l['description'] : false,
                                'logo' => (isset($l['logo'])) ? $l['logo'] : false
                            ]
                        );
                        break;

                    case 'alternate':
                    default:
                        $this->openlink = $l['href'];
                        if(!$this->isMicroblog()) {
                            array_push(
                                $attachments['links'],
                                [
                                    'href' => $l['href'],
                                    'url'  => parse_url($l['href']),
                                    'rel'  => 'alternate'
                                ]
                            );
                        }
                        break;
                }
            }
        }

        if(empty($attachments['pictures'])) unset($attachments['pictures']);
        if(empty($attachments['files']))    unset($attachments['files']);
        if(empty($attachments['links']))    unset($attachments['links']);

        return $attachments;
    }

    public function getAttachment()
    {
        $attachments = $this->getAttachments();

        if(array_key_exists('links', $attachments)) {
            foreach($attachments['links'] as $attachment) {
                if(in_array($attachment['rel'], ['enclosure', 'related'])) {
                    return $attachment;
                }
            }
        }

        unset($attachments['links']);

        foreach($attachments as $key => $group) {
            foreach($group as $attachment) {
                if(in_array($attachment['rel'], ['enclosure', 'related'])) {
                    return $attachment;
                }
            }
        }

        return false;
    }

    public function getPicture()
    {
        return $this->picture;
    }

    public function getYoutube()
    {
        return $this->youtube;
    }

    public function getPlace()
    {
        return (isset($this->lat, $this->lon) && $this->lat != '' && $this->lon != '');
    }

    public function getLogo()
    {
        $p = new Picture;
        return $p->get($this->origin.$this->node, 50);
    }

    public function getUUID()
    {
        if(substr($this->nodeid, 10) == 'urn:uuid:') {
            return $this->nodeid;
        } else {
            return 'urn:uuid:'.generateUUID($this->nodeid);
        }
    }

    public function getRef()
    {
        return 'xmpp:'.$this->origin.'?;node='.$this->node.';item='.$this->nodeid;
    }

    // Works only for the microblog posts
    public function getParent()
    {
        $pd = new PostnDAO;
        return $pd->get($this->parentorigin, $this->parentnode, $this->parentnodeid);
    }

    public function isMine($force = false)
    {
        $user = new User;

        if($force) {
            return ($this->aid == $user->getLogin());
        } else {
            return ($this->aid == $user->getLogin()
            || $this->origin == $user->getLogin());
        }
    }

    public function isPublic()
    {
        return ($this->open);
    }

    public function isMicroblog()
    {
        return ($this->node == "urn:xmpp:microblog:0");
    }

    public function isEditable()
    {
        return ($this->contentraw != null || $this->links != null);
    }

    public function isShort()
    {
        return (strlen($this->contentcleaned) < 700);
    }

    public function isBrief()
    {
        return ($this->content == '' && strlen($this->title) < $this->titleLimit);
    }

    public function isNSFW()
    {
        return $this->nsfw;
    }

    public function isReply()
    {
        return isset($this->reply);
    }

    public function isLike()
    {
        return ($this->contentraw == '♥' || $this->title == '♥');
    }

    public function isRTL()
    {
        return isRTL($this->contentraw);
    }

    public function isComment()
    {
        return (substr($this->node, 0, 30) == 'urn:xmpp:microblog:0:comments/');
    }

    public function hasCommentsNode()
    {
        return (isset($this->commentorigin)
             && isset($this->commentnodeid));
    }

    public function getSummary()
    {
        if($this->isBrief()) {
            return truncate(html_entity_decode($this->title), 140);
        } else {
            return truncate(stripTags(html_entity_decode($this->contentcleaned)), 140);
        }
    }

    public function getTitle()
    {
        return (isset($this->title)
            && strlen($this->title) >= $this->titleLimit)
            ? __('post.default_title')
            : $this->title;
    }

    public function getContent()
    {
        return (strlen($this->title) >= $this->titleLimit)
            ? nl2br(addUrls(addHashtagsLinks($this->title)))
            : $this->contentcleaned;
    }

    public function getReply()
    {
        if(!$this->reply) return;

        $reply = $this->reply;
        $pd = new \Modl\PostnDAO;
        return $pd->get($reply['origin'], $reply['node'], $reply['nodeid']);
    }

    public function getPublicUrl()
    {
        return $this->openlink;
    }

    public function getComments()
    {
        $pd = new \Modl\PostnDAO;
        $comments = $pd->getComments($this);
        return $comments ? $comments : [];
    }

    public function countComments()
    {
        $pd = new \Modl\PostnDAO;
        return $pd->countComments($this->commentorigin, $this->commentnodeid);
    }

    public function countLikes()
    {
        $pd = new \Modl\PostnDAO;
        return $pd->countLikes($this->commentorigin, $this->commentnodeid);
    }

    public function isLiked()
    {
        $pd = new \Modl\PostnDAO;
        return $pd->isLiked($this->commentorigin, $this->commentnodeid);
    }

    /*public function countReplies()
    {
        $pd = new \Modl\PostnDAO;
        return $pd->countReplies([
            'origin'    => $this->origin,
            'node'      => $this->node,
            'nodeid'    => $this->nodeid
        ]);
    }*/

    public function getTags()
    {
        $td = new \Modl\TagDAO;
        $tags = $td->getTags($this->nodeid);
        if(is_array($tags)) {
            return array_map(function($tag) { return $tag->tag; }, $tags);
        }
    }

    public function getTagsImploded()
    {
        $tags = $this->getTags();
        if(is_array($tags)) {
            return implode(', ', $tags);
        }
    }

    public function getNext()
    {
        $pd = new PostnDAO;
        return $pd->getNext($this->origin, $this->node, $this->nodeid);
    }

    public function getPrevious()
    {
        $pd = new PostnDAO;
        return $pd->getPrevious($this->origin, $this->node, $this->nodeid);
    }
}

class ContactPostn extends Postn
{
    public $jid;

    public $fn;
    public $name;

    public $privacy;

    public $phototype;
    public $photobin;

    public $nickname;

    function getContact()
    {
        $c = new Contact;
        $c->jid = $this->aid;
        $c->fn = $this->fn;
        $c->name = $this->name;
        $c->nickname = $this->nickname;
        $c->phototype = $this->phototype;
        $c->photobin = $this->photobin;

        return $c;
    }

    public function isRecycled()
    {
        return ($this->getContact()->jid
            && $this->node == 'urn:xmpp:microblog:0'
            && (strtolower($this->origin) != strtolower($this->getContact()->jid)));
    }

    public function isEditable()
    {
        return (
            ($this->contentraw != null || $this->links != null)
            && !$this->isRecycled());
    }
}
