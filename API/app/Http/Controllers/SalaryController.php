<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class SalaryController extends Controller
{
    public function getEmployeeSalary($employeeId, Request $request)
    {
        $month = $request->query('month', now()->month);
        $year = $request->query('year', now()->year);

        $employee = DB::table('employees')
            ->join('positions', 'employees.position_id', '=', 'positions.id')
            ->where('employees.id', $employeeId)
            ->select(
                'employees.id',
                'employees.first_name',
                'employees.last_name',
                'positions.name as position',
                'positions.rate_reguler',
                'positions.rate_overtime'
            )
            ->first();

        if (!$employee) {
            return response()->json([
                'message' => 'Employee not found'
            ], 404);
        }

        $startDate = Carbon::create($year, $month, 1)->startOfMonth();
        $endDate   = Carbon::create($year, $month, 1)->endOfMonth();

        $attendance = DB::table('check_clocks')
            ->where('employee_id', $employeeId)
            ->whereBetween('date', [$startDate, $endDate])
            ->select(
                DB::raw("SUM(reguler_hours) as total_reguler"),
                DB::raw("SUM(overtime_hours) as total_overtime")
            )
            ->first();

        $totalReguler = $attendance->total_reguler ?? 0;
        $totalOvertime = $attendance->total_overtime ?? 0;

        $base  = $totalReguler * $employee->rate_reguler;
        $overtime = $totalOvertime * $employee->rate_overtime;

        $bonus = $month == 12 ? 500000 : 0;
        $deduction = 200000;

        $takeHomePay = $base + $overtime + $bonus - $deduction;

        return response()->json([
            'employeeId'   => $employee->id,
            'name'         => $employee->first_name . ' ' . $employee->last_name,
            'position'     => $employee->position,
            'period'       => Carbon::create($year, $month, 1)->format('F Y'),
            'baseSalary'   => $base,
            'allowances'   => $overtime,
            'bonus'        => $bonus,
            'deductions'   => $deduction,
            'takeHomePay'  => $takeHomePay,
            'bankName'     => 'Mandiri',
            'accountNumber'=> '123654789',
            'accountHolder'=> $employee->first_name . ' ' . $employee->last_name,
        ]);
    }
}
