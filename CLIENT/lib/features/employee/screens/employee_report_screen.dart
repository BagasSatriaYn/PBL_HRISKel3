import 'package:flutter/material.dart';

class EmployeeReportScreen extends StatelessWidget {
  const EmployeeReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Report'),
      ),
      body: const Center(
        child: Text(
          'This is the Employee Report Screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
