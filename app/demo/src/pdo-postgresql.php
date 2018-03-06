<?php
$dsn="pgsql:host=postgresql;port=5432;dbname=test;user=postgres;password=mytest";
$pdo = new PDO($dsn);
$sql=<<<EOF
CREATE TABLE tb1 (
  id SMALLINT PRIMARY KEY ,
  name VARCHAR(20) UNIQUE
);
EOF;
$res = $pdo->exec($sql);
$error_info=$pdo->errorInfo();
print_r($error_info);
