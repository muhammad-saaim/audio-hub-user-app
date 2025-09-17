import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/login_controller.dart';
import 'forget_password_page.dart';
import 'register_page.dart';
import 'main_screen.dart' as main_page;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    final loginCtrl = Get.find<LoginController>();
    rememberMe = loginCtrl.rememberMe;
  }

  @override
  Widget build(BuildContext context) {
    final loginCtrl = Get.find<LoginController>();

    return Scaffold(
      body: Obx(() {
        // Show loader while checking remembered user
        if (loginCtrl.isCheckingRememberMe.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.email),
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.lock),
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value!;
                          });
                          loginCtrl.toggleRememberMe(value!);
                        },
                      ),
                      const Text('Remember Me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => const ForgetPasswordPage()),
                    child: const Text('Forgot Password?',
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Attempt login
                  await loginCtrl.login(emailCtrl.text.trim(),
                      passwordCtrl.text.trim());

                  // After login check if user is valid and email verified
                  final currentUser = loginCtrl.auth.currentUser;
                  if (currentUser != null && currentUser.emailVerified) {
                    // Save rememberMe preference
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('rememberMe', rememberMe);

                    // Navigate to MainScreen
                    Get.offAll(() => main_page.MainScreen());
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Get.to(() => const RegisterPage()),
                child: const Text('Register new account'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
