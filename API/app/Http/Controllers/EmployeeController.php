<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use App\Models\Employee;

class EmployeeController extends Controller
{
    public function updateProfile(Request $request)
    {
        $user = $request->user();
        if (!$user) {
            return response()->json(['success' => false, 'message' => 'Unauthenticated.'], 401);
        }

        $employee = $user->employee;
        if (!$employee) {
            return response()->json(['success' => false, 'message' => 'Employee data not found.'], 404);
        }

        // validasi (sesuaikan rules dengan field yg kamu inginkan)
        $validator = Validator::make($request->all(), [
            'first_name' => 'nullable|string|max:100',
            'last_name'  => 'nullable|string|max:100',
            'address'    => 'nullable|string|max:1000',
            // tambahkan rule lain mis: phone, department_id, position_id, dsb.
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error.',
                'errors'  => $validator->errors()
            ], 422);
        }

        $data = $validator->validated();

        // Update user fields jika ada di request (contoh email ada di user, bukan employee)
        if (isset($data['first_name'])) {
            $employee->first_name = $data['first_name'];
        }
        if (isset($data['last_name'])) {
            $employee->last_name = $data['last_name'];
        }
        if (isset($data['address'])) {
            $employee->address = $data['address'];
        }

        $employee->save();

        // jika ada perubahan juga di tabel users, contohnya email:
        // if (isset($data['email'])) {
        //     $user->email = $data['email'];
        //     $user->save();
        // }

        // Kembalikan data terbaru supaya Flutter mudah meng-update UI
        return response()->json([
            'success' => true,
            'message' => 'Profile updated',
            'data' => [
                'user' => $user->fresh()->toArray(),
                'employee' => $employee->fresh()->toArray(),
            ]
        ], 200);
    }

}
