<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('salary_reports', function (Blueprint $table) {
            $table->id();

            // FK ke employees
            $table->unsignedBigInteger('employee_id');
            $table->foreign('employee_id')
                ->references('id')
                ->on('employees')
                ->onDelete('cascade');

            // Kode karyawan — tampil di slip gaji
            $table->string('employee_code'); // EMP001

            // Bulan gajian (YYYY-MM)
            $table->string('month');

            // Rincian gaji
            $table->decimal('base_salary', 12, 2)->default(0);
            $table->decimal('allowance', 12, 2)->default(0);
            $table->decimal('overtime', 12, 2)->default(0);
            $table->decimal('deduction', 12, 2)->default(0);

            // Gaji bersih (base + allowance + overtime - deduction)
            $table->decimal('net_salary', 12, 2)->default(0);

            // Informasi rekening
            $table->string('bank_name')->nullable();           // Mandiri
            $table->string('bank_account_number')->nullable(); // 123456789
            $table->string('bank_account_holder')->nullable(); // Rahma Mutia

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('salary_reports');
    }
};