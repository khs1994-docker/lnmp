<?php

declare(strict_types=1);

namespace Example;

use Exception;
use Pimple\Container;

/**
 * 核心方法 注入类（依赖），之后通过调用属性或方法，获取类.
 *
 * $container->register();
 *
 * $container['a'] = new A();
 *
 * $a = $container['a'];
 *
 * @property string bbb
 *     method getValue()
 */
class Example extends Container
{
    /**
     * 服务提供器数组.
     */
    protected $providers = [
        Providers\BBBProvider::class,
    ];

    /**
     * 注册服务提供器.
     */
    private function registerProviders(): void
    {
        // 取得服务提供器数组.
        $array = array_merge($this->providers, $this['config']->get('providers', []));
        foreach ($array as $k) {
            $this->register(new $k());
        }
    }

    public function __construct(array $config = [])
    {
        parent::__construct();

        // 在容器中注入类
        $this['config'] = new Support\Config($config);

        // 注册一个服务提供者
        $this->register(new Providers\BBBProvider());

        // 注册服务提供器
        $this->registerProviders();
    }

    /**
     * 通过调用属性，获取对象
     *
     * @param $name
     * @param $arguments
     *
     * @throws Exception
     *
     * @return mixed
     */
    public function __get($name)
    {
        // $example->调用不存在属性时
        if (isset($this[$name])) {
            return $this[$name];
        }

        throw new Exception('Not found');
    }

    /**
     * 通过调用方法，获取对象
     */
    public function bbb()
    {
        return $this['bbb'];
    }
}
