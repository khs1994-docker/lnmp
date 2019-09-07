<?php

Route::get('/', function () {
    return view('welcome');
});

Route::get('/test', function () {
    return 1;
});

Route::get('/test/view', function () {
    return view('test');
});

Route::get('/test/s3', function () {
    return Storage::disk('s3')->allFiles();
});
