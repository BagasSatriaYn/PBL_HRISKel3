<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User; // gunakan model User bawaan Laravel
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        // Validasi input
        $request->validate([
            'email' => 'required|email',
            'password' => 'required'
        ]);

        // Cek user berdasarkan email
        $user = User::where('email', $request->email)->first();

        // Jika user tidak ditemukan
        if (!$user) {
            return response()->json([
                'message' => 'Email tidak ditemukan'
            ], 404);
        }

        // Cek password
        if (!Hash::check($request->password, $user->password)) {
            return response()->json([
                'message' => 'Password salah'
            ], 401);
        }
        // Jika login berhasil
    return response()->json([
    'message' => 'Login berhasil',
    'user' => [
        'id' => $user->id,
        'email' => $user->email,
        'role' => $user->is_admin ? 'admin' : 'employee' // ✅ INI YANG BENAR
        ]
    ], 200);
    }
    public function resetPassword(Request $request)
{
    $request->validate([
        'email' => 'required|email',
        'password' => 'required|min:6'
    ]);

    $user = User::where('email', $request->email)->first();

    if (!$user) {
        return response()->json([
            'message' => 'Email tidak ditemukan'
        ], 404);
    }

    $user->password = bcrypt($request->password);
    $user->save();

    return response()->json([
        'message' => 'Password berhasil diubah'
    ], 200);
}

}