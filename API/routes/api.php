<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\EmployeeDashboardController;
use App\Http\Controllers\EmployeeController;
use App\Http\Controllers\UserController;
use App\Models\Absensi;
use App\Http\Controllers\AbsensiController;
// Tambahkan Import SalaryController
use App\Http\Controllers\SalaryController; 

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
    Route::post('/logout', [AuthController::class, 'logout']);
});

/*
|--------------------------------------------------------------------------
| PROTECTED ROUTES (JWT auth:api)
|--------------------------------------------------------------------------
*/

// Semua route di dalam group ini akan memiliki prefix '/employee'
// Contoh: /api/employee/dashboard/summary
Route::prefix('employee')->middleware('auth:api')->group(function () {

    // Dashboard & Attendance
    Route::get('/dashboard/summary', [EmployeeDashboardController::class, 'getDashboardSummary']);
    Route::get('/dashboard/weekly-attendance', [EmployeeDashboardController::class, 'getWeeklyAttendance']);
    Route::get('/attendance/history', [EmployeeDashboardController::class, 'getAttendanceHistory']);
    Route::get('/overtime/history', [EmployeeDashboardController::class, 'getOvertimeHistory']);

    // Profile
    Route::get('/profile', [EmployeeDashboardController::class, 'getProfile']); 
    Route::get('/user/profile', [UserController::class, 'profile']); 
    Route::put('/profile', [UserController::class, 'editprofile']);

    // Absensi Report
    Route::get('/absensi/report', [AbsensiController::class, 'report']);

    // ==========================================
    // SLIP GAJI (Route Baru)
    // Endpoint: /api/employee/salary-slip
    // ==========================================
    Route::get('/salary-slip', [SalaryController::class, 'getSalarySlip']);
    
});

/*
|--------------------------------------------------------------------------
| ME endpoint
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