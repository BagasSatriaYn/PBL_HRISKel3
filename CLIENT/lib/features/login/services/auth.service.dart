// services/auth.service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  // BASE URL Laravel API
  final String baseUrl = "http://localhost:8000/api";

  // =============================
  //            LOGIN
  // =============================
  Future<User> login(String email, String password) async {
    final uri = Uri.parse("$baseUrl/auth/login");

    try {
      final response = await http.post(
        uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "email": email,
          "password": password,
        },
      );

      print("=== AUTH LOGIN DEBUG ===");
      print("URL: $uri");
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final Map<String, dynamic> data = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : {};

      if (response.statusCode != 200) {
        final msg = data['message'] ?? 'Login failed';
        throw Exception(msg);
      }

      // Ambil token & user
      String token = data['token']?.toString() ?? '';
      Map<String, dynamic> userMap = data['user'];

      if (token.isEmpty || userMap.isEmpty) {
        throw Exception("Response tidak lengkap. BODY: ${response.body}");
      }

      // Simpan token & user ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('userName', userMap['name'] ?? '');
      await prefs.setString('userEmail', userMap['email'] ?? '');

      return User.fromJson(userMap, token);
    } catch (e) {
      print("ERROR LOGIN: $e");
      rethrow;
    }
  }

  // =============================
  //        RESET PASSWORD
  // =============================
  Future<void> resetPassword(String email, String newPassword) async {
    final uri = Uri.parse("$baseUrl/auth/reset-password");

    final response = await http.post(
      uri,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "email": email,
        "password": newPassword,
        "password_confirmation": newPassword,
      },
    );

    print("RESET BODY: ${response.body}");
    final Map<String, dynamic> data =
        response.body.isNotEmpty ? jsonDecode(response.body) : {};

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Reset failed');
    }
  }

  // =============================
  //            LOGOUT
  // =============================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    final url = Uri.parse('$baseUrl/auth/logout');

    await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    // Hapus token
    await prefs.remove('token');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
  }
}
