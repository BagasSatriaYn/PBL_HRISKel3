<?php

namespace App\Http\Controllers;

use App\Models\Employee;
use App\Models\Absensi;
use Carbon\Carbon;
use Illuminate\Http\Request;

class AdminDashboardController extends Controller
{
    public function stats(Request $request)
    {
        // ========================
        // BASIC STATS
        // ========================
        $totalEmployees = Employee::count();

        // =====================================
        // FILTER BULAN DARI CLIENT (1–12)
        // DEFAULT = BULAN SEKARANG
        // =====================================
        $month = $request->query('month', Carbon::now()->month);
        $year  = Carbon::now()->year;

        // ========================
        // AMBIL ABSENSI BULAN PILIHAN
        // ========================
        $absensi = Absensi::whereYear('tanggal', $year)
                        ->whereMonth('tanggal', $month)
                        ->get();

        // ========================
        // HITUNG STATUS
        // ========================
        $hadir = $absensi->where('status', 'hadir')->count();
        $izin  = $absensi->where('status', 'izin')->count();
        $telat = $absensi->where('status', 'telat')->count();
        $alpha = $absensi->where('status', 'alpha')->count();

        return response()->json([
            'success' => true,
            'data' => [
                'total_employees' => $totalEmployees,
                'month' => $month,
                'absensi_bulanan' => [
                    'hadir' => $hadir,
                    'izin'  => $izin,
                    'telat' => $telat,
                    'alpha' => $alpha,
                ],
            ]
        ]);
    }
}
