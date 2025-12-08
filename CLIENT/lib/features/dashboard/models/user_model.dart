import 'employee_model.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final Employee? employee;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.employee,
  });

  // Convert JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,

      name: json['name']?.toString() ?? "",

      email: json['email']?.toString() ?? "",

      role: json['role']?.toString() ?? "employee",

      employee: json['employee'] != null
          ? Employee.fromJson(json['employee'])
          : null,
    );
  }
}
