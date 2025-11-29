import 'employee_model.dart';

class User {
  final int id;
  final String email;
  final String role;
  final Employee? employee;

  User({
    required this.id,
    required this.email,
    required this.role,
    this.employee,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,

      // ✅ SEMUA STRING DIPAKSA AMAN
      email: json['email'] == null ? '' : json['email'].toString(),
      role: json['role'] == null ? 'employee' : json['role'].toString(),

      employee: json['employee'] != null
          ? Employee.fromJson(json['employee'])
          : null,
    );
  }
}
