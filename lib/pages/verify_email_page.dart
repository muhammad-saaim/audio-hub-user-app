import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'success_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;
  const VerifyEmailPage({super.key, required this.email});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    checkEmailVerification();
  }

  Future<void> checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    if (user != null && user.emailVerified) {
      setState(() {
        isEmailVerified = true;
      });
      Get.off(() => const SuccessPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Verify your email address', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Text(widget.email, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text('Please check your email and click the verification link.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await checkEmailVerification();
                },
                child: const Text('Continue'),
              ),
              TextButton(
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  Get.snackbar('Email Sent', 'Verification email resent.');
                },
                child: const Text('Resend Email', style: TextStyle(color: Colors.blue)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
