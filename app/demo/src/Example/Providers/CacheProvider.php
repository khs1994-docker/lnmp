<?php

declare(strict_types=1);

namespace Example\Providers;

use Doctrine\Common\Cache\FilesystemCache;
use Pimple\Container;
use Pimple\ServiceProviderInterface;

class CacheProvider implements ServiceProviderInterface
{
    public function register(Container $pimple): void
    {
        $pimple['cache'] = function () {
            return new FilesystemCache(sys_get_temp_dir());
        };
    }
}
