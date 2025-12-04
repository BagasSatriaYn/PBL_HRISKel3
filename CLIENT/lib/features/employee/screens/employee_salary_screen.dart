import 'package:flutter/material.dart';

class EmployeeSalaryScreen extends StatelessWidget {
  const EmployeeSalaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Salary'),
      ),
      body: const Center(
        child: Text(
          'This is the Employee Salary Screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
