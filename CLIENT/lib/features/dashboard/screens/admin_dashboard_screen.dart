import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // ✅ DATA DARI LOGIN
  String adminName = '-';
  String adminEmail = '-';

  // ✅ DATA MOCK (SIAP DIGANTI API)
  int totalEmployees = 128;
  int pendingOvertime = 7;

  final List<Map<String, String>> lemburList = const [
    {'name': 'Siti Nur', 'date': '2025-11-30', 'hours': '2h'},
    {'name': 'Budi Santoso', 'date': '2025-11-29', 'hours': '3h'},
    {'name': 'Dapret', 'date': '2025-11-28', 'hours': '4h'},
    {'name': 'Rina', 'date': '2025-11-27', 'hours': '2h'},
  ];

  bool loading = true;

  // ✅ LOAD PROFIL ADMIN SAAT DASHBOARD DIBUKA
  @override
  void initState() {
    super.initState();
    _loadAdminProfile();
  }

  Future<void> _loadAdminProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      adminName = prefs.getString('userName') ?? '-';
      adminEmail = prefs.getString('userEmail') ?? '-';
      loading = false;
    });
  }

  // ✅ LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 16),
                    _buildSummaryCards(),
                    const SizedBox(height: 16),
                    _buildAttendanceChartCard(),
                    const SizedBox(height: 16),
                    _buildLemburCard(),
                    const SizedBox(height: 16),
                    _buildKelolaButtons(),
                  ],
                ),
              ),
            ),
    );
  }

  // =============================
  // ==== UI COMPONENTS ==========
  // =============================

  Widget _buildProfileCard() {
    final initials = adminName.isNotEmpty
        ? adminName.split(' ').map((e) => e[0]).take(2).join()
        : '';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              child: Text(initials),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    adminName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(adminEmail,
                      style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 8),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
            child:
                _smallInfoCard('Total Karyawan', '$totalEmployees', Icons.group)),
        const SizedBox(width: 12),
        Expanded(
            child: _smallInfoCard(
                'Lembur', '$pendingOvertime', Icons.timer)),
      ],
    );
  }

  Widget _smallInfoCard(String title, String value, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(title),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceChartCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Grafik Absensi',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _mockAttendanceSpots(),
                      isCurved: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: true),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _mockAttendanceSpots() {
    final values = [82, 89, 78, 88, 92, 80, 95];
    return List.generate(
      values.length,
      (i) => FlSpot(i.toDouble(), values[i].toDouble()),
    );
  }

  Widget _buildLemburCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lembur Terbaru',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            ...lemburList
                .take(3)
                .map((e) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.timer),
                      title: Text(e['name'] ?? ''),
                      subtitle: Text('${e['date']} • ${e['hours']}'),
                    )),

            if (lemburList.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Tidak ada data lembur'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildKelolaButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Kelola',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.manage_accounts),
          label: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Kelola Karyawan'),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.assignment_turned_in),
          label: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Kelola Persetujuan'),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.apartment),
          label: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Kelola Departemen'),
          ),
        ),
      ],
    );
  }
}
