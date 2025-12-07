// services/auth.service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  // ✅ Untuk Flutter Web, gunakan localhost
  final String baseUrl = "http://localhost:8000/api";
  
  // Atau gunakan 127.0.0.1 (sama saja)
  // final String baseUrl = "http://127.0.0.1:8000/api";

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

      // debug prints
      print("=== AUTH LOGIN DEBUG ===");
      print("URL: $uri");
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final Map<String, dynamic> data = (response.body.isNotEmpty)
          ? jsonDecode(response.body) as Map<String, dynamic>
          : {};

      if (response.statusCode != 200) {
        final msg = data['message'] ?? data['error'] ?? 'Login failed';
        throw Exception(msg);
      }

      // Extract token and user
      String token = '';
      Map<String, dynamic>? userMap;

      if (data.containsKey('token')) {
        token = data['token']?.toString() ?? '';
      }
      if (data.containsKey('user') && data['user'] is Map) {
        userMap = Map<String, dynamic>.from(data['user']);
      }
      if (userMap == null && data.containsKey('data')) {
        final d = data['data'];
        if (d is Map && d.containsKey('user') && d['user'] is Map) {
          userMap = Map<String, dynamic>.from(d['user']);
          if (token.isEmpty && d.containsKey('token')) {
            token = d['token']?.toString() ?? '';
          }
        } else if (d is Map) {
          userMap = Map<String, dynamic>.from(d);
          if (token.isEmpty && d.containsKey('token')) {
            token = d['token']?.toString() ?? '';
          }
        }
      }

      if (userMap == null && data.isNotEmpty && 
          (data.containsKey('id') || data.containsKey('email'))) {
        userMap = Map<String, dynamic>.from(data);
      }

      if (userMap == null) {
        throw Exception("Response tidak berisi data user. Body: ${response.body}");
      }

      if (token.isEmpty && userMap.containsKey('token')) {
        token = userMap['token']?.toString() ?? '';
      }

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      if (token.isNotEmpty) await prefs.setString('token', token);
      await prefs.setString('userName', 
        userMap['name']?.toString() ?? userMap['full_name']?.toString() ?? '');
      await prefs.setString('userEmail', userMap['email']?.toString() ?? '');

      final user = User.fromJson(userMap, token);
      return user;

    } catch (e) {
      print("ERROR LOGIN: $e");
      rethrow;
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    final uri = Uri.parse("$baseUrl/auth/reset-password");
    final response = await http.post(uri, headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
    }, body: {
      "email": email,
      "password": newPassword,
      "password_confirmation": newPassword,
    });

    print("RESET BODY: ${response.body}");
    final Map<String, dynamic> data = response.body.isNotEmpty 
      ? jsonDecode(response.body) : {};
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? data['error'] ?? 'Reset failed');
    }
  }
}