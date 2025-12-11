<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call([
            UsersTableSeeder::class,
            DepartementsTableSeeder::class,  // ✔ panggil dulu
            PositionsTableSeeder::class,
            EmployeesTableSeeder::class,     // ✔ baru employees
            SalaryReportSeeder::class,
            CheckClocksSeeder::class,
        ]);
    }
}