package app.helpers;

import movim.Route;

class StringHelper {
/*public function addUrls(string, preview:Bool=false) : Void
{
    // Add missing links
    return preg_replace_callback("/<a[^>]*>[^<]*<\/a|\".*?\"|((?i)\b((?:[a-z][\w-]+:(?:\/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'\".,<>?«»“”‘’])))/", public function (match) use (preview) {
            if (isset(match[1])) {
                content = match[1];

                lastTag = false;
                if (in_array(content.substr(-3, 3), ['<', '>'])) {
                    lastTag = content.substr(-3, 3);
                    content = content.substr(0, -3);
                }

                if (preview) {
                    try {
                        embed = Embed\Embed.create(match[0]);
                        if(embed.type == 'photo'
                        && embed.images[0]['width'] <= 1024
                        && embed.images[0]['height'] <= 1024) {
                            content = '<img src="'+match[0]+'"/>';
                        } elseif(embed.type == 'link') {
                            content += ' - '+ embed.title + ' - ' + embed.providerName;
                        }
                    } catch(Exception e) {
                        error_log(e.getMessage());
                    }
                }

                if (content.substr(0, 5) == 'xmpp:') {
                    link = content.replace(['xmpp://', 'xmpp:'], '');

                    if (link.substr(-5, 5) == '?join') {
                        return stripslashes(
                            '<a href=\"'+
                            Route.urlize('chat', [link.replace('?join', ''), 'room'])+
                            '\">'+
                            content+
                            '</a>'
                        );
                    }
                    return stripslashes(
                        '<a href=\"'+
                        Route.urlize('contact', link)+
                        '\">'+
                        content+
                        '</a>'
                    );
                }

                if (in_array(parse_url(content, PHP_URL_SCHEME), ['http', 'https'])) {
                    return stripslashes('<a href=\"'+content+'\" target=\"_blank\" rel=\"noopener\">'+content+'</a>')+
                            (lastTag !== false ? lastTag : '');
                }

                return content;
            }
            return match[0];

        }, string
    );

}

public function addHashtagsLinks(string) : Void
{
    return preg_replace_callback("/([\n\r\s>]|^)#(\w+)/u", public function(match) {
        return
            match[1]+
            '<a class="innertag" href="'+\Movim\Route.urlize('tag', match[2])+'">'+
            '#'+match[2]+
            '</a>';
    }, string);
}

public function addHFR(string) : Void
{
    // HFR EasterEgg
    return preg_replace_callback(
            '/\[:([\w\s-]+)([:\d])*\]/', public function (match) {
                num = '';
                if(match.length == 3)
                    num = match[2]+'/';
                return '<img class="hfr" title="'+match[0]+'" alt="'+match[0]+'" src="http://forum-images.hardware.fr/images/perso/'+num+match[1]+'.gif"/>';
            }, string
    );
}*/

/**
 * @desc Prepare the string (add the a to the links and show the smileys)
 * @param boolean display large emojis
 * @param check the links and convert them to pictures (heavy)
 */
/*public function prepareString(string:String, preview:Bool=false) : String
{
    string = addUrls(string, preview);

    // We add some smileys...
    return ((string)requestURL('http://localhost:1560/emojis/', 2, ['string' => string])).trim();
}*/

/**
 * @desc Return the tags in a string
 */
/*public function getHashtags(string:String) : NativeArray
{
    hashtags = false;
    preg_match_all("/(#\w+)/u", string, matches);
    if (matches) {
        hashtagsArray = array_count_values(matches[0]);
        hashtags = array_map(public function(tag) {
            return tag.substr(1);
        } ,hashtagsArray.keys());
    }

    return hashtags;
}*/

/*
 * Echap the JID
 */
/*public function echapJid(jid) : Void
{
    return jid.replace(' ', '\40');
}*/

/*
 * Echap the anti-slashs for Javascript
 */
/*public function echapJS(string) : Void
{
    return string.replace(["\\", "'"], ["\\\\", "\\'"]);
}*/

/*
 * Clean the resource of a jid
 */
/*public function cleanJid(jid) : Void
{
    explode = jid.split('/');
    return reset(explode);
}*/

/*
 * Extract the CID
 */
/*public function getCid(string) : Void
{
    preg_match("/(\w+)\@/", string, matches);
    if(is_array(matches)) {
        return matches[1];
    }
}*/

/*
 *  Explode JID
 */
public static function explodeJid(jid : String) : {username: String, server: String, resource: String} {
    var arr = jid.split('/');
    var jid = arr[0];
    var resource : String = null;

    if(arr[1] != null) resource = arr[1];

    var server = '';

    var arr = jid.split('@');
    var username = arr[0];
    if(arr[1] != null) server = arr[1];

    return {
        username : username,
        server   : server,
        resource: resource
    };
}

/**
 * Return a human readable filesize
 * @param string size in bytes
 */
/*public function sizeToCleanSize(size:String, precision=2) : String
{
    units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    power = size > 0 ? floor(log(size, 1024)) : 0;
    return number_format(size / Math.pow(1024, power), precision, '.', ',') + ' ' + units[power];
}*/

/**
 * Return a colored string in the console
 */
/*public function colorize(string, color) : String
{
    colors = [
        'black'     => 30,
        'red'       => 31,
        'green'     => 32,
        'yellow'    => 33,
        'blue'      => 34,
        'purple'    => 35,
        'turquoise' => 36,
        'white'     => 37
    ];

    return "\033["+colors[color]+"m"+string+"\033[0m";
}*/

/**
 * Check if the mimetype is a picture
 */
/*public function typeIsPicture(type) : Bool
{
    return in_array(type, ['image/jpeg', 'image/png', 'image/jpg', 'image/gif']);
}*/

/**
 * Check if the mimetype is an audio file
 */
/*public function typeIsAudio(type) : Bool
{
    return in_array(type, [
        'audio/aac', 'audio/ogg', 'video/ogg', 'audio/opus',
        'audio/vorbis', 'audio/speex', 'audio/mpeg']
    );
}*/

/**
 * Return a color generated from the string
 */
/*public function stringToColor(string) : String
{
    colors = [
        0 => 'red',
        1 => 'purple',
        2 => 'indigo',
        3 => 'blue',
        4 => 'green',
        5 => 'orange',
        6 => 'yellow',
        7 => 'brown',
        8 => 'lime',
        9 => 'cyan',
        10 => 'teal',
        11 => 'pink',
        12 => 'dorange',
        13 => 'lblue',
        14 => 'amber',
        15 => 'bgray',
    ];

    s = Math.abs(crc32(string));
    return colors[s%16];
}*/

/**
 * Strip tags and add a whitespace
 */
/*public function stripTags(string) : String
{
    return StringTools.stripTags(preg_replace('/(<\/[^>]+?>)(<[^>\/][^>]*?>)/', '$1 $2', string));
}*/

/**
 * Purify a string
 */
/*public function purifyHTML(string) : String
{
    return (string)requestURL('http://localhost:1560/purify/', 2, ['html' => urlencode(string)]);
}*/

/**
 * Check if a string is RTL
 */
/*public function isRTL(string) : String
{
    return preg_match('/\p{Arabic}|\p{Hebrew}/u', string);
}*/

/**
 * Invert a number
 */
/*public function invertSign(num) : num
{
    return (num <= 0) ? Math.abs(num) : -num ;
}*/

/**
 * Return the first two letters of a string
 */
/*public function firstLetterCapitalize(string, firstOnly:Bool=false) : String
{
    size = (firstOnly) ? 1 : 2;
    return ucfirst((mb_substr(string, 0, size)).toLowerCase());
}*/

/** Return a clean string that can be used for HTML ids
 */
/*public function cleanupId(string) : String
{
    return "id-" + (preg_replace('/([^a-z0-9]+)/i', '-', string)).toLowerCase();
}*/

/**
 * Truncates the given string at the specified length.
 * @param str The input string.
 * @param width The number of chars at which the string will be truncated.
 */
/*public function truncate(str:String, width:Int) : String
{
    return strtok(wordwrap(str, width, "…\n"), "\n");
}*/

/**
 * Return the URI of a path with a timestamp
 */
/*public function urilize(path:String, notime:Bool=false) : String
{
    if(notime) {
        return BASE_URI + path;
    }
    return BASE_URI + path + '?t='+sys.FileSystem.stat(DOCUMENT_ROOT + '/'+path).mtime.getTime();
}*/
}
