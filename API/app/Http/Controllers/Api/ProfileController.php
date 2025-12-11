<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\CheckClock;
use App\Models\SalaryReport;
use Carbon\Carbon;

class ProfileController extends Controller
{
    // Endpoint profile user sesuai token
    public function profile(Request $request)
    {
        $user = $request->user(); // ambil user dari token
        
        // Pastikan load relation employee beserta jabatan/departemen
        $employee = $user->employee()->with(['position', 'department'])->first();

        if (!$employee) {
            return response()->json([
                'success' => false,
                'message' => 'Employee data tidak ditemukan'
            ], 404);
        }

        $today = now()->toDateString();
        $currentMonth = now()->month;
        $currentYear = now()->year;
        $monthString = now()->format('Y-m'); // Format untuk salary report (asumsi)

        // 1. Ambil absensi hari ini (berdasarkan kolom 'date')
        $absensiToday = CheckClock::where('employee_id', $employee->id)
            ->whereDate('date', $today)
            ->orderBy('created_at', 'desc') // Ambil yang terbaru jika ada multiple (misal lembur)
            ->first();

        // 2. Ambil semua absensi bulan ini
        $absensiMonth = CheckClock::where('employee_id', $employee->id)
            ->whereMonth('date', $currentMonth)
            ->whereYear('date', $currentYear)
            ->get();

        // 3. Hitung ringkasan berdasarkan Enum Migration
        // Enum: ['hadir', 'sakit', 'dinas', 'cuti']
        $hadir = $absensiMonth->where('status', 'hadir')->count();
        $sakit = $absensiMonth->where('status', 'sakit')->count();
        $dinas = $absensiMonth->where('status', 'dinas')->count();
        $cuti  = $absensiMonth->where('status', 'cuti')->count();

        // Hitung Lembur (check_clock_type = 1)
        $monthlyOvertime = $absensiMonth->where('check_clock_type', 1)->count();

        // 4. Ambil gaji bulan ini (Asumsi tabel SalaryReport tetap sama)
        $salary = SalaryReport::where('employee_id', $employee->id)
            ->where('month', $monthString)
            ->first();

        return response()->json([
            'success' => true,
            'message' => 'Data dashboard berhasil diambil',
            'data' => [
                'user' => [
                    'id'    => $user->id,
                    'email' => $user->email,
                    'role'  => $user->is_admin ? 'admin' : 'employee',
                ],
                'employee' => [
                    'id'        => $employee->id,
                    'name'      => trim($employee->first_name . ' ' . $employee->last_name),
                    // Perbaikan: gunakan null coalescing operator yang aman
                    'position'  => $employee->position->name ?? '-', 
                    'department'=> $employee->department->name ?? '-', // Typo fix: departement -> department (sesuaikan model)
                ],
                'today_activity' => [
                    'status'      => $absensiToday->status ?? 'Belum Absen',
                    'clock_in'    => $absensiToday->clock_in ?? '-',
                    'clock_out'   => $absensiToday->clock_out ?? '-',
                    'is_overtime' => isset($absensiToday) ? ($absensiToday->check_clock_type == 1) : false,
                ],
                // Statistik Bulanan
                'monthly_attendance' => $hadir,
                'monthly_sakit'      => $sakit,
                'monthly_dinas'      => $dinas,
                'monthly_cuti'       => $cuti,
                'monthly_overtime'   => $monthlyOvertime,
                
                // Info Gaji
                'salary_info' => [
                    'amount' => $salary?->amount ?? 0,
                    'status' => $salary?->status ?? 'Unpaid',
                ],
                
                // History List untuk UI
                'activity_list' => $absensiMonth->map(function($a) {
                    return [
                        'date'      => Carbon::parse($a->date)->format('Y-m-d'),
                        'clock_in'  => $a->clock_in,
                        'clock_out' => $a->clock_out,
                        'status'    => ucfirst($a->status),
                        'type'      => $a->check_clock_type == 1 ? 'Lembur' : 'Reguler',
                    ];
                })->values(), // Reset keys agar jadi array JSON
            ]
        ]);
    }
}