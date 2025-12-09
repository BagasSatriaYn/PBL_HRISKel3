<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\EmployeeDashboardController;
use App\Http\Controllers\EmployeeController;
use App\Http\Controllers\UserController;
use App\Models\Absensi;
use App\Http\Controllers\AbsensiController;


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

/*
|--------------------------------------------------------------------------
| AUTH ROUTES (JWT)
|--------------------------------------------------------------------------
*/
Route::prefix('auth')->group(function () {
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/reset-password', [AuthController::class, 'resetPassword']);

    // Tambahkan logout untuk melengkapi versi origin/main
    Route::post('/logout', [AuthController::class, 'logout']);
});

/*
|--------------------------------------------------------------------------
| PROTECTED ROUTES (JWT auth:api)
|--------------------------------------------------------------------------
*/

Route::prefix('employee')->middleware('auth:api')->group(function () {

    // Dashboard & Attendance
    Route::get('/dashboard/summary', [EmployeeDashboardController::class, 'getDashboardSummary']);
    Route::get('/dashboard/weekly-attendance', [EmployeeDashboardController::class, 'getWeeklyAttendance']);
    Route::get('/attendance/history', [EmployeeDashboardController::class, 'getAttendanceHistory']);
    Route::get('/overtime/history', [EmployeeDashboardController::class, 'getOvertimeHistory']);

    // Profile
    // Profile (gunakan 1 endpoint saja)
    Route::get('/profile', [UserController::class, 'profile']);
    Route::put('/profile', [EmployeeController::class, 'updateprofile']);


    // Absensi Report
    Route::get('/absensi/report', [AbsensiController::class, 'report']);
});
/*
|--------------------------------------------------------------------------
| ME endpoint (menggabungkan versi origin/main)
|--------------------------------------------------------------------------
*/
Route::middleware('auth:api')->get('/me', function (Request $request) {
    return $request->user();
});

/*
|--------------------------------------------------------------------------
| TEST ROUTE
|--------------------------------------------------------------------------
*/
Route::get('/test', function () {
    return response()->json([
        'success' => true,
        'message' => 'API is working',
        'timestamp' => now()->toDateTimeString()
    ]);
});
