<?php

declare(strict_types=1);

namespace Example\Console;

use Illuminate\Console\Command;

class ExampleCommand extends Command
{
    protected $signature = 'command:example
                            {arg : arg description}
                            {--O|option : option description}';

    // {--option=} 带值的选项
    // {--option=default} 带值的选项，默认值
    // {arg*} 参数为数组 cli 1 2 3 -> arg 值为 [1,2,3]
    // {--id=*} cli --id=1 --id=2

    protected $description = 'command description';

    public function handle(): void
    {
        $arg = $this->argument('arg');

        $option = $this->hasOption('option');

        try {
            $output = 1;

            // $this->ask('question','default');

            // $password = $this->secret('What is the password?');

            // $this->confirm('Do you wish to continue?')

            // $name = $this->anticipate('What is your name?', ['Taylor', 'Dayle']);

            // $name = $this->choice('What is your name?', ['Taylor', 'Dayle'], $default);

            $this->line($output);
            // ->info
            // ->comment
            // ->question

            // 输出表格
            // $this->table(['a', 'b'], [1, 2]);

            // 调用其他命令
            // $this->call('email:send', [
            //        'user' => 1, '--queue' => 'default'
            //    ]);

            // 阻止输出
            // $this->callSilent('email:send', [
            //    'user' => 1, '--queue' => 'default'
            // ]);
        } catch (Exception $e) {
            $this->error($e->getMessage());
        }
    }
}
