<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class PositionsTableSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('positions')->insert([
            ['id' => 1, 'name' => 'Manager', 'base_salary' => 8000000, 'allowance' => 2000000, 'rate_reguler' => 450000, 'rate_overtime' => 150000],
            ['id' => 2, 'name' => 'Supervisor', 'base_salary' => 6000000, 'allowance' => 1500000, 'rate_reguler' => 350000, 'rate_overtime' => 100000],
            ['id' => 3, 'name' => 'Staff', 'base_salary' => 4000000, 'allowance' => 1000000, 'rate_reguler' => 250000, 'rate_overtime' => 75000],
            ['id' => 4, 'name' => 'Intern', 'base_salary' => 1500000, 'allowance' => 500000, 'rate_reguler' => 100000, 'rate_overtime' => 25000],
        ]);
    }
}