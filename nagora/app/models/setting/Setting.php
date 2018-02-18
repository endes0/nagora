<?php

namespace Modl;

class Setting extends Model
{
    public $language;
    public $cssurl;
    public $nsfw      = false;
    public $nightmode = false;

    public $_struct = [
        'session'   => ['type' => 'string','size' => 96,'key' => true],
        'language'  => ['type' => 'string','size' => 6],
        'cssurl'    => ['type' => 'string','size' => 128],
        'nightmode' => ['type' => 'bool'],
        'nsfw'      => ['type' => 'bool']
    ];
}
