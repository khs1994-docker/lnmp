<?php

declare(strict_types=1);

namespace Example\Tests;

use Example\Example;
use PHPUnit\Framework\TestCase;

class ExampleTestCase extends TestCase
{
    private static $test;

    public static function getTest()
    {
        if (file_exists($envfile = __DIR__.'/../../.env.testing')) {
            $dotenv = new Dotenv(__DIR__.'/../../', '.env.testing');
            $dotenv->load();
       }

        if (!(self::$test instanceof Example)) {
            self::$test = new Example(['a' => 1]);
        }

        return self::$test;
    }
}
