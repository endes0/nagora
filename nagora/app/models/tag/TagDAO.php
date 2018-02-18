<?php

namespace Modl;

class TagDAO extends SQL
{
    function set($t)
    {
        $this->_sql = '
            update tag
            set nodeid = :nodeid,
                tag = :tag
            where nodeid = :nodeid
                and tag = :tag';

        $this->prepare(
            'Tag',
            [
                'nodeid' => $t->nodeid,
                'tag' => $t->tag
            ]
        );

        $this->run('Tag');

        if(!$this->_effective) {
            $this->_sql = '
                insert into tag
                (nodeid, tag)
                values (:nodeid, :tag)';

            $this->prepare(
                'Tag',
                [
                    'nodeid' => $t->nodeid,
                    'tag' => $t->tag
                ]
            );

            $this->run('Tag');
        }
    }

    function delete($nodeid)
    {
        $this->_sql = '
            delete from tag
            where nodeid = :nodeid';

        $this->prepare(
            'Tag',
            [
                'nodeid' => $nodeid
            ]
        );

        return $this->run('Tag');
    }

    function getTags($nodeid)
    {
        $this->_sql = '
            select * from tag
            where nodeid = :nodeid';

        $this->prepare(
            'Tag',
            [
                'nodeid' => $nodeid
            ]
        );

        return $this->run('Tag');
    }
}
