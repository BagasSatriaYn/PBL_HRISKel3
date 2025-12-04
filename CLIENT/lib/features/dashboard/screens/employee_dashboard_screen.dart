import 'package:flutter/material.dart';
import 'sidebar_employee.dart';

void main() {
  runApp(const EmployeeDashboard());
}

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    // Semua data sudah dikosongkan.
    final String employeeName = '';
    final String employeePosition = '';
    final String statusToday = '';
    final String masuk = '';
    final String pulang = '';
    final String hadirMonth = '';
    final String telatMonth = '';
    final String izinMonth = '';
    final String lemburMonth = '';
    final String gajiMonth = '';
    final String gajiStatus = '';
    final List<ActivityData> activityList = const [];

    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        title: const Text(
          "Dashboard Perusahaan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Datang!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Ringkasan hari ini:',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 18),

            // PROFILE CARD
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: primary.withOpacity(0.06)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: primary,
                      child: const Icon(Icons.person, size: 36, color: Colors.white),
                    ),
                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            employeeName.isEmpty ? '-' : employeeName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            employeePosition.isEmpty ? '-' : employeePosition,
                            style: TextStyle(color: primary.withOpacity(0.75)),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.circle, size: 12, color: Colors.green),
                              const SizedBox(width: 6),
                              Text(
                                statusToday.isEmpty ? '-' : 'Status: $statusToday',
                                style: const TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.chevron_right, color: primary),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ABSENSI & GAJI
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: BlueFeatureCard(
                    primary: primary,
                    icon: Icons.access_time,
                    title: 'Absensi Hari Ini',
                    lines: [
                      'Jam Masuk: ${masuk.isEmpty ? '-' : masuk}',
                      'Jam Pulang: ${pulang.isEmpty ? '-' : pulang}'
                    ],
                    actionLabel: 'Absen',
                    actionOnPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: BlueFeatureCard(
                    primary: primary,
                    icon: Icons.payments,
                    title: 'Gaji Bulan Ini',
                    lines: [
                      gajiMonth.isEmpty ? '-' : gajiMonth,
                      'Status: ${gajiStatus.isEmpty ? '-' : gajiStatus}',
                    ],
                    actionLabel: 'Slip',
                    actionOnPressed: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // RINGKASAN ABSENSI BULAN
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, size: 36, color: primary),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ringkasan Absensi Bulan Ini',
                              style: TextStyle(fontWeight: FontWeight.bold, color: primary)),
                          const SizedBox(height: 8),

                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              SummaryPill(label: 'Hadir', value: hadirMonth),
                              SummaryPill(label: 'Telat', value: telatMonth),
                              SummaryPill(label: 'Izin', value: izinMonth),
                              SummaryPill(label: 'Lembur', value: lemburMonth),
                            ],
                          ),
                        ],
                      ),
                    ),

                    TextButton(
                      onPressed: () {},
                      child: Text('Lihat', style: TextStyle(color: primary)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Statistik Kehadiran',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
            ),
            const SizedBox(height: 8),

            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: primary.withOpacity(0.06)),
              ),
              child: const Center(
                child: Text('Chart Placeholder', style: TextStyle(color: Colors.grey)),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Pengumuman HR',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
            ),
            const SizedBox(height: 8),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Text('Tidak ada pengumuman.', style: TextStyle(color: Colors.grey)),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Menu Cepat',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
            ),
            const SizedBox(height: 10),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.95,
              children: [
                QuickActionTile(icon: Icons.access_time, label: 'Absensi', primary: primary, onTap: () {}),
                QuickActionTile(icon: Icons.payments, label: 'Gaji', primary: primary, onTap: () {}),
                QuickActionTile(icon: Icons.receipt_long, label: 'Slip Gaji', primary: primary, onTap: () {}),
                QuickActionTile(icon: Icons.calendar_month, label: 'Cuti', primary: primary, onTap: () {}),
                QuickActionTile(icon: Icons.add_alert, label: 'Lembur', primary: primary, onTap: () {}),
                QuickActionTile(icon: Icons.person, label: 'Profil', primary: primary, onTap: () {}),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              'Riwayat Aktivitas Terbaru',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
            ),
            const SizedBox(height: 8),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: activityList.isEmpty
                    ? const [ActivityTile(title: '-', date: '-')]
                    : activityList
                        .map((a) => ActivityTile(title: a.title, date: a.date))
                        .toList(),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------
// COMPONENTS
// ---------------------------------------

class BlueFeatureCard extends StatelessWidget {
  final Color primary;
  final IconData icon;
  final String title;
  final List<String> lines;
  final String actionLabel;
  final VoidCallback actionOnPressed;

  const BlueFeatureCard({
    super.key,
    required this.primary,
    required this.icon,
    required this.title,
    required this.lines,
    required this.actionLabel,
    required this.actionOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...lines.map((l) => Text(l, style: const TextStyle(color: Colors.white))).toList(),
                ],
              ),
            ),

            ElevatedButton(
              onPressed: actionOnPressed,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: primary),
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryPill extends StatelessWidget {
  final String label;
  final String value;

  const SummaryPill({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: primary, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Text(value.isEmpty ? '-' : value, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color primary;
  final VoidCallback onTap;

  const QuickActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: primary.withOpacity(0.12),
            child: Icon(icon, color: primary, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: primary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  final String title;
  final String date;

  const ActivityTile({super.key, required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ListTile(
      leading: Icon(Icons.history, color: primary),
      title: Text(title),
      subtitle: Text(date),
    );
  }
}

class ActivityData {
  final String title;
  final String date;

  const ActivityData({required this.title, required this.date});
}
