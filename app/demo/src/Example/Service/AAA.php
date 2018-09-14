<?php

declare(strict_types=1);

namespace Example\Service;

class AAA
{
    protected $aaa;

    public function __construct($aaa)
    {
        $this->aaa = $aaa;
    }

    public function returnConfig()
    {
        return $this->aaa;
    }
}
