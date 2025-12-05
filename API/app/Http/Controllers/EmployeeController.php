<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Employee;

class EmployeeController extends Controller
{
    public function show($id)
{
    $employee = Employee::with(['position', 'department', 'user'])->find($id);

    if (!$employee) {
        return response()->json([
            'success' => false,
            'message' => 'Employee not found'
        ], 404);
    }

    return response()->json($employee, 200);
}

}
