<?php
try{
  $pdo = new PDO('mysql:host=mysql;dbname=test','root','mytest');

  var_dump($pdo);
}catch(Exception $e){
  var_dump($e);
}

echo "<br/>";

$redis = new Redis();
$redis->connect('redis');
$redis->set('a','1');
var_dump($redis->get('a'));
