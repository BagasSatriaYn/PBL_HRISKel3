import 'package:flutter/material.dart';

void main() {
  runApp(const EmployeeDashboard());
}

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text("Dashboard Perusahaan"),
        backgroundColor: Colors.blue,
      ),

      // ===================== BODY ======================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selamat Datang!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Ringkasan hari ini:",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // =================== 1. PROFIL dashboard (per user) ===================
            Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage("assets/profile.jpg"),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Rahmalia Mutia",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Staff Administrasi",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 25),

            // =================== 2. ABSENSI ===================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.access_time, size: 40, color: Colors.blue),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status Absensi Hari Ini",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text("Check-in: 07:55 WIB"),
                    ],
                  ),
                  Text(
                    "Hadir",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // =================== 3. GAJI ===================
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.money, size: 40, color: Colors.green),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Gaji Bulan Ini",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("Rp 4.500.000,-", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // =================== 4. CHART ===================
            const Text(
              "Statistik Kehadiran",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade100,
              ),
              child: const Center(
                child: Text(
                  "Mini Chart Placeholder",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // =================== 5. PENGUMUMAN ===================
            const Text(
              "Pengumuman HR",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.orange.shade50,
              ),
              child: const Text(
                "- Cuti bersama akan diadakan pada tanggal 3–5 Mei.\n"
                "- Jangan lupa update data pribadi.\n"
                "- Training wajib dilaksanakan pekan ini.",
                style: TextStyle(fontSize: 15),
              ),
            ),

            const SizedBox(height: 25),

            // =================== 6. MENU SHORTCUT ===================
            const Text(
              "Menu Cepat",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 15),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ShortcutMenu(title: "Gaji", icon: Icons.money),
                ShortcutMenu(title: "Absensi", icon: Icons.access_time),
                ShortcutMenu(title: "Laporan", icon: Icons.insert_chart),
                ShortcutMenu(title: "Cuti", icon: Icons.calendar_month),
                ShortcutMenu(title: "Lembur", icon: Icons.add_alarm),
                ShortcutMenu(title: "Profil", icon: Icons.person),
              ],
            ),

            const SizedBox(height: 25),

            // =================== 7. RIWAYAT ===================
            const Text(
              "Riwayat Aktivitas Terbaru",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            Column(
              children: const [
                ActivityTile(title: "Check-in 07:55 WIB", date: "Hari ini"),
                ActivityTile(
                  title: "Pengajuan Cuti (Disetujui)",
                  date: "Kemarin",
                ),
                ActivityTile(
                  title: "Slip Gaji Bulan Lalu Diunduh",
                  date: "2 hari lalu",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// WIDGETS PENDUKUNG
// =============================================================

class ShortcutMenu extends StatelessWidget {
  final String title;
  final IconData icon;

  const ShortcutMenu({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue, size: 28),
        ),
        const SizedBox(height: 6),
        Text(title),
      ],
    );
  }
}

class ActivityTile extends StatelessWidget {
  final String title;
  final String date;

  const ActivityTile({super.key, required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(title),
      subtitle: Text(date),
    );
  }
}

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          UserAccountsDrawerHeader( //profile karyawan
            accountName: Text("Karyawan Perusahaan"),
            accountEmail: Text("karyawan@company.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40),
            ),
          ),
          ListTile(leading: Icon(Icons.dashboard), title: Text("Dashboard")),
          ListTile(leading: Icon(Icons.money), title: Text("Gaji")),
          ListTile(leading: Icon(Icons.access_time), title: Text("Absensi")),
          ListTile(leading: Icon(Icons.insert_chart), title: Text("Laporan")),
          Divider(),
          ListTile(leading: Icon(Icons.logout), title: Text("Logout")),
        ],
      ),
    );
  }
}
