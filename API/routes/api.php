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

// ===========================================
// AUTH ROUTES (Tidak perlu JWT)
// ===========================================
Route::prefix('auth')->group(function () {
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/reset-password', [AuthController::class, 'resetPassword']);
});
// routes/api.php

Route::prefix('employee')->middleware('auth:api')->group(function () {
    Route::get('/dashboard/summary', [EmployeeDashboardController::class, 'getDashboardSummary']);
    Route::get('/dashboard/weekly-attendance', [EmployeeDashboardController::class, 'getWeeklyAttendance']);
    Route::get('/attendance/history', [EmployeeDashboardController::class, 'getAttendanceHistory']);
    Route::get('/overtime/history', [EmployeeDashboardController::class, 'getOvertimeHistory']);
    Route::get('/profile', [EmployeeDashboardController::class, 'getProfile']);
    Route::get('/user/profile', [UserController::class, 'profile']);
    
    // ✅ TAMBAHKAN INI - Ambil absensi berdasarkan user yang login
    Route::get('/absensi/report', function (Request $request) {
        $user = $request->user(); // Ambil user dari token
        
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

// ===========================================
// TEST ROUTE
// ===========================================
Route::get('/test', function () {
    return response()->json([
        'success' => true,
        'message' => 'API is working',
        'timestamp' => now()->toDateTimeString()
    ]);
});