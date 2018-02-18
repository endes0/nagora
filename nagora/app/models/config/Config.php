<?php

namespace Modl;

class Config extends Model
{
    public $description;
    public $theme;
    public $locale;
    public $loglevel;
    public $timezone;
    public $info;
    public $unregister;
    public $username;
    public $password;

    public $restrictsuggestions;

    public $xmppdomain;
    public $xmppdescription;
    public $xmppcountry;
    public $xmppwhitelist;

    public $_struct = [
        'description'           => ['type' => 'text'],
        'theme'                 => ['type' => 'string','size' => 32,'mandatory' => true],
        'locale'                => ['type' => 'string','size' => 8,'mandatory' => true],
        'loglevel'              => ['type' => 'string','size' => 16,'mandatory' => true],
        'timezone'              => ['type' => 'string','size' => 32,'mandatory' => true],
        'info'                  => ['type' => 'text'],
        'unregister'            => ['type' => 'bool'],
        'restrictsuggestions'   => ['type' => 'bool'],
        'username'              => ['type' => 'string','size' => 32,'mandatory' => true],
        'password'              => ['type' => 'string','size' => 256,'mandatory' => true],
        'xmppdomain'            => ['type' => 'string','size' => 32],
        'xmppdescription'       => ['type' => 'text'],
        'xmppcountry'           => ['type' => 'string','size' => 4],
        'xmppwhitelist'         => ['type' => 'text']
    ];

    public function __construct()
    {
        $this->description          = 'Description';//__('global.description');
        $this->theme                = 'material';
        $this->locale               = 'en';
        $this->loglevel             = 0;
        $this->timezone             = 'Etc/GMT';
        $this->restrictsuggestions  = false;
        $this->xmppwhitelist        = '';
        $this->info                 = '';
        $this->unregister           = false;
        $this->username             = '';
        $this->password             = '';
    }
}
