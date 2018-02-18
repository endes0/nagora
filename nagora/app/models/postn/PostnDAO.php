<?php

namespace Modl;

class PostnDAO extends SQL
{
    function get($origin, $node, $nodeid, $public = false, $around = false)
    {
        $params = [
                'origin' => $origin,
                'node' => $node,
                'nodeid' => $nodeid
            ];

        $this->_sql = '
            select postn.*, contact.*, postn.aid from postn
            left outer join contact on postn.aid = contact.jid
            left outer join info
                on postn.origin = info.server
                and postn.node = info.node
            where postn.origin = :origin
                and postn.node = :node';

        if(isset($this->_user)) {
            $this->_sql .= '
                and (
                    postn.nsfw = (select nsfw from setting where session = :session)
                    or postn.nsfw = false
                    or postn.nsfw is null)';

            $params += ['setting.session' => $this->_user];
        }

        if(!$around) {
            $this->_sql .= ' and postn.nodeid = :nodeid';
        } else {
            $compare = ($around == 1) ? '>' : '<';
            $order   = ($around == 1) ? 'asc' : 'desc';
            $this->_sql .= ' and postn.nodeid = (
                    select nodeid
                    from postn
                    where published '. $compare .' (
                        select published
                        from postn
                        where postn.origin = :origin
                            and postn.node = :node
                            and postn.nodeid = :nodeid
                    )
                    and postn.origin = :origin
                    and postn.node = :node
                    and (
                        (
                            postn.origin in (
                                select jid
                                from rosterlink
                                where session = :jid
                                and rostersubscription in (\'both\', \'to\')
                            )
                            and node = \'urn:xmpp:microblog:0\'
                        )
                        or (
                            postn.origin = :jid
                            and node = \'urn:xmpp:microblog:0\'
                        )
                        or (
                            (postn.origin, node) in (
                                select server, node
                                from subscription
                                where jid = :jid)
                        )
                        or postn.open = true
                    )
                    order by published '.$order.'
                    limit 1
                )
                ';

            $params['contact.jid'] = $this->_user;
        }

        if($public) $this->_sql .= ' and postn.open = true';

        $this->prepare(
            'Postn',
            $params
        );

        return $this->run('ContactPostn', 'item');
    }

    function getNext($origin, $node, $nodeid, $public = false)
    {
        return $this->get($origin, $node, $nodeid, $public, 1);
    }

    function getPrevious($origin, $node, $nodeid, $public = false)
    {
        return $this->get($origin, $node, $nodeid, $public, 2);
    }

    function getPublicItem($origin, $node, $nodeid)
    {
        return $this->get($origin, $node, $nodeid, true);
    }

