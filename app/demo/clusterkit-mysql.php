<?php

$pdo=new PDO('mysql:host=192.168.199.100;port=13306;dbname=test','root','mytest');

$sql='create table if not exists tb1(id int);';

$sql2='insert tb1 values(1)';

var_dump($pdo->exec($sql));

var_dump($pdo->exec($sql2));

$pdo2=new PDO('mysql:host=192.168.199.100;port=13307;dbname=test','root','mytest');

$stmt=$pdo2->query('select * from tb1');

foreach ($stmt as $k=>$v){
  var_dump ($k);
  var_dump ($v);
}

// $pdo3=new PDO('mysql:host=192.168.199.100;port=13308;dbname=test','root','mytest');
//
// $stmt=$pdo3->query('select * from tb1');
//
// foreach ($stmt as $k=>$v){
//   var_dump ($k);
//   var_dump ($v);
// }

// $pdo->exec('delete from tb1 where id=1');
