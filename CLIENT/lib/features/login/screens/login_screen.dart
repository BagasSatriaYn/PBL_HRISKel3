// ui/login_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth.service.dart';
import '../models/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  bool loading = false;
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
            Color(0xFF6A11CB),
            Color(0xFF2575FC),
          ]),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.lock_person_rounded, size: 80, color: Colors.white),
                const SizedBox(height: 12),
                const Text("Sign in to Your HRIS Dashboard", style: TextStyle(fontSize: 24, color: Colors.white)),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: _inputDecoration(hint: "Email Address", icon: Icons.email_outlined),
                          validator: (v) => (v == null || v.isEmpty) ? 'Email tidak boleh kosong' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: _inputDecoration(hint: "Password", icon: Icons.lock_outline).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                            ),
                          ),
                          validator: (v) => (v == null || v.isEmpty) ? 'Password tidak boleh kosong' : null,
                        ),
                        if (errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                        ],
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: loading ? null : _doLogin,
                            child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text("LOGIN"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon}) => InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      );

  Future<void> _doLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final User user = await authService.login(emailController.text.trim(), passwordController.text);
      // user.role is int: 1 = admin, 0 = employee
      if (user.role == 1) {
        if (!mounted) return;
        context.go('/admin-dashboard');
      } else {
        if (!mounted) return;
        context.go('/employee-dashboard');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }
}
