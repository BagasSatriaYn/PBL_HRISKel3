<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator; // Tambahkan ini untuk validasi
use Illuminate\Support\Facades\Auth;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;
use App\Models\Employee;

class AuthController extends Controller
{
    // --- LOGIN ---
    public function login(Request $request)
    {
        
        // 1. Validasi Input
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Input tidak valid',
                'errors' => $validator->errors()
            ], 422);
        }

        // 2. Ambil Kredensial
        $credentials = $request->only('email', 'password');
     

        try {
            // 3. Coba Login & Generate Token
            if (!$token = JWTAuth::attempt($credentials)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Email atau Password salah'
                ], 401);
            }
        } catch (JWTException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal membuat token'
            ], 500);
        }

       // 4. Ambil Data User
        $user = Auth::user();

        // 5. Ambil Data Employee (Join)
        $employee = Employee::where('user_id', $user->id)->first();

        $fullName = null;
        if ($employee) {
            $fullName = trim($employee->first_name.' '.$employee->last_name);
        }

        // 6. Return response yg sudah digabung
        return response()->json([
            'success' => true,
            'message' => 'Login berhasil',
            'token' => $token,
            'user' => [
                'id'        => $user->id,
                'email'     => $user->email,
                'is_admin'  => $user->is_admin,
                'full_name' => $fullName,
            ]
        ], 200);

    // --- RESET PASSWORD (PERINGATAN: INI VERSI SEDERHANA/DEV) ---
    public function resetPassword(Request $request)
    {
        // 1. Validasi
        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:users,email', // Pastikan email ada di tabel users
            'password' => 'required|min:6|confirmed' // Gunakan 'confirmed' jika di frontend ada field 'confirm password'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        // 2. Cari User
        $user = User::where('email', $request->email)->first();

        // (Pengecekan redundant karena sudah ada validasi 'exists', tapi untuk keamanan ganda boleh ada)
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Email tidak ditemukan'
            ], 404);
        }

        // 3. Update Password
        // Gunakan Hash::make agar konsisten
        $user->password = Hash::make($request->password);
        $user->save();

        return response()->json([
            'success' => true,
            'message' => 'Password berhasil diubah'
        ], 200);
    }
}