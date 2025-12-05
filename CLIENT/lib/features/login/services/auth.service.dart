import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // <--- PENTING: IKI KUDU ENEK
import '../models/user_model.dart';
import '../../../utils/api.dart';

class AuthService {
  final String baseUrl = Api.baseUrl;

  // Ganti return type dadi Map ben UI iso nangkep token e ugo (opsional, tapi luwih fleksibel)
  // Utawa tetep User? koyo kodinganmu sakdurunge yo rapopo, tapi pastike UI ne menyesuaikan.
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
      // Nyimpen Token & Nama neng HP
      SharedPreferences prefs = await SharedPreferences.getInstance();
     final user = data['user'] ?? {};

    await prefs.setString('token', data['token'] ?? '');
    await prefs.setString('userName', user['name'] ?? '');
    await prefs.setString('userEmail', user['email'] ?? '');
    await prefs.setString('role', user['role'] ?? '');

      // Nyimpen role ugo (penting nggo bedakne Admin/Employee neng UI)
      if (data['user']['role'] != null) {
          await prefs.setString('role', data['user']['role']);
      }

      // Mbalekne data utuh ben UI iso nggawe logic redirect
      return data; 
    } else {
      throw data['message'];
    }
  }

  // ✅ RESET PASSWORD
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