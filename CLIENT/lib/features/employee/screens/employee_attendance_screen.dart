import 'package:flutter/material.dart';

class EmployeeAttendanceScreen extends StatelessWidget {
  const EmployeeAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Attendance'),
      ),
      body: const Center(
        child: Text(
          'This is the Employee Attendance Screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
