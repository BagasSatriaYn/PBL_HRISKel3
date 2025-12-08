<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\EmployeeDashboardController;
use App\Http\Controllers\UserController;
use App\Models\Absensi;

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
    Route::get('/profile', [EmployeeDashboardController::class, 'getProfile']);
    Route::get('/user/profile', [UserController::class, 'profile']);

    // Absensi report berdasarkan user login
    Route::get('/absensi/report', function (Request $request) {
        $user = $request->user();

        if (!$user->employee) {
            return response()->json(['message' => 'Employee data not found'], 404);
        }

        $employeeId = $user->employee->id;

        $data = Absensi::where('employee_id', $employeeId)
            ->orderBy('tanggal', 'desc')
            ->get();

        return response()->json($data);
    });
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