    function getIds($origin, $node, $nodeids)
    {
        $ids = (!empty($nodeids)) ? implode('\',\'', $nodeids) : '';
        $this->_sql = '
            select postn.*, contact.*, postn.aid from postn
            left outer join contact on postn.aid = contact.jid
            left outer join info
                on postn.origin = info.server
                and postn.node = info.node
            where postn.origin = :origin
                and postn.node = :node
                and postn.nodeid in (\''.$ids.'\')';
//            order by published';


        $this->prepare(
            'Postn',
            [
                'origin' => $origin,
                'node' => $node
            ]
        );

        return $this->run('ContactPostn');
    }

    function delete($nodeid)
    {
        $this->_sql = '
            delete from postn
            where nodeid = :nodeid';

        $this->prepare(
            'Postn',
            [
                'nodeid' => $nodeid
            ]
        );

        return $this->run('Postn');
    }

    function deleteNode($origin, $node)
    {
        $this->_sql = '
            delete from postn
            where origin = :origin
                and node = :node';

        $this->prepare(
            'Postn',
            [
                'origin' => $origin,
                'node' => $node
            ]
        );

        return $this->run('Postn');
    }

    function getParent($commentorigin, $commentnodeid)
    {
        $this->_sql = '
            select * from postn
            where commentorigin = :commentorigin
                and commentnodeid = :commentnodeid';

        $this->prepare(
            'Postn',
            [
                'commentorigin' => $commentorigin,
                'commentnodeid' => $commentnodeid
            ]
        );

        return $this->run('Postn', 'item');
    }

    function getNode($from, $node, $limitf = false, $limitr = false)
    {
        $this->_sql = '
            select *, postn.aid from postn
            left outer join contact on postn.aid = contact.jid
            left outer join info
                on postn.origin = info.server
                and postn.node = info.node
            where ((postn.origin, node) in (select server, node from subscription where jid = :jid))
                and postn.origin = :origin
                and postn.node = :node
                and postn.node != \'urn:xmpp:microblog:0\'
                and (
                    postn.nsfw = (select nsfw from setting where session = :jid)
                    or postn.nsfw = false
                    or postn.nsfw is null)
            order by postn.published desc';

        if($limitr !== false)
            $this->_sql = $this->_sql.' limit '.(int)$limitr.' offset '.(int)$limitf;

        $this->prepare(
            'Postn',
            [
                'subscription.jid' => $this->_user,
                'origin' => $from,
                'node' => $node
            ]
        );

        return $this->run('ContactPostn');
    }

    function getNodeUnfiltered($from, $node, $limitf = false, $limitr = false)
    {
        $this->_sql = '
            select *, postn.aid from postn
            left outer join contact on postn.aid = contact.jid
            left outer join info
                on postn.origin = info.server
                and postn.node = info.node
            where postn.origin = :origin
                and postn.node = :node
            order by postn.published desc';

        if($limitr !== false) {
            $this->_sql = $this->_sql.' limit '.(int)$limitr.' offset '.(int)$limitf;
        }

        $this->prepare(
            'Postn',
            [
                'origin' => $from,
                'node' => $node
            ]
        );

        return $this->run('ContactPostn');
    }

    function getPublicTag($tag, $limitf = false, $limitr = false)
    {
        $params = ['tag.tag' => $tag];

        $this->_sql = '
            select *, postn.aid from postn
            left outer join contact on postn.aid = contact.jid
            where nodeid in (select nodeid from tag where tag = :tag)
                and postn.open = true';

        if(isset($this->_user)) {
            $this->_sql .= '
                    and (
                        postn.nsfw = (select nsfw from setting where session = :session)
                        or postn.nsfw = false
                        or postn.nsfw is null)';

            $params += ['setting.session' => $this->_user];
        }

        $this->_sql .= '
            order by postn.published desc';

        if($limitr !== false) {
            $this->_sql .= ' limit '.(int)$limitr.' offset '.(int)$limitf;
        }

        $this->prepare(
            'Postn',
            $params
        );

        return $this->run('ContactPostn');
    }

    function getGroupPicture($origin, $node)
    {
        $this->_sql = '
            select * from postn
            where postn.origin = :origin
                and postn.node = :node
                and postn.picture is not null
                and postn.open = true
            order by postn.published desc
            limit 1';

        $this->prepare(
            'Postn',
            [
                'origin' => $origin,
                'node' => $node
            ]
        );

        return $this->run('Postn', 'item');
    }

    function getAllPosts($jid = false, $limitf = false, $limitr = false)
    {
        $this->_sql = '
            select *, postn.aid from postn
            left outer join info
                on postn.origin = info.server
                and postn.node = info.node
            left outer join contact on postn.aid = contact.jid
            where (
                (postn.origin in (select jid from rosterlink where session = :origin and rostersubscription in (\'both\', \'to\')) and postn.node = \'urn:xmpp:microblog:0\')
                or (postn.origin = :origin and postn.node = \'urn:xmpp:microblog:0\')
                or ((postn.origin, postn.node) in (select server, node from subscription where jid = :origin))
                )
                and postn.node not like \'urn:xmpp:microblog:0:comments/%\'
                and postn.node not like \'urn:xmpp:inbox\'
            order by postn.published desc
            ';

        if($limitr)
            $this->_sql = $this->_sql.' limit '.$limitr.' offset '.$limitf;

        if($jid == false)
            $jid = $this->_user;

        $this->prepare(
            'Postn',
            [
                'origin' => $jid
            ]
        );

        return $this->run('ContactPostn');
    }

    function getFeed($limitf = false, $limitr = false)
    {
        $this->_sql = '
            select *, postn.aid from postn
            left outer join contact on postn.aid = contact.jid
            where ((postn.origin in (select jid from rosterlink where session = :origin and rostersubscription in (\'both\', \'to\')) and node = \'urn:xmpp:microblog:0\')
                or (postn.origin = :origin and node = \'urn:xmpp:microblog:0\'))
                and postn.node not like \'urn:xmpp:microblog:0:comments/%\'
                and postn.node not like \'urn:xmpp:inbox\'
            order by postn.published desc
            ';

        if($limitr)
            $this->_sql = $this->_sql.' limit '.$limitr.' offset '.$limitf;

        $this->prepare(
            'Postn',
            [
                'origin' => $this->_user
            ]
        );

        return $this->run('ContactPostn');
    }

    function getNews($limitf = false, $limitr = false)
    {
        $this->_sql = '
            select *, postn.aid from postn
            left outer join contact on postn.aid = contact.jid
            left outer join info
                on postn.origin = info.server
                and postn.node = info.node
            where ((postn.origin, postn.node) in (select server, node from subscription where jid = :origin))
                and (
                    postn.nsfw = (select nsfw from setting where session = :origin)
                    or postn.nsfw = false
                    or postn.nsfw is null)
            order by postn.published desc
            ';

        if($limitr)
            $this->_sql = $this->_sql.' limit '.$limitr.' offset '.$limitf;

        $this->prepare(
            'Postn',
            [
                'origin' => $this->_user
            ]
        );

        return $this->run('ContactPostn');
    }


    function getMe($limitf = false, $limitr = false)
    {
        $this->_sql = '
            select *, postn.aid from postn
            left outer join contact on postn.aid = contact.jid

            where postn.origin = :origin and postn.node = \'urn:xmpp:microblog:0\'
                and (
                    postn.nsfw = (select nsfw from setting where session = :origin)
                    or postn.nsfw = false
                    or postn.nsfw is null)
            order by postn.published desc
            ';

        if($limitr)
            $this->_sql = $this->_sql.' limit '.$limitr.' offset '.$limitf;

        $this->prepare(
            'Postn',
            [
                'origin' => $this->_user
            ]
        );

        return $this->run('ContactPostn');
    }

    function getPublic($origin, $node, $limitf = false, $limitr = false)
    {
        $params = [
            'origin' => $origin,
            'node' => $node
        ];

        $this->_sql = '
            select *, postn.aid from postn
            left outer join contact on postn.aid = contact.jid
            where postn.origin = :origin
                and postn.node = :node
                and postn.open = true';

        if(isset($this->_user)) {
            $this->_sql .= '
                    and (
                        postn.nsfw = (select nsfw from setting where session = :session)
                        or postn.nsfw = false
                        or postn.nsfw is null)';

            $params += ['setting.session' => $this->_user];
        }

        $this->_sql .= '
            order by postn.published desc';

        if($limitr !== false)
            $this->_sql = $this->_sql.' limit '.(int)$limitr.' offset '.(int)$limitf;

        $this->prepare('Postn', $params);

        return $this->run('ContactPostn');
    }

    // TODO: fixme
    function getComments($posts)
    {
        $commentsid = '';
        if(is_array($posts)) {
            $i = 0;
            foreach($posts as $post) {
                if($i == 0)
                    $commentsid = "'urn:xmpp:microblog:0:comments/".$post->nodeid."'";
                else
                    $commentsid .= ",'urn:xmpp:microblog:0:comments/".$post->nodeid."'";
                $i++;
            }
        } else {
            $commentsid = "'urn:xmpp:microblog:0:comments/".$posts->nodeid."'";
        }

        // We request all the comments relative to our messages
        $this->_sql = '
            select *, postn.aid as jid from postn
            left outer join contact on postn.aid = contact.jid
            where postn.node in ('.$commentsid.')
            order by postn.published';

        $this->prepare(
            'Postn',
            []
        );

        return $this->run('ContactPostn');
    }

    function countReplies($reply)
    {
        $this->_sql = '
            select count(*) from postn
            where reply = :reply
                ';

        $this->prepare(
            'Postn',
            [
                'reply' => $reply
            ]
        );

        return $this->run(null, 'count');
    }

    function countComments($origin, $id)
    {
        $this->_sql = '
            select count(*) from postn
            where origin = :origin
                and node = :node
                and (title != :contentraw
                or contentraw != :contentraw)
                ';

        $this->prepare(
            'Postn',
            [
                'origin' => $origin,
                'node'   => 'urn:xmpp:microblog:0:comments/'.$id,
                'contentraw' => '♥'
            ]
        );

        return $this->run(null, 'count');
    }

    function isLiked($origin, $id)
    {
        $this->_sql = '
            select count(*) from postn
            where origin = :origin
                and node = :node
                and aid = :aid
                and (contentraw = :contentraw
                or title = :contentraw)';

        $this->prepare(
            'Postn',
            [
                'origin' => $origin,
                'node'   => 'urn:xmpp:microblog:0:comments/'.$id,
                'aid'    => $this->_user,
                'contentraw' => '♥'
            ]
        );

        return ($this->run(null, 'count') > 0);
    }

    function countLikes($origin, $id)
    {
        $this->_sql = '
            select count(*) from postn
            where origin = :origin
                and node = :node
                and (contentraw = :contentraw
                or title = :contentraw)';

        $this->prepare(
            'Postn',
            [
                'origin' => $origin,
                'node'   => 'urn:xmpp:microblog:0:comments/'.$id,
                'contentraw' => '♥'
            ]
        );

        return $this->run(null, 'count');
    }

    function clearPost()
    {
        $this->_sql = '
            delete from postn
            where session = :session';

        $this->prepare(
            'Postn',
            [
                'session' => $this->_user
            ]
        );

        return $this->run('Postn');
    }

    function getCountSince($date)
    {
        $this->_sql = '
            select count(*) from postn
            where (
                (postn.origin in (select jid from rosterlink where session = :origin and rostersubscription in (\'both\', \'to\')) and node = \'urn:xmpp:microblog:0\')
                or (postn.origin = :origin and node = \'urn:xmpp:microblog:0\')
                or ((postn.origin, node) in (select server, node from subscription where jid = :origin))
                )
                and postn.node not like \'urn:xmpp:microblog:0:comments/%\'
                and postn.node not like \'urn:xmpp:inbox\'
                and published > :published
                and (
                    postn.nsfw = (select nsfw from setting where session = :origin)
                    or postn.nsfw = false
                    or postn.nsfw is null)
                ';

        $this->prepare(
            'Postn',
            [
                'origin' => $this->_user,
                'published' => $date
            ]
        );

        return $this->run(null, 'count');
    }

    function getNotifsSince($date, $limitf = false, $limitr = false)
    {
        $this->_sql = '
            select * from postn
            left outer join contact on postn.aid = contact.jid
            where (parentorigin, parentnode, parentnodeid) in (
                select origin, node, nodeid from postn where aid = :aid)
            and published > :published
            order by published desc
                ';

        if($limitr) {
            $this->_sql = $this->_sql.' limit '.$limitr.' offset '.$limitf;
        }

        $this->prepare(
            'Postn',
            [
                'aid' => $this->_user,
                'published' => $date
            ]
        );

        return $this->run('ContactPostn');
    }

    function getLastDate()
    {
        $this->_sql = '
            select published from postn
            where (
                (postn.origin in (select jid from rosterlink where session = :origin and rostersubscription in (\'both\', \'to\')) and node = \'urn:xmpp:microblog:0\')
                or (postn.origin = :origin and node = \'urn:xmpp:microblog:0\')
                or ((postn.origin, node) in (select server, node from subscription where jid = :origin))
                )
                and postn.node not like \'urn:xmpp:microblog:0:comments/%\'
                and postn.node not like \'urn:xmpp:inbox\'
                and (
                    postn.nsfw = (select nsfw from setting where session = :origin)
                    or postn.nsfw = false
                    or postn.nsfw is null)
            order by postn.published desc
            limit 1 offset 0';

        $this->prepare(
            'Postn',
            [
                'origin' => $this->_user
            ]
        );

        $arr = $this->run(null, 'array');
        if(is_array($arr) && isset($arr[0]))
            return $arr[0]['published'];
    }

    function getLastPublished($origin = false, $limitf = false, $limitr = false, $host = false)
    {
        switch($this->_dbtype) {
            case 'mysql':
                $this->_sql = '
                    select * from (
                        select postn.* from postn
                        left outer join info on postn.origin = info.server
                            and postn.node = info.node
                        where
                            postn.node != \'urn:xmpp:microblog:0\'
                            and postn.node not like \'urn:xmpp:microblog:0:comments/%\'
                            and postn.node not like \'urn:xmpp:inbox\'
                            and aid is not null
                            and postn.open = true';
            break;
            case 'pgsql':
                $this->_sql = '
                    select * from (
                        select distinct on (origin, postn.node) * from postn
                        left outer join info on postn.origin = info.server
                            and postn.node = info.node
                        where
                            postn.node != \'urn:xmpp:microblog:0\'
                            and postn.node not like \'urn:xmpp:microblog:0:comments/%\'
                            and postn.node not like \'urn:xmpp:inbox\'
                            and aid is not null
                            and postn.open = true';
            break;
        }

        $params = [];

        if($this->_user) {
            $this->_sql .= '
                and (
                    postn.nsfw = (select nsfw from setting where session = :session)
                    or postn.nsfw = false
                    or postn.nsfw is null)';

            $params += ['setting.session' => $this->_user];
        }

        if($host) {
            $this->_sql .= ' and postn.origin like \'%.' . $host . '\'';
        }

        if($origin) {
            $this->_sql .= '
                and origin = :origin
            ';

            $params += ['origin' => $origin];
        }

        switch($this->_dbtype) {
            case 'mysql':
                $this->_sql .= '
                        order by published desc
                    ) p
                    group by origin, node';
            break;
            case 'pgsql':
                $this->_sql .= '
                        order by origin, postn.node, published desc
                    ) p
                    order by published desc';
            break;
        }

        if($limitr) {
            $this->_sql .= ' limit '.$limitr.' offset '.$limitf;
        }

        $this->prepare('Postn', $params);

        return $this->run('Postn');
    }

    function getLastBlogPublic($limitf = false, $limitr = false, $host = false)
    {
        switch($this->_dbtype) {
            case 'mysql':
                $this->_sql = '
                    select * from postn
                    left outer join contact on postn.aid = contact.jid
                    where
                        node = \'urn:xmpp:microblog:0\'
                        and postn.open = true';

                if($host) {
                    $this->_sql .= ' and postn.origin like \'%@' . $host . '\'';
                }

                $this->_sql .= '
                    group by origin
                    order by published desc
                    ';
            break;
            case 'pgsql':
                $this->_sql = '
                    select * from (
                        select distinct on (origin) * from postn
                        left outer join contact on postn.aid = contact.jid
                        where
                            node = \'urn:xmpp:microblog:0\'
                            and postn.open = true';

                if($host) {
                    $this->_sql .= ' and postn.origin = \'' . $host . '\'';
                }

                $this->_sql .= '
                            order by origin, published desc
                    ) p
                    order by published desc
                    ';
            break;
        }

        if($limitr)
            $this->_sql = $this->_sql.' limit '.$limitr.' offset '.$limitf;

        $this->prepare('Postn');

        return $this->run('ContactPostn');
    }

    function search($key)
    {
        $this->_sql = '
            select *, postn.aid from postn
            left outer join contact on postn.aid = contact.jid
            where (
                (postn.origin in (select jid from rosterlink where session = :origin and rostersubscription in (\'both\', \'to\')) and node = \'urn:xmpp:microblog:0\')
                or (postn.origin = :origin and node = \'urn:xmpp:microblog:0\')
                or ((postn.origin, node) in (select server, node from subscription where jid = :origin))
                )
                and postn.node not like \'urn:xmpp:microblog:0:comments/%\'
                and postn.node not like \'urn:xmpp:inbox\'
                and upper(title) like upper(:title)
            order by postn.published desc
            limit 6 offset 0
            ';

        $this->prepare(
            'Postn',
            [
                'origin' => $this->_user,
                'title'  => '%'.$key.'%'
            ]
        );

        return $this->run('ContactPostn');
    }

    function exists($origin, $node, $id)
    {
        $this->_sql = '
            select count(*) from postn
            where origin = :origin
            and node = :node
            and nodeid = :nodeid
            ';

        $this->prepare(
            'Postn',
            [
                'origin'    => $origin,
                'node'      => $node,
                'nodeid'    => $id
            ]
        );

        $arr = $this->run(null, 'array');
        if(is_array($arr) && isset($arr[0])) {
            $arr = array_values($arr[0]);
            return (bool)$arr[0];
        }
    }
}
