<?php

namespace Modl;

class CacheDAO extends SQL
{
    function set($cache)
    {
        $this->_sql = '
            update cache
                set data = :data,
                    timestamp = :timestamp
                where session = :session
                and name = :name';

        $this->prepare(
            'Cache',
            [
                'session'   => $this->_user,
                'data'      => $cache->data,
                'timestamp' => $cache->timestamp,
                'name'      => $cache->name
            ]
        );

        $this->run('Cache');

        if(!$this->_effective) {
            $this->_sql = '
                insert into cache
                (session, name, data, timestamp)
                values (:session, :name, :data, :timestamp)';

            $this->prepare(
                'Cache',
                [
                    'session'   => $this->_user,
                    'name'      => $cache->name,
                    'data'      => $cache->data,
                    'timestamp' => $cache->timestamp
                ]
            );

            return $this->run('Cache');
        }
    }

    function get($key)
    {
        $this->_sql = '
            select * from cache
            where
                session = :session
            and name    = :name';

        $this->prepare(
            'Cache',
            [
                'session' => $this->_user,
                'name' => $key
            ]
        );

        return $this->run('Cache', 'item');
    }
}
