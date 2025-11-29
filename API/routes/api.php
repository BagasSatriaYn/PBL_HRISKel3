<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

Route::post('/login', [AuthController::class, 'login']);
Route::post('/reset-password', [AuthController::class, 'resetPassword']);
