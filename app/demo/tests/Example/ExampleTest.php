<?php

declare(strict_types=1);

namespace Example\Tests;

class ExampleTest extends ExampleTestCase
{
    public function example()
    {
        return $this->getTest();
    }

    public function testExample(): void
    {
        $test = $this->example()->bbb->getValue();

        $this->assertEquals(1, $test);
    }
}
