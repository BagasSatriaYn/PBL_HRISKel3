<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Employee;
use Illuminate\Http\Request;

class EmployeeController extends Controller
{
    // GET all employees
    public function index()
    {
        return response()->json(Employee::all());
    }

    // POST create employee
        public function store(Request $request)
    {
        $data = $request->validate([
            'first_name' => 'required|string',
            'last_name' => 'required|string',
            'gender' => 'required|string',
            'user_id' => 'required|integer',
            'position_id' => 'required|integer',
            'department_id' => 'required|integer',
            'address' => 'nullable|string',
        ]);

        $employee = Employee::create($data);

        return response()->json([
            'message' => 'Employee created',
            'data' => $employee
        ]);
    }

    // UPDATE employee
    public function update(Request $request, $id)
    {
        $employee = Employee::findOrFail($id);

        $data = $request->validate([
            'first_name' => 'required|string',
            'last_name' => 'required|string',
            'gender' => 'required|string',
            'address' => 'nullable|string',
        ]);

        $employee->update($data);

        return response()->json([
            'message' => 'Employee updated',
            'data' => $employee
        ]);
    }

    // DELETE employee
    public function destroy($id)
    {
        Employee::findOrFail($id)->delete();

        return response()->json([
            'message' => 'Employee deleted'
        ]);
    }
}
