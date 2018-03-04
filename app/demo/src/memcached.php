<?php
$m=new Memcached();
$m->addServer('memcached',11211);
var_dump($m->getversion());
