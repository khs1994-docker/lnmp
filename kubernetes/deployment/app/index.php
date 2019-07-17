<?php
$pdo = new PDO('mysql:host=mysql;dbname=test','root','mytest');

var_dump($pdo);

echo "<br/>";

$redis = new Redis();
$redis->connect('redis');
$redis->set('a','1');
var_dump($redis->get('a'));
