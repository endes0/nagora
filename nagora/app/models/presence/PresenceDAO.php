<?php

namespace Modl;

class PresenceDAO extends SQL
{
    function __construct()
    {
        parent::__construct();
    }

    function set($presence)
    {
        $id = sha1(
                $presence->session.
                $presence->jid.
                $presence->resource
            );

        $this->_sql = '
            update presence
            set value       = :value,
                priority    = :priority,
                status      = :status,
                node        = :node,
                ver         = :ver,
                delay       = :delay,
                last        = :last,
                publickey   = :publickey,
                muc         = :muc,
                mucjid      = :mucjid,
                mucaffiliation = :mucaffiliation,
                mucrole     = :mucrole,
                updated     = :updated
            where id        = :id';

        $this->prepare(
            'Presence',
            [
                'value'     => $presence->value,
                'priority'  => $presence->priority,
                'status'    => $presence->status,
                'node'      => $presence->node,
                'ver'       => $presence->ver,
                'delay'     => $presence->delay,
                'last'      => $presence->last,
                'publickey' => $presence->publickey,
                'muc'       => $presence->muc,
                'mucjid'    => $presence->mucjid,
                'mucaffiliation' => $presence->mucaffiliation,
                'mucrole'   => $presence->mucrole,
                'id'        => $id,
                'updated'   => gmdate(SQL::SQL_DATE)
            ]
        );

        $this->run('Presence');

        if(!$this->_effective) {
            $this->_sql = '
                insert into presence
                (id,
                session,
                jid,
                resource,
                value,
                priority,
                status,
                node,
                ver,
                delay,
                last,
                publickey,
                muc,
                mucjid,
                mucaffiliation,
                mucrole,
                created,
                updated)
                values(
                    :id,
                    :session,
                    :jid,
                    :resource,
                    :value,
                    :priority,
                    :status,
                    :node,
                    :ver,
                    :delay,
                    :last,
                    :publickey,
                    :muc,
                    :mucjid,
                    :mucaffiliation,
                    :mucrole,
                    :created,
                    :updated)';

            $this->prepare(
                'Presence',
                [
                    'id'        => $id,
                    'session'   => $presence->session,
                    'jid'       => $presence->jid,
                    'resource'  => $presence->resource,
                    'value'     => $presence->value,
                    'priority'  => $presence->priority,
                    'status'    => $presence->status,
                    'node'      => $presence->node,
                    'ver'       => $presence->ver,
                    'delay'     => $presence->delay,
                    'last'      => $presence->last,
                    'publickey' => $presence->publickey,
                    'muc'       => $presence->muc,
                    'mucjid'    => $presence->mucjid,
                    'mucaffiliation' => $presence->mucaffiliation,
                    'mucrole'   => $presence->mucrole,
                    'created'   => gmdate(SQL::SQL_DATE),
                    'updated'   => gmdate(SQL::SQL_DATE)
                ]
            );

            $this->run('Presence');
        }
    }

    function delete(Presence $presence)
    {
        $id = sha1(
                $presence->session.
                $presence->jid.
                $presence->resource
            );

        $this->_sql = '
            delete from presence
            where id = :id';

        $this->prepare(
            'Presence',
            [
                'id' => $id
            ]
        );

        return $this->run('Presence');
    }

    function getAll()
    {
        $this->_sql = '
            select * from presence;
            ';

        $this->prepare('Presence');
        return $this->run('Presence');
    }

    function getPresence($jid, $resource)
    {
        $this->_sql = '
            select * from presence
            where
                session = :session
                and jid = :jid
                and resource = :resource';

        $this->prepare(
            'Presence',
            [
                'session' => $this->_user,
                'jid' => $jid,
                'resource' => $resource
            ]
        );

        return $this->run('Presence', 'item');
    }

    function getMyPresenceRoom($jid)
    {
        $this->_sql = '
            select * from presence
            where
                session = :session
                and jid = :jid
                and mucjid = :session';

        $this->prepare(
            'Presence',
            [
                'session' => $this->_user,
                'jid' => $jid,
            ]
        );

        return $this->run('Presence', 'item');
    }

    function getJid($jid)
    {
        $this->_sql = '
            select * from presence
            where
                session = :session
                and jid = :jid
            order by mucaffiliation desc';

        $this->prepare(
            'Presence',
            [
                'session' => $this->_user,
                'jid' => $jid
            ]
        );

        return $this->run('Presence');
    }

    function clearPresence()
    {
        $this->_sql = '
            delete from presence
            where
                session = :session';

        $this->prepare(
            'Presence',
            [
                'session' => $this->_user
            ]
        );

        return $this->run('Presence');
    }

    // TODO fix with a foreign key
    function cleanPresences()
    {
        $this->_sql = '
            delete from presence
            where session not in (
                select jid as session
                from sessionx)';

        $this->prepare();

        return $this->run('Presence');
    }

    function countJid($jid)
    {
        $this->_sql = '
            select count(*) from presence
            where session = :session
                and jid = :jid';

        $this->prepare(
            'Presence',
            [
                'session' => $this->_user,
                'jid'   => $jid
            ]
        );

        return $this->run(null, 'count');
    }

    function clearMuc($muc)
    {
        $this->_sql = '
            delete from presence
            where
                session = :session
                and jid = :jid';

        $this->prepare(
            'Presence',
            [
                'session' => $this->_user,
                'jid'     => $muc
            ]
        );

        return $this->run('Presence');
    }
}
