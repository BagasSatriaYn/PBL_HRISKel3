import 'package:flutter/material.dart';

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Welcome Employee",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            Text("• View Profile"),
            Text("• Attendance"),
            Text("• Leave Request"),
            Text("• Salary Info"),
          ],
        ),
      ),
    );
  }
}
