<?php

# 提前新建数据库 test

$pdo=new PDO('mysql:host=mysql;dbname=test;port=3306','root','mytest');
$sql=<<<EOF
CREATE TABLE tb1 (
  id SMALLINT AUTO_INCREMENT PRIMARY KEY ,
  name VARCHAR(20) UNIQUE
);
EOF;
$res = $pdo->exec($sql);
$error_info=$pdo->errorInfo();
echo "创建数据表受影响记录条数：" . $res . "\n<br>";
echo "错误信息:<br>";
print_r($error_info);

# 增

# 删

# 改

# 查
