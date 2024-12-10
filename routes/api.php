<?php

use App\Http\Controllers\Api\V1\FeedController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::group(
    [
        'prefix' => 'v1'
    ], function() {
        Route::get('get-public-feeds', [FeedController::class, 'index']);
    }
);
