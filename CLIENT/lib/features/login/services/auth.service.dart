import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../../utils/api.dart';
import '../../../utils/token_storage.dart';


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
    // 🔥 Simpan token Sanctum
    final token = data['token'];

    // simpan token ke local storage
    await TokenStorage.saveToken(token);


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
  Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) return;

  final url = Uri.parse('$baseUrl/logout');

  await http.post(
    url,
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    },
  );

  prefs.remove('token');
}

}
