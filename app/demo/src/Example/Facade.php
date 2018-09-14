<?php

declare(strict_types=1);

namespace Example;

class Facade extends \Illuminate\Support\Facades\Facade
{
    protected static function getFacadeAccessor()
    {
        return Example::class;
    }
}
