import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginCtrl = Get.find<LoginController>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(35),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: loginCtrl.registerNameCtrl,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: loginCtrl.registerEmailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: loginCtrl.registerNumberCtrl,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: loginCtrl.registerPasswordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 20),

              // Checkbox with Obx
              Obx(() => Row(
                children: [
                  Checkbox(
                    value: loginCtrl.agree.value,
                    onChanged: (val) => loginCtrl.agree.value = val ?? false,
                  ),
                  const Expanded(
                    child: Text('I agree to the terms and conditions'),
                  ),
                ],
              )),
              const SizedBox(height: 20),

              // Create Account button
              Obx(() => ElevatedButton(
                onPressed: loginCtrl.agree.value
                    ? () async {
                  await loginCtrl.addUser();
                }
                    : null, // disabled when unchecked
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.deepPurple,
                  disabledBackgroundColor: Colors.grey, // show disabled state
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(color: Colors.white),
                ),
              )),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.to(() => const LoginPage()),
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
