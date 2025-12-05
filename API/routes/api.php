<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\AuthController; // <--- WAJIB DI-IMPORT CONTROLLER E

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// --- 1. ROUTE PUBLIC (Iso diakses tanpa token) ---
Route::post('/login', [AuthController::class, 'login']); 
Route::post('/reset-password', [AuthController::class, 'resetPassword']);


// --- 2. ROUTE PROTECTED (Kudu nggawe token / wis login) ---
Route::middleware('auth:api')->group(function () {
    
    // Cek Profile
    Route::get('/profile', function (Request $request) {
        return response()->json([
            'success' => true,
            'user' => $request->user() // Paling aman nggo VS Code
        ]);
    });

    // Nek arep nambah Logout neng kene
    // Route::post('/logout', [AuthController::class, 'logout']);
});