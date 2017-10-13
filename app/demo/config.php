<?php

// from https://github.com/php-amqplib/php-amqplib demo

require_once __DIR__ . '/vendor/autoload.php';

define('HOST', 'rabbitmq');
define('PORT', 5672);
define('USER', 'guest');
define('PASS', 'guest');
define('VHOST', '/');

//If this is enabled you can see AMQP output on the CLI
define('AMQP_DEBUG', true);
