import 'package:flutter/material.dart';

class WorkforceOverview extends StatelessWidget {
  final int present;
  final int sakit;
  final int cuti;
  final int izin;
  final int totalEmployee;

  const WorkforceOverview({
    super.key,
    required this.present,
    required this.sakit,
    required this.cuti,
    required this.izin,
    required this.totalEmployee,
  });

  @override
  Widget build(BuildContext context) {
    final double progress =
        totalEmployee == 0 ? 0 : present / totalEmployee;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// --- TITLE ---
            const Text(
              "Today's Workforce Overview",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 16),

            /// --- PROGRESS CIRCLE ---
            Row(
              children: [
                SizedBox(
                  height: 90,
                  width: 90,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        color: Colors.green,
                        backgroundColor: Colors.grey.shade300,
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            present.toString(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Present",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(width: 24),

                /// --- STATUS COLUMN ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      _statusRow(Icons.sick, Colors.red, "Sakit", sakit),
                      _statusRow(Icons.event_busy, Colors.orange, "Cuti", cuti),
                      _statusRow(Icons.assignment_turned_in, Colors.blue, "Izin", izin),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _statusRow(IconData icon, Color color, String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
