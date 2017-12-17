<?php
$redis= new \Redis();
$redis->connect('redis');
$redis->hSet('hash', 'key1', 'value1');
$array=$redis->hGetall('hash');
var_dump($array['key1']);
