import 'package:audio_hub_client/controller/login_controller.dart';
import 'package:audio_hub_client/controller/home_controller.dart';
import 'package:audio_hub_client/controller/cart_controller.dart';
import 'package:audio_hub_client/controller/navigation_controller.dart';
import 'package:audio_hub_client/pages/register_page.dart';
import 'package:audio_hub_client/pages/login_page.dart';
import 'package:audio_hub_client/pages/splash_page.dart';
import 'package:audio_hub_client/pages/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);

  // Global controllers - make them permanent to preserve state
  Get.put<LoginController>(LoginController(), permanent: true);
  Get.put<HomeController>(HomeController(), permanent: true);
  Get.put<CartController>(CartController(), permanent: true);
  Get.put<NavigationController>(NavigationController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Audio Hub Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/home', page: () => MainScreen()),
      ],
    );
  }
}
