<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class EmployeesTableSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('employees')->insert([
            [
                'user_id' => 2, // employee1
                'position_id' => null,
                'department_id' => null,
                'first_name' => 'Budi',
                'last_name' => 'Santoso',
                'gender' => 'M',
                'address' => 'Jakarta',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'user_id' => 3, // employee2
                'position_id' => null,
                'department_id' => null,
                'first_name' => 'Siti',
                'last_name' => 'Aisyah',
                'gender' => 'F',
                'address' => 'Bandung',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}
