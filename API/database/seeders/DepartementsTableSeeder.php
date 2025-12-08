<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class DepartementsTableSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('departements')->insert([
            ['id' => 1, 'name' => 'Factory'],
            ['id' => 2, 'name' => 'Marketing'],
            ['id' => 3, 'name' => 'Finance'],
            ['id' => 4, 'name' => 'HR'],
            ['id' => 5, 'name' => 'Research & Dev'],
        ]);
    }
}