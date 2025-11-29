import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../../../utils/api.dart';

class AuthService {
  final String baseUrl = Api.baseUrl;

  // ✅ INI WAJIB ADA
  Future<User?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return User.fromJson(data['user']);
    } else {
      throw Exception(data['message'] ?? 'Login gagal');
    }
  }

  // ✅ RESET PASSWORD YANG TADI
  Future<void> resetPassword(String email, String password) async {
    final url = Uri.parse('$baseUrl/reset-password');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Gagal reset password');
    }
  }
}
