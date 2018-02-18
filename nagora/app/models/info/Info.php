<?php

namespace Modl;

use Movim\Picture;

class Info extends Model
{
    public $server;
    public $node;
    public $category;
    public $type;
    public $name;
    public $description;
    public $occupants;
    public $created;
    public $updated;

    public $num;
    public $logo = false;
    public $subscription;

    public $mucpublic = false;
    public $mucpersistent = false;
    public $mucpasswordprotected = false;
    public $mucmembersonly = false;
    public $mucmoderated = false;

    public $abuseaddresses = [];
    public $adminaddresses = [];
    public $feedbackaddresses = [];
    public $salesaddresses = [];
    public $securityaddresses = [];
    public $supportaddresses = [];

    public $_struct = [
        'server'    => ['type' => 'string','size' => 64,'key' => true],
        'node'      => ['type' => 'string','size' => 96,'key' => true],

        'category'  => ['type' => 'string','size' => 16, 'mandatory' => true],
        'type'      => ['type' => 'string','size' => 16],
        'name'      => ['type' => 'string','size' => 128],

        'description' => ['type' => 'text'],

        'occupants' => ['type' => 'int'],

        'created'   => ['type' => 'date'],
        'updated'   => ['type' => 'date', 'mandatory' => true],

        'mucpublic'             => ['type' => 'bool'],
        'mucpersistent'         => ['type' => 'bool'],
        'mucpasswordprotected'  => ['type' => 'bool'],
        'mucmembersonly'        => ['type' => 'bool'],
        'mucmoderated'          => ['type' => 'bool'],

        // XEP-0157: Contact Addresses for XMPP Services
        'abuseaddresses'       => ['type' => 'serialized','size' => 512],
        'adminaddresses'       => ['type' => 'serialized','size' => 512],
        'feedbackaddresses'    => ['type' => 'serialized','size' => 512],
        'salesaddresses'       => ['type' => 'serialized','size' => 512],
        'securityaddresses'    => ['type' => 'serialized','size' => 512],
        'supportaddresses'     => ['type' => 'serialized','size' => 512],
    ];

    public function set($query)
    {
        $from = (string)$query->attributes()->from;

        if(strpos($from, '/') == false
        && isset($query->query)) {
            $this->server   = $from;
            $this->node     = (string)$query->query->attributes()->node;

            foreach($query->query->identity as $i) {
                if($i->attributes()) {
                    $this->category = (string)$i->attributes()->category;
                    $this->type     = (string)$i->attributes()->type;

                    if($i->attributes()->name) {
                        $this->name = (string)$i->attributes()->name;
                    } else {
                        $this->name = $this->node;
                    }
                }
            }

            foreach($query->query->feature as $feature) {
                $key = (string)$feature->attributes()->var;

                switch ($key) {
                    case 'muc_public':
                        $this->mucpublic = true;
                        break;
                    case 'muc_persistent':
                        $this->mucpersistent = true;
                        break;
                    case 'muc_passwordprotected':
                        $this->mucpasswordprotected = true;
                        break;
                    case 'muc_membersonly':
                        $this->mucpasswordprotected = true;
                        break;
                    case 'muc_moderated':
                        $this->mucmoderated = true;
                        break;
                }
            }

            if(isset($query->query->x)) {
                foreach($query->query->x->field as $field) {
                    $key = (string)$field->attributes()->var;
                    switch ($key) {
                        case 'pubsub#title':
                            $this->name = (string)$field->value;
                            break;
                        case 'pubsub#creation_date':
                            $this->created = date(SQL::SQL_DATE, strtotime((string)$field->value));
                            break;
                        case 'muc#roominfo_description':
                        case 'pubsub#description':
                            $this->description = (string)$field->value;
                            break;
                        case 'pubsub#num_subscribers':
                        case 'muc#roominfo_occupants':
                            $this->occupants = (int)$field->value;
                            break;

                        case 'abuse-addresses':
                            foreach($field->children() as $value) {
                                $this->abuseaddresses[] = (string)$value;
                            }
                            break;
                        case 'admin-addresses':
                            foreach($field->children() as $value) {
                                $this->adminaddresses[] = (string)$value;
                            }
                            break;
                        case 'feedback-addresses':
                            foreach($field->children() as $value) {
                                $this->feedbackaddresses[] = (string)$value;
                            }
                            break;
                        case 'sales-addresses':
                            foreach($field->children() as $value) {
                                $this->salesaddresses[] = (string)$value;
                            }
                            break;
                        case 'security-addresses':
                            foreach($field->children() as $value) {
                                $this->securityaddresses[] = (string)$value;
                            }
                            break;
                        case 'support-addresses':
                            foreach($field->children() as $value) {
                                $this->supportaddresses[] = (string)$value;
                            }
                            break;
                    }
                }
            }
        }

        $this->updated  = date(SQL::SQL_DATE);
    }

    public function setItem($item)
    {
        $this->server = (string)$item->attributes()->jid;
        $this->node   = (string)$item->attributes()->node;
        $this->name   = (string)$item->attributes()->name;
        $this->updated  = date(SQL::SQL_DATE);
    }
}

class Server extends Info
{
    public $server;
    public $number;
    public $name;
    public $published;
}
