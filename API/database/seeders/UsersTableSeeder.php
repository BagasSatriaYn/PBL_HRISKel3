<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class UsersTableSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('users')->insert([
            [
                'email' => 'admin@hris.com',
                'password' => Hash::make('password'),
                'is_admin' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'email' => 'employee1@hris.com',
                'password' => Hash::make('password'),
                'is_admin' => false,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'email' => 'employee2@hris.com',
                'password' => Hash::make('password'),
                'is_admin' => false,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}
