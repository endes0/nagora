<?php

namespace Modl;

class MessageDAO extends SQL
{
    function set($message)
    {
        if(empty($message->newid)) {
            $message->newid = $message->id;
        }

        $this->_sql = '
            update message
                set id              = :thread,
                    body            = :body,
                    html            = :html,
                    published       = :published,
                    delivered       = :delivered,
                    displayed       = :displayed,
                    markable        = :markable,
                    edited          = :edited,
                    picture         = :picture,
                    quoted          = :quoted,
                    file            = :file

                where session       = :session
                    and id          = :id
                    and jidto       = :jidto
                    and jidfrom     = :jidfrom';

        $this->prepare(
            'Message',
            [
                'thread'    => $message->newid, // FIXME
                'id'        => $message->id,
                'session'   => $message->session,
                'jidto'     => $message->jidto,
                'edited'    => $message->edited,
                'picture'   => $message->picture,
                'quoted'    => $message->quoted,
                'file'      => $message->file,
                'jidfrom'   => $message->jidfrom,
                'body'      => $message->body,
                'html'      => $message->html,
                'published' => $message->published,
                'delivered' => $message->delivered,
                'displayed' => $message->displayed,
                'markable'  => $message->markable
            ]
        );

        $this->run('Message');

        if(!$this->_effective) {
            $this->_sql = '
                insert into message
                (
                id,
                session,
                jidto,
                jidfrom,
                resource,
                type,
                subject,
                thread,
                body,
                html,
                file,
                published,
                delivered,
                displayed,
                markable,
                sticker,
                picture,
                quoted)
                values(
                    :id,
                    :session,
                    :jidto,
                    :jidfrom,
                    :resource,
                    :type,
                    :subject,
                    :thread,
                    :body,
                    :html,
                    :file,
                    :published,
                    :delivered,
                    :displayed,
                    :markable,
                    :sticker,
                    :picture,
                    :quoted
                    )';

            $this->prepare(
                'Message',
                [
                    'id'        => $message->id,
                    'session'   => $message->session,
                    'jidto'     => $message->jidto,
                    'jidfrom'   => $message->jidfrom,
                    'resource'  => $message->resource,
                    'type'      => $message->type,
                    'subject'   => $message->subject,
                    'thread'    => $message->thread,
                    'body'      => $message->body,
                    'html'      => $message->html,
                    'file'      => $message->file,
                    'published' => $message->published,
                    'delivered' => $message->delivered,
                    'displayed' => $message->displayed,
                    'markable'  => $message->markable,
                    'sticker'   => $message->sticker,
                    'picture'   => $message->picture,
                    'quoted'    => $message->quoted
                ]
            );
        }

        return $this->run('Message');
    }

    function getId($id)
    {
        $this->_sql = '
            select * from message
            where session = :session
                and id = :id
            limit 1';

        $this->prepare(
            'Message',
            [
                'session' => $this->_user,
                'id' => $id
            ]
        );

        return $this->run('Message', 'item');
    }

    function getLastItem($to = false)
    {
        $params = ['session' => $this->_user];

        $this->_sql = '
            select * from message
            where session = :session';

        if($to !== false) {
            $this->_sql .= '
                and jidto = :jidto
                and jidfrom = :jidfrom';

            $params += [
                'jidto'   => $to,
                'jidfrom' => $this->_user
            ];
        }

        $this->_sql .= '
            order by published desc
            limit 1';

        $this->prepare('Message', $params);

        return $this->run('Message', 'item');
    }

    function getLastReceivedItem($from)
    {
        $this->_sql = '
            select * from message
            where session = :session
            and jidfrom = :jidfrom
            and subject is null
            order by published desc
            limit 1';

        $this->prepare(
            'Message',
            [
                'session' => $this->_user,
                'jidfrom' => $from
            ]
        );

        return $this->run('Message', 'item');
    }

    function getAll($limitf = false, $limitr = false)
    {
        $this->_sql = '
            select * from message
            where session = :session
            order by published desc';

        if($limitr)
            $this->_sql = $this->_sql.' limit '.$limitr.' offset '.$limitf;

        $this->prepare(
            'Message',
            [
                'session' => $this->_user
            ]
        );

        return $this->run('Message');
    }

    function getContact($jid, $limitf = false, $limitr = false)
    {
        $this->_sql = '
            select * from message
            where session = :session
                and (jidfrom = :jidfrom
                or jidto = :jidto)
                and (type = \'chat\'
                or type = \'headline\'
                or type = \'invitation\')
            order by published desc';

        if($limitr)
            $this->_sql = $this->_sql.' limit '.$limitr.' offset '.$limitf;

        $this->prepare(
            'Message',
             [
                'session' => $this->_user,
                'jidfrom' => $jid,
                'jidto' => $jid
            ]
        );

        return $this->run('Message');
    }

    function getRoom($jid, $limitf = false, $limitr = false)
    {
        $this->_sql = '
            select * from message
            where session = :session
                and (jidfrom = :jidfrom
                or jidto = :jidto)
                and type = \'groupchat\'
                and body is not null
            order by published desc';

        if($limitr)
            $this->_sql = $this->_sql.' limit '.$limitr.' offset '.$limitf;

        $this->prepare(
            'Message',
            [
                'session' => $this->_user,
                'jidfrom' => $jid,
                'jidto' => $jid
            ]
        );

        return $this->run('Message');
    }

    function deleteContact($jid) {
        $this->_sql = '
            delete from message
            where session = :session
                and (jidfrom = :jidfrom
                or jidto   = :jidto)';

        $this->prepare(
            'Message',
            [
                'jidfrom'   => $jid,
                'jidto'     => $jid,
                'session' => $this->_user
            ]
        );

        return $this->run('Message');
    }

    function getHistory($jid, $date, $limit = 30)
    {
        $this->_sql = '
            select * from message
            where session = :session
                and (jidfrom = :jidfrom
                or jidto = :jidto)
                and published < :published
            order by published desc';

        $this->_sql .= ' limit '.(string)$limit;

        $this->prepare(
            'Message',
            [
                'session' => $this->_user,
                'jidfrom' => $jid,
                'jidto' => $jid,
                'published' => date(SQL::SQL_DATE, strtotime($date))
            ]
        );

        return $this->run('Message');
    }

    function getRoomSubject($room)
    {
        $this->_sql = '
            select * from message
            where jidfrom = :jidfrom
              and subject != \'\'
              order by published desc
              limit 1';

        $this->prepare(
            'Message',
            [
                'jidfrom'   => $room
            ]
        );

        return $this->run('Message', 'item');
    }

    function clearMessage()
    {
        $this->_sql = '
            delete from message
            where session = :session';

        $this->prepare(
            'Message',
            [
                'session' => $this->_user
            ]
        );

        return $this->run('Message');
    }
}
