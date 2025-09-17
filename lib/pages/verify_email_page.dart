import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailPage extends StatelessWidget {
  final String email;

  const VerifyEmailPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "A verification email has been sent to:",
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              email,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.currentUser?.reload();
                if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
                  Get.snackbar("Success", "Email verified!");
                  Get.offAllNamed('/login'); // back to login after verification
                } else {
                  Get.snackbar("Pending", "Please verify your email first");
                }
              },
              child: const Text("I have verified"),
            ),
          ],
        ),
      ),
    );
  }
}
