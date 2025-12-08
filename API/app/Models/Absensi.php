<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Absensi extends Model
{
    use HasFactory;

    protected $table = 'absensi'; // nama tabel

    protected $fillable = [
        'employee_id',
        'tanggal',
        'status',
        'jam_masuk',
        'jam_pulang',
    ];

    protected $casts = [
        'tanggal' => 'date',
    ];

    // Relasi ke Employee
    public function employee()
    {
        return $this->belongsTo(Employee::class);
    }

    // Helper untuk ambil absensi hari ini
    public static function todayForEmployee($employeeId)
    {
        return self::where('employee_id', $employeeId)
            ->where('tanggal', now()->toDateString())
            ->first();
    }

    // Helper ringkasan bulan
    public static function summaryForMonth($employeeId, $month = null)
    {
        $month = $month ?? now()->month;
        $year = now()->year;

        return self::where('employee_id', $employeeId)
            ->whereYear('tanggal', $year)
            ->whereMonth('tanggal', $month)
            ->get();
    }
}