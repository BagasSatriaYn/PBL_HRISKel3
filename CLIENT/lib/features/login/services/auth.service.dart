import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/api.dart';

class AuthService {
  final String baseUrl = Api.baseUrl;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'email': email,
        'password': password, 
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final user = data['user'] ?? {};

      // ✅ SAVE DATA DARI RESPONSE BACKEND
      await prefs.setString('token', data['token'] ?? '');
      await prefs.setString('userName', user['full_name'] ?? '');
      await prefs.setString('userEmail', user['email'] ?? '');
      await prefs.setInt(
        'is_admin',
        user['is_admin'] == null
            ? 0
            : int.parse(user['is_admin'].toString()),
      );

      return data;

    } else {
      throw data['message'];
    }
  }


  // ===========================================
  // RESET PASSWORD
  // ===========================================
  Future<void> resetPassword(String email, String password) async {
    final url = Uri.parse('$baseUrl/reset-password');

    final response = await http.post(
      url,
      headers: { "Content-Type": "application/json" },
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
