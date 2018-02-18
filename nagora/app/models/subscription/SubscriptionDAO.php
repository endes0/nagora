<?php

namespace Modl;

class SubscriptionDAO extends SQL
{
    function set($s)
    {
        $this->_sql = '
            update subscription
            set subscription = :subscription,
                timestamp = :timestamp,
                tags = :tags,
                subid = :subid
            where jid = :jid
                and server = :server
                and node = :node';

        $this->prepare(
            'Subscription',
            [
                'subscription' => $s->subscription,
                'timestamp' => date(SQL::SQL_DATE),
                'jid'   => $s->jid,
                'server'=> $s->server,
                'node'  => $s->node,
                'tags'  => $s->tags,
                'subid' => $s->subid
            ]
        );

        $this->run('Subscription');

        if(!$this->_effective) {
            $this->_sql = '
                insert into subscription
                (jid, server, node, subscription, subid, tags, timestamp)
                values (:jid, :server, :node, :subscription, :subid, :tags, :timestamp)';

            $this->prepare(
                'Subscription',
                [
                    'subscription' => $s->subscription,
                    'timestamp' => date(SQL::SQL_DATE),
                    'jid'   => $s->jid,
                    'server'=> $s->server,
                    'node'  => $s->node,
                    'tags'  => $s->tags,
                    'subid' => $s->subid
                ]
            );

            $this->run('Subscription');
        }
    }

    function get($server, $node)
    {
        $this->_sql = '
            select * from subscription
            where jid = :jid
                and server = :server
                and node = :node';

        $this->prepare(
            'Subscription',
            [
                'jid' => $this->_user,
                'server' => $server,
                'node' => $node
            ]
        );

        return $this->run('Subscription');
    }

    function getAll($server, $node)
    {
        $this->_sql = '
            select * from subscription
            where server = :server
                and node = :node
            order by jid';

        $this->prepare(
            'Subscription',
            [
                'server' => $server,
                'node' => $node
            ]
        );

        return $this->run('Subscription');
    }

    function getSubscribed()
    {
        $this->_sql = '
            select
                subscription.jid,
                subscription.server,
                subscription.node,
                subscription,
                info.name,
                info.description,
                caps.name as servicename
            from subscription
            left outer join info
                on info.server = subscription.server
                and info.node = subscription.node
            left outer join caps
                on caps.node = subscription.server
            where subscription.jid = :jid
            and subscription.node not like \'urn:xmpp:microblog:0:comments/%\'
            group by
                subscription.server,
                subscription.node,
                subscription.jid,
                subscription,
                caps.name,
                info.name,
                info.description
            order by
                subscription.server';

        $this->prepare(
            'Subscription',
            [
                'jid' => $this->_user
            ]
        );

        return $this->run('Subscription');
    }

    function delete()
    {
        $this->_sql = '
            delete from subscription
            where jid = :jid';

        $this->prepare(
            'Subscription',
            [
                'jid' => $this->_user
            ]
        );

        return $this->run('Subscription');
    }

    function deleteNode($server, $node)
    {
        $this->_sql = '
            delete from subscription
            where jid = :jid
                and server = :server
                and node = :node';

        $this->prepare(
            'Subscription',
            [
                'jid' => $this->_user,
                'server' => $server,
                'node' => $node
            ]
        );

        return $this->run('Subscription');
    }

    function deleteNodeSubid($server, $node, $subid)
    {
        $this->_sql = '
            delete from subscription
            where jid = :jid
                and server = :server
                and node = :node
                and subid = :subid';

        $this->prepare(
            'Subscription',
            [
                'jid' => $this->_user,
                'server' => $server,
                'node' => $node,
                'subid' => $subid,
            ]
        );

        return $this->run('Subscription');
    }
}
