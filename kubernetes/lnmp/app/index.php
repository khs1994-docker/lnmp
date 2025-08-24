<?php
try{
  $pdo = new PDO('mysql:host=mysql;dbname=test','root','mytest');

  echo 'ok';
}catch(Exception $e){
  var_dump($e);
}

echo "<br/>";

$redis = new Redis();
$redis->connect('redis');
$redis->set('a','1');
if($redis->get('a') === '1'){
    echo 'ok';
}
