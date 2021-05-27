<?php

use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/


Route::get('/test', function () {
    return '1';
});

Route::get('/test/view', function () {
    return view('test');
});

Route::get('/test/queue', function () {
    \App\Jobs\ProcessPodcast::dispatch();
    // 在 storage/app/queue.txt 中看到内容
    return 'I will put job to queue';
});

Route::get('/test/queue/result', function () {
    return \Storage::disk('local')->get('queue.txt');
});

Route::get('/test/schedule/result', function () {
    return \Storage::disk('local')->get('schedule.txt');
});

Route::get('/test/rootless/result', function () {
    return \Storage::disk('local')->get('rootless.txt');
});

Route::get('/', function () {
    return Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        'laravelVersion' => Application::VERSION,
        'phpVersion' => PHP_VERSION,
    ]);
});

Route::middleware(['auth:sanctum', 'verified'])->get('/dashboard', function () {
    return Inertia::render('Dashboard');
})->name('dashboard');
