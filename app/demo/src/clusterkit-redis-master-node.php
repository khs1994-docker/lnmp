<?php

const REDIS_MASTER_NODE_HOST = "192.168.199.100";

$redis_master=new \Redis();

$redis_master->connect(REDIS_MASTER_NODE_HOST, '6000');

$redis_master->set('k', 1);

$redis_node=new \Redis();

$redis_node->connect(REDIS_MASTER_NODE_HOST, '6001');

echo $redis_node->get('k');
