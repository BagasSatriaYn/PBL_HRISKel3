import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../login/services/dashboard.service.dart';
import 'sidebar_employee.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  final EmployeeService _dashboardService = EmployeeService();

  bool loading = true;

  // ===== DATA DARI API =====
  String employeeName = "-";
  String employeeEmail = "-";
  String employeePosition = "-";
  String employeeDepartment = "-";

  int monthlyAttendance = 0;
  int monthlyOvertime = 0;

  String todayStatus = "-";
  String checkInTime = "-";
  String checkOutTime = "-";

  List<Map<String, dynamic>> attendanceData = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final data = await _dashboardService.getDashboardSummary();

      final employee = data['employee'] ?? {};

      setState(() {
        employeeName =
            "${employee['first_name'] ?? ''} ${employee['last_name'] ?? ''}"
                .trim();
        employeeEmail = employee['email'] ?? "-";
        employeePosition = employee['position'] ?? "-";
        employeeDepartment = employee['department'] ?? "-";

        monthlyAttendance = data['monthly_attendance'] ?? 0;
        monthlyOvertime = data['monthly_overtime'] ?? 0;

        todayStatus = data['today_status'] ?? "-";
        checkInTime = data['check_in'] ?? "-";
        checkOutTime = data['check_out'] ?? "-";

        attendanceData = [
          {
            'label': 'Hadir',
            'value': monthlyAttendance,
            'color': Colors.green,
          },
          {
            'label': 'Telat',
            'value': data['late_count'] ?? 0,
            'color': Colors.orange,
          },
          {
            'label': 'Izin',
            'value': data['permission_count'] ?? 0,
            'color': Colors.blue,
          },
          {
            'label': 'Lembur',
            'value': monthlyOvertime,
            'color': Colors.purple,
          },
        ];

        loading = false;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', employeeName);
      await prefs.setString('userEmail', employeeEmail);
    } catch (e) {
      debugPrint("❌ Dashboard Error: $e");

      loading = false;

      setState(() {});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat dashboard: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A6FA5),
        foregroundColor: Colors.white,
        title: const Text(
          'Dashboard Perusahaan',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      drawer: const AppSidebar(),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _headerSection(),
                    const SizedBox(height: 16),
                    _profileCard(),
                    const SizedBox(height: 16),
                    _attendanceCards(),
                    const SizedBox(height: 16),
                    _monthlyAttendanceSummary(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _headerSection() {
    final firstName =
        employeeName.isNotEmpty ? employeeName.split(" ").first : "-";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF4A6FA5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Datang, $firstName!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Status hari ini: $todayStatus',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileCard() {
    final initials = employeeName.isNotEmpty
        ? employeeName
            .split(" ")
            .map((e) => e.isNotEmpty ? e[0] : "")
            .take(2)
            .join()
            .toUpperCase()
        : "?";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: const Color(0xFF4A6FA5),
            child: Text(
              initials,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employeeName.isEmpty ? "-" : employeeName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  employeeEmail,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  "$employeePosition • $employeeDepartment",
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _attendanceCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _todayAttendanceCard()),
          const SizedBox(width: 12),
          Expanded(child: _salaryCard()),
        ],
      ),
    );
  }

  Widget _todayAttendanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4A6FA5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Absensi Hari Ini',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text('Masuk: $checkInTime',
              style: const TextStyle(color: Colors.white)),
          Text('Keluar: $checkOutTime',
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _salaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gaji Bulan Ini',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
          SizedBox(height: 8),
          Text('Belum tersedia'),
        ],
      ),
    );
  }

  Widget _monthlyAttendanceSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Ringkasan Absensi',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...attendanceData.map((item) => _attendanceSummaryItem(
                label: item['label'],
                value: item['value'],
                color: item['color'],
              )),
        ],
      ),
    );
  }

  Widget _attendanceSummaryItem(
      {required String label,
      required int value,
      required Color color}) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label)),
        Text(
          '$value',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
