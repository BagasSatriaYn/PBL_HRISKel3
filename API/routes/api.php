<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\EmployeeController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// --- 1. ROUTE PUBLIC (Iso diakses tanpa token) ---
Route::post('/login', [AuthController::class, 'login']); 
Route::post('/reset-password', [AuthController::class, 'resetPassword']);

Route::get('/employee/{id}', [EmployeeController::class, 'show']);
