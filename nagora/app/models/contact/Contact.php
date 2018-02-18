<?php

namespace Modl;

use Respect\Validation\Validator;

use Movim\Picture;
use Movim\User;

class Contact extends Model
{
    public $jid;

    public $fn;
    public $name;
    public $date;
    public $url;

    public $email;

    public $adrlocality;
    public $adrpostalcode;
    public $adrcountry;

    public $photobin;

    public $description;

    public $protected;
    public $privacy;

    // User Mood (contain serialized array) - XEP 0107
    public $mood;

    // User Activity (contain serialized array) - XEP 0108
    public $activity;

    // User Nickname - XEP 0172
    public $nickname;

    // User Tune - XEP 0118
    public $tuneartist;
    public $tunelenght;
    public $tunerating;
    public $tunesource;
    public $tunetitle;
    public $tunetrack;

    // User Location
    public $loclatitude;
    public $loclongitude;
    public $localtitude;
    public $loccountry;
    public $loccountrycode;
    public $locregion;
    public $locpostalcode;
    public $loclocality;
    public $locstreet;
    public $locbuilding;
    public $loctext;
    public $locuri;
    public $loctimestamp;

    public $avatarhash;

    // Datetime
    public $created;
    public $updated;

    public $_struct =
    [
        'jid' =>            ['type' => 'string','size' => 64,'key' => true],
        'fn' =>             ['type' => 'string','size' => 64],
        'name' =>           ['type' => 'string','size' => 64],
        'date' =>           ['type' => 'date','size' => 11],
        'url' =>            ['type' => 'string','size' => 128],
        'email' =>          ['type' => 'string','size' => 128],
        'adrlocality' =>    ['type' => 'string','size' => 128],
        'adrpostalcode' =>  ['type' => 'string','size' => 12],
        'adrcountry' =>     ['type' => 'string','size' => 64],
        'description' =>    ['type' => 'text'],
        'mood' =>           ['type' => 'serialized','size' => 64],
        'activity' =>       ['type' => 'string','size' => 128],
        'nickname' =>       ['type' => 'string','size' => 64],
        'tuneartist' =>     ['type' => 'string','size' => 128],
        'tunelenght' =>     ['type' => 'int','size' => 11],
        'tunerating' =>     ['type' => 'int','size' => 11],
        'tunesource' =>     ['type' => 'string','size' => 128],
        'tunetitle' =>      ['type' => 'string','size' => 128],
        'tunetrack' =>      ['type' => 'string','size' => 128],
        'loclatitude' =>    ['type' => 'string','size' => 32],
        'loclongitude' =>   ['type' => 'string','size' => 32],
        'localtitude' =>    ['type' => 'int','size' => 11],
        'loccountry' =>     ['type' => 'string','size' => 128],
        'loccountrycode' => ['type' => 'string','size' => 2],
        'locregion' =>      ['type' => 'string','size' => 128],
        'locpostalcode' =>  ['type' => 'string','size' => 32],
        'loclocality' =>    ['type' => 'string','size' => 128],
        'locstreet' =>      ['type' => 'string','size' => 128],
        'locbuilding' =>    ['type' => 'string','size' => 32],
        'loctext' =>        ['type' => 'text'],
        'locuri' =>         ['type' => 'string','size' => 128],
        'loctimestamp' =>   ['type' => 'date','size' => 11],
        'avatarhash' =>     ['type' => 'string','size' => 128],
        'created' =>        ['type' => 'date','mandatory' => true],
        'updated' =>        ['type' => 'date','mandatory' => true],
    ];

    public function set($vcard, $jid)
    {
        $this->jid = \echapJid($jid);

        $validate_date = Validator::date('Y-m-d');
        if(isset($vcard->vCard->BDAY)
        && $validate_date->validate($vcard->vCard->BDAY)) {
            $this->date = (string)$vcard->vCard->BDAY;
        }

        $this->name = (string)$vcard->vCard->NICKNAME;
        $this->fn = (string)$vcard->vCard->FN;
        $this->url = (string)$vcard->vCard->URL;

        $this->email = (string)$vcard->vCard->EMAIL->USERID;

        $this->adrlocality = (string)$vcard->vCard->ADR->LOCALITY;
        $this->adrpostalcode = (string)$vcard->vCard->ADR->PCODE;
        $this->adrcountry = (string)$vcard->vCard->ADR->CTRY;

        if(filter_var((string)$vcard->vCard->PHOTO, FILTER_VALIDATE_URL)) {
            $this->photobin = base64_encode(
                requestUrl((string)$vcard->vCard->PHOTO, 1));
        } else {
            $this->photobin = (string)$vcard->vCard->PHOTO->BINVAL;
        }

        $this->description = (string)$vcard->vCard->DESC;
    }

    public function createThumbnails()
    {
        $p = new Picture;
        $p->fromBase($this->photobin);
        $p->set($this->jid);
    }

    public function getPhoto($size = 'l')
    {
        $sizes = [
            'wall'  => [1920, 1080],
            'xxl'   => [1280, 300],
            'xl'    => [512 , false],
            'l'     => [210 , false],
            'm'     => [120 , false],
            's'     => [50  , false],
            'xs'    => [28  , false],
            'xxs'   => [24  , false]
        ];


        $p = new Picture;
        return $p->get($this->jid, $sizes[$size][0], $sizes[$size][1]);
    }

