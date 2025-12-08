<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\SalaryReport; 
use App\Models\Employee;

class SalaryReportSeeder extends Seeder
{
    public function run(): void
    {
        $employees = Employee::with('position')->get();

        foreach ($employees as $employee) {
            SalaryReport::create([
                'employee_id' => $employee->id,
                'employee_code' => $employee->id, // pakai employee_id langsung
                'month' => '2025-12',
                'base_salary' => $employee->position->base_salary,
                'allowance' => $employee->position->allowance,
                'overtime' => 0,
                'deduction' => 0,
                'net_salary' => $employee->position->base_salary + $employee->position->allowance,
                'bank_name' => $employee->bank_name ?? 'Bank Dummy', // pastikan tidak null
                'bank_account_number' => $employee->bank_account_number ?? '0000000000',
                'bank_account_holder' => $employee->bank_account_holder ?? $employee->first_name,
            ]);
        }
    }
}