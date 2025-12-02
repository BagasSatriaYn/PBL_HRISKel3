import 'package:flutter/material.dart';
import '..//widgets/stats_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key}); // 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADMIN DASHBOARD"),
        backgroundColor: Colors.indigo,
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

           Row(
              children: const [
                StatsCard(
                  title: "SAKIT",
                  value: "12",
                  icon: Icons.sick,
                ),

                StatsCard(
                  title: "CUTI",
                  value: "42",
                  icon: Icons.wallet_travel,
                ),

                StatsCard(
                  title: "IZIN",
                  value: "5",
                  icon: Icons.assignment_turned_in,
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              "MENU ADMIN",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            _menuTile(
              context,
              "Kelola User",
              Icons.people_alt,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Menu Kelola User dipilih")),
                );
              },
            ),

            _menuTile(
              context,
              "Kelola Employee",
              Icons.badge_outlined,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Menu Kelola Employee dipilih")),
                );
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget _menuTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
