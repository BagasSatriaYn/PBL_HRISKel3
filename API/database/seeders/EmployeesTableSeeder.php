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
                'user_id' => 1,
                'position_id' => 1, // Manager
                'departement_id' => 4, // HR
                'first_name' => 'Admin',
                'last_name' => 'Cakep',
                'gender' => 'F',
                'address' => 'admin@corp.com',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'user_id' => 2,
                'position_id' => 3, // Staff
                'departement_id' => 4, // HR
                'first_name' => 'Satria',
                'last_name' => 'Wijaya',
                'gender' => 'M',
                'address' => 'satria@corp.com',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'user_id' => 3,
                'position_id' => 2, // Supervisor
                'departement_id' => 3, // Finance
                'first_name' => 'Renal',
                'last_name' => 'Pratama',
                'gender' => 'M',
                'address' => 'renal@corp.com',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'user_id' => 4,
                'position_id' => 3, // Staff
                'departement_id' => 2, // Marketing
                'first_name' => 'Zaki',
                'last_name' => 'Akbar',
                'gender' => 'M',
                'address' => 'zaki@example.com',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'user_id' => 5,
                'position_id' => 2, // Supervisor
                'departement_id' => 4, // HR
                'first_name' => 'Rahmalia',
                'last_name' => 'Putri',
                'gender' => 'F',
                'address' => 'rahmalia@corp.com',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'user_id' => 6,
                'position_id' => 3, // Staff
                'departement_id' => 2, // Marketing
                'first_name' => 'Arimbi',
                'last_name' => 'Dewi',
                'gender' => 'F',
                'address' => 'arimbi@corp.com',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'user_id' => 7,
                'position_id' => 4, // Intern
                'departement_id' => 3, // Finance
                'first_name' => 'Fasya',
                'last_name' => 'Aulia',
                'gender' => 'F',
                'address' => 'fasya@corp.com',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'user_id' => 8,
                'position_id' => 3, // Staff
                'departement_id' => 5, // RandD
                'first_name' => 'Claudya',
                'last_name' => 'Destine',
                'gender' => 'F',
                'address' => 'claudya@corp.com',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}