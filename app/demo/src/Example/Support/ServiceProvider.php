<?php

declare(strict_types=1);

namespace Example\Support;

use Example\Example;

class ServiceProvider extends \Illuminate\Support\ServiceProvider
{
    /**
     * 是否延时加载提供器。
     *
     * @var bool
     */
    protected $defer = true;

    public function connection($app)
    {
        return new Example($app);
    }

    /**
     * 在容器中注册绑定。
     */
    public function register(): void
    {
        $configPath = __DIR__.'/../../../config/config-file.php';
        $this->mergeConfigFrom($configPath, 'config-file');
        // $this->loadRoutesFrom(__DIR__.'/routes.php');
        // $this->loadMigrationsFrom(__DIR__.'/path/to/migrations');
        // $this->loadTranslationsFrom(__DIR__.'/path/to/translations', 'courier');
        $this->app->singleton('example', function ($app) {
            return $this->connection($app);
        });

        $this->app->alias('example', Example::class);
        //        $this->app->bind('example', function () {
        //            return new Example();
        //        });
    }

    /**
     * 在注册后进行服务的启动。
     */
    public function boot(): void
    {
        $configPath = __DIR__.'/../../../config/config-file.php';
        $this->publishes([$configPath => $this->getConfigPath()], 'config');
        // $this->loadTranslationsFrom(__DIR__.'/path/to/translations', 'courier');
        // $this->publishes([
        //   __DIR__.'/path/to/translations' => resource_path('lang/vendor/courier'),
        // ]);
        // $this->loadViewsFrom(__DIR__.'/path/to/views', 'courier');
        // $this->publishes([
        //    __DIR__.'/path/to/views' => resource_path('views/vendor/courier'),
        // ]);
        // if ($this->app->runningInConsole()) {
        //    $this->commands([
        //        Console\ExampleCommand::class,
        //    ]);
        // }
        // $this->publishes([
        //     __DIR__.'/path/to/assets' => public_path('vendor/courier'),
        // ], 'public');
    }

    /**
     * Get the config path.
     *
     * @return string
     */
    protected function getConfigPath()
    {
        return config_path('config-file.php');
    }

    /**
     * 获取提供器提供的服务。
     *
     * @return array
     */
    public function provides()
    {
        return ['example'];
    }
}
