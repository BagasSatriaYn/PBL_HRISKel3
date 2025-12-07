import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth.service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final AuthService authService = AuthService();

  bool loading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: newPasswordController,
              obscuringCharacter: '*',
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password Baru"),
            ),

            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        setState(() {
                          loading = true;
                          errorMessage = null;
                        });

                        // VALIDASI BIAR GA NULL
                        if (emailController.text.isEmpty ||
                            newPasswordController.text.isEmpty) {
                          setState(() {
                            loading = false;
                            errorMessage = "Email dan password tidak boleh kosong.";
                          });
                          return;
                        }

                        try {
                          await authService.resetPassword(
                            emailController.text,
                            newPasswordController.text,
                          );

                          if (!mounted) return;

                          context.go('/login');

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Password berhasil diubah")),
                          );
                        } catch (e) {
                          setState(() {
                            errorMessage = e.toString();
                          });
                        } finally {
                          setState(() => loading = false);
                        }
                      },
                child: const Text("SIMPAN PASSWORD BARU"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