    public function setLocation($stanza)
    {
        $this->loclatitude      = (string)$stanza->items->item->geoloc->lat;
        $this->loclongitude     = (string)$stanza->items->item->geoloc->lon;
        $this->localtitude      = (int)$stanza->items->item->geoloc->alt;
        $this->loccountry       = (string)$stanza->items->item->geoloc->country;
        $this->loccountrycode   = (string)$stanza->items->item->geoloc->countrycode;
        $this->locregion        = (string)$stanza->items->item->geoloc->region;
        $this->locpostalcode    = (string)$stanza->items->item->geoloc->postalcode;
        $this->loclocality      = (string)$stanza->items->item->geoloc->locality;
        $this->locstreet        = (string)$stanza->items->item->geoloc->street;
        $this->locbuilding      = (string)$stanza->items->item->geoloc->building;
        $this->loctext          = (string)$stanza->items->item->geoloc->text;
        $this->locuri           = (string)$stanza->items->item->geoloc->uri;
        $this->loctimestamp = date(
                            'Y-m-d H:i:s',
                            strtotime((string)$stanza->items->item->geoloc->timestamp));
    }

    public function setTune($stanza)
    {
        $this->tuneartist = (string)$stanza->items->item->tune->artist;
        $this->tunelenght = (int)$stanza->items->item->tune->lenght;
        $this->tunerating = (int)$stanza->items->item->tune->rating;
        $this->tunesource = (string)$stanza->items->item->tune->source;
        $this->tunetitle = (string)$stanza->items->item->tune->title;
        $this->tunetrack = (string)$stanza->items->item->tune->track;
    }

    public function setVcard4($vcard)
    {
        $validate_date = Validator::date('Y-m-d');
        if(isset($vcard->bday->date)
        && $validate_date->validate($vcard->bday->date)) {
            $this->date = (string)$vcard->bday->date;
        }

        $this->name = (string)$vcard->nickname->text;
        $this->fn = (string)$vcard->fn->text;
        $this->url = (string)$vcard->url->uri;

        if(isset($vcard->gender))
            $this->gender  = (string)$vcard->gender->sex->text;
        if(isset($vcard->marital))
            $this->marital = (string)$vcard->marital->status->text;

        $this->adrlocality = (string)$vcard->adr->locality;
        $this->adrcountry = (string)$vcard->adr->country;
        $this->adrpostalcode = (string)$vcard->adr->code;

        $this->email = (string)$vcard->email->text;
        $this->description = trim((string)$vcard->note->text);
    }

    public function getPlace()
    {
        $place = null;

        if($this->loctext != '')
            $place .= $this->loctext.' ';
        else {
            if($this->locbuilding != '')
                $place .= $this->locbuilding.' ';
            if($this->locstreet != '')
                $place .= $this->locstreet.'<br />';
            if($this->locpostalcode != '')
                $place .= $this->locpostalcode.' ';
            if($this->loclocality != '')
                $place .= $this->loclocality.'<br />';
            if($this->locregion != '')
                $place .= $this->locregion.' - ';
            if($this->loccountry != '')
                $place .= $this->loccountry;
        }

        return $place;
    }

    public function getTrueName()
    {
        $truename = '';

        if(isset($this->rostername))
            $rostername = str_replace('\40', '', $this->rostername);
        else
            $rostername = '';

        if(
            isset($this->rostername)
            && $rostername != ''
            && !filter_var($rostername, FILTER_VALIDATE_EMAIL)
          )
            $truename = $rostername;
        elseif(
            isset($this->fn)
            && $this->fn != ''
            && !filter_var($this->fn, FILTER_VALIDATE_EMAIL)
          )
            $truename = $this->fn;
        elseif(
            isset($this->nickname)
            && $this->nickname != ''
            && !filter_var($this->nickname, FILTER_VALIDATE_EMAIL)
          )
            $truename = $this->nickname;
        elseif(
            isset($this->name)
            && $this->name != ''
            && !filter_var($this->name, FILTER_VALIDATE_EMAIL)
          )
            $truename = $this->name;
        else {
            $truename = explodeJid($this->jid);
            $truename = $truename['username'];
        }

        return $truename;
    }

    function getAge()
    {
        if($this->isValidDate()) {
            $age = intval(substr(date('Ymd') - date('Ymd', strtotime($this->date)), 0, -4));
            if($age != 0)
                return $age;
        }
    }

    public function getDate()
    {
        if($this->date == null) return null;

        $dt = new \DateTime($this->date);
        return $dt->format('d-m-Y');
    }

    function getAlbum()
    {
        $uri = str_replace(
            ' ',
            '%20',
            'http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=80c1aa3abfa9e3d06f404a2e781e38f9&artist='.
                $this->tuneartist.
                '&album='.
                $this->tunesource.
                '&format=json'
            );

        $json = json_decode(requestURL($uri, 2));

        if(isset($json->album)) {
            $json->album->url = $json->album->image[2]->{'#text'};
            return $json->album;
        }
    }

