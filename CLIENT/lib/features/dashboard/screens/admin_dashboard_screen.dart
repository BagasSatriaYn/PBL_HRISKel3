import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../login/services/AdminDashboardService.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String adminName = '-';
  String adminEmail = '-';
  String adminRole = 'Admin';

  int totalEmployees = 0;

  int hadir = 0;
  int izin = 0;
  int telat = 0;
  int alpha = 0;

  double tingkatKehadiran = 0;

  int selectedMonth = DateTime.now().month;

  bool loading = true;

  final List<String> months = const [
    'Januari','Februari','Maret','April',
    'Mei','Juni','Juli','Agustus',
    'September','Oktober','November','Desember'
  ];

  @override
  void initState() {
    super.initState();
    _initDashboard();
  }

  Future<void> _initDashboard() async {
    await _loadProfile();
    await _loadStats();
    setState(() => loading = false);
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    adminName  = prefs.getString('userName') ?? '-';
    adminEmail = prefs.getString('userEmail') ?? '-';
  }

  Future<void> _loadStats() async {
    try {
      final data =
          await AdminDashboardService.getStats(month: selectedMonth);

      totalEmployees = data['total_employees'] ?? 0;

      final absensi = data['absensi_bulanan'] ?? {};

      hadir = absensi['hadir'] ?? 0;
      izin  = absensi['izin'] ?? 0;
      telat = absensi['telat'] ?? 0;
      alpha = absensi['alpha'] ?? 0;

      final total = hadir + izin + telat + alpha;

      if (total > 0) {
        tingkatKehadiran = (hadir / total) * 100;
      } else {
        tingkatKehadiran = 0;
      }

      setState(() {});
    } catch (e) {
      debugPrint("ERROR DASHBOARD: $e");
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
    backgroundColor: const Color(0xfff4f6fb),
    body: loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildProfileBar(),
                        const SizedBox(height: 16),
                        _buildSummaryCards(),
                        const SizedBox(height: 16),
                        _buildMonthDropdown(),
                        const SizedBox(height: 16),
                        _buildAbsensiPieChart(),
                        const SizedBox(height: 16),
                        _buildManagementButtons(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
  );
}

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      decoration: const BoxDecoration(
        color: Color(0xff5478ad),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu, color: Colors.white),
              const SizedBox(width: 12),
              const Text(
                'Dashboard Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: logout,
              )
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Selamat Datang, $adminName!',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const Text(
            "Overview Perusahaan",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileBar() {
    final initial = adminName.isNotEmpty ? adminName[0] : '?';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xff5478ad),
          child: Text(
            initial,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(adminName),
        subtitle: Text(adminEmail),
        trailing: Text(
          adminRole,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        _summary('Total Karyawan', totalEmployees, Icons.people),
        const SizedBox(width: 12),
        _summaryPersentase(),
      ],
    );
  }

  Widget _summary(String title, int value, IconData icon) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xff5478ad), size: 32),
              const SizedBox(height: 6),
              Text(title, style: const TextStyle(color: Colors.grey)),
              Text('$value',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryPersentase() {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.bar_chart,
                  color: Color(0xff5478ad), size: 32),
              const SizedBox(height: 6),
              const Text(
                'Tingkat Kehadiran Bulanan',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              Text(
                '${tingkatKehadiran.toStringAsFixed(1)} %',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Pilih Bulan:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        DropdownButton<int>(
          value: selectedMonth,
          items: List.generate(12, (i) {
            return DropdownMenuItem(
              value: i + 1,
              child: Text(months[i]),
            );
          }),
          onChanged: (val) async {
            if (val == null) return;

            setState(() {
              selectedMonth = val;
              loading = true;
            });

            await _loadStats();
            setState(() => loading = false);
          },
        ),
      ],
    );
  }

  Widget _buildAbsensiPieChart() {
    final total = hadir + izin + telat + alpha;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            const Text(
              "Grafik Absensi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (total == 0)
              const SizedBox(
                height: 200,
                child: Center(
                  child: Text("Belum ada data",
                      style: TextStyle(color: Colors.grey)),
                ),
              )
            else
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 40,
                    sectionsSpace: 3,
                    sections: [
                      PieChartSectionData(
                          value: hadir.toDouble(),
                          title: 'Hadir ($hadir)',
                          color: Colors.green),
                      PieChartSectionData(
                          value: izin.toDouble(),
                          title: 'Izin ($izin)',
                          color: Colors.blue),
                      PieChartSectionData(
                          value: telat.toDouble(),
                          title: 'Telat ($telat)',
                          color: Colors.orange),
                      PieChartSectionData(
                          value: alpha.toDouble(),
                          title: 'Alpha ($alpha)',
                          color: Colors.red),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildManagementButtons() {
    return Column(
      children: [
        _menuButton('Kelola Employee', Icons.people, '/employees'),
        _menuButton(
            'Persetujuan Lembur', Icons.check_circle, '/approval'),
        _menuButton('Kelola Departemen', Icons.apartment, '/departments'),
      ],
    );
  }

  Widget _menuButton(String title, IconData icon, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(icon),
          label: Text(title),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => context.go(route),
        ),
      ),
    );
  }
}
