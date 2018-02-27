<?php

$redis_master=new \Redis();

$redis_master->connect('redis_master','6000');

$redis_master->set('k', 1);

$redis_node=new \Redis();

$redis_node->connect('redis_node-1','6001');

echo $redis_node->get('k');
