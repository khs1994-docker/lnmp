<?php

declare(strict_types=1);

namespace Example\Service;

class BBB
{
    protected $aaa;

    /**
     * 依赖注入，控制反转.
     *
     * @param AAA $aaa
     */
    public function __construct(AAA $aaa)
    {
        $this->aaa = $aaa;
    }

    public function getValue()
    {
        return $this->aaa->returnConfig();
    }
}
