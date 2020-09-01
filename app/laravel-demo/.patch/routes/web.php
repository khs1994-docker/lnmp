<?php

use Illuminate\Support\Facades\Route;

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

Route::get('/', function () {
    return view('welcome');
});

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

Auth::routes();

Route::get('/home', 'HomeController@index')->name('home');
