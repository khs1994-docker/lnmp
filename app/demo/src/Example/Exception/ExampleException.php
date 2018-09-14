<?php

declare(strict_types=1);

namespace Example\Exception;

use Exception;

class ExampleException extends Exception
{
    /**
     * 报告异常.
     */
    public function report(): void
    {
        return;
    }

    /**
     * 将异常渲染到 HTTP 响应中。
     *
     * @param  \Illuminate\Http\Request
     */
    public function render(Request $request)
    {
        return response();
    }
}