    function countSubscribers()
    {
        $cd = new \Modl\ContactDAO;
        return $cd->countSubscribers($this->jid);
    }

    public function getSearchTerms()
    {
        return cleanupId($this->jid).'-'.
            cleanupId($this->getTrueName()).'-'.
            cleanupId($this->groupname);
    }

    function toRoster()
    {
        return [
            'jid'        => $this->jid,
            'rostername' => $this->rostername,
            'rostername' => $this->rostername,
            'groupname'  => $this->groupname,
            'status'     => $this->status,
            'resource'   => $this->resource,
            'value'      => $this->value
            ];
    }

    function isEmpty()
    {
        $this->isValidDate();

        return ($this->fn == null
            && $this->name == null
            && $this->date == null
            && $this->url == null
            && $this->email == null
            && $this->description == null);
    }

    function isValidDate()
    {
        if(isset($this->date)
            && $this->date != '0000-00-00T00:00:00+0000'
            && $this->date != '1970-01-01 00:00:00'
            && $this->date != '1970-01-01 01:00:00'
            && $this->date != '1970-01-01T00:00:00+0000') {
            return true;
        }
        $this->date = null;
        return false;
    }

    function isOld()
    {
        return (strtotime($this->updated) < mktime( // We update the 1 day old vcards
                                    gmdate("H"),
                                    gmdate("i")-10,
                                    gmdate("s"),
                                    gmdate("m"),
                                    gmdate("d"),
                                    gmdate("Y")
                                )
        );
    }

    function isMe()
    {
        $user = new User;
        return ($this->jid == $user->getLogin());
    }
}

class PresenceContact extends Contact
{
    // General presence informations
    public $resource;
    public $value;
    public $priority;
    public $status;

    // Client Informations
    public $node;
    public $ver;

    // Delay - XEP 0203
    public $delay;

    // Last Activity - XEP 0256
    public $last;

    // Current Jabber OpenPGP Usage - XEP-0027
    public $publickey;
    public $muc;
    public $mucjid;
    public $mucaffiliation;
    public $mucrole;

    public $_struct = [
        'resource'  => ['type' => 'string', 'size' => 64, 'key' => true ],
        'value'     => ['type' => 'int','size' => 11, 'mandatory' => true ],
        'priority'  => ['type' => 'int','size' => 11 ],
        'status'    => ['type' => 'text'],
        'node'      => ['type' => 'string', 'size' => 128 ],
        'ver'       => ['type' => 'string', 'size' => 128 ],
        'delay'     => ['type' => 'date'],
        'last'      => ['type' => 'int','size' => 11 ],
        'publickey'  => ['type' => 'text'],
        'muc'       => ['type' => 'int','size' => 1 ],
        'mucjid'    => ['type' => 'string', 'size' => 64 ],
        'mucaffiliation'  => ['type' => 'string', 'size' => 32 ],
        'mucrole'   => ['type' => 'string', 'size' => 32 ]
    ];
}

class RosterContact extends Contact
{
    public $rostername;
    public $groupname;
    public $status;
    public $resource;
    public $value;
    public $delay;
    public $last;
    public $publickey;
    public $muc;
    public $rosterask;
    public $rostersubscription;
    public $node;
    public $ver;
    public $category;

    public $_struct = [
        'rostername'    => ['type' => 'string', 'size' => 128 ],
        'rosterask'     => ['type' => 'string', 'size' => 128 ],
        'rostersubscription'=> ['type' => 'string', 'size' => 8 ],
        'groupname'     => ['type' => 'string', 'size' => 128 ],
        'resource'      => ['type' => 'string', 'size' => 128, 'key' => true ],
        'value'         => ['type' => 'int','size' => 11, 'mandatory' => true ],
        'status'        => ['type' => 'text'],
        'node'          => ['type' => 'string', 'size' => 128 ],
        'ver'           => ['type' => 'string', 'size' => 128 ],
        'delay'         => ['type' => 'date'],
        'last'          => ['type' => 'int','size' => 11 ],
        'publickey'     => ['type' => 'text'],
        'muc'           => ['type' => 'int','size' => 1 ],
        'mucaffiliation'=> ['type' => 'string', 'size' => 32 ],
        'mucrole'       => ['type' => 'string', 'size' => 32 ]
    ];

    // This method is only use on the connection
    public function setPresence($p)
    {
        $this->resource         = $p->resource;
        $this->value            = $p->value;
        $this->status           = $p->status;
        $this->delay            = $p->delay;
        $this->last             = $p->last;
        $this->publickey        = $p->publickey;
        $this->muc              = $p->muc;
        $this->mucaffiliation   = $p->mucaffiliation;
        $this->mucrole          = $p->mucrole;
    }

    public function getFullResource()
    {
        return $this->jid.'/'.$this->resource;
    }

    public function getCaps()
    {
        if(!empty($this->node)
        && !empty($this->ver)) {
            $node = $this->node.'#'.$this->ver;

            $cad = new \Modl\CapsDAO;
            return $cad->get($node);
        }
    }
}
