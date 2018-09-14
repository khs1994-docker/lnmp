<?php

declare(strict_types=1);

namespace Example\Providers;

use Example\Service\AAA;
use Example\Service\BBB;
use Pimple\Container;
use Pimple\ServiceProviderInterface;

class BBBProvider implements ServiceProviderInterface
{
    public function register(Container $pimple): void
    {
        // AAA
        $pimple['bbb.aaa'] = function ($app) {
            return new AAA($app['config']->get('a'));
        };

        // BBB 依赖 AAA，将 AAA 注入 BBB
        $pimple['bbb'] = function ($app) {
            return new BBB($app['bbb.aaa']);
        };
    }
}
