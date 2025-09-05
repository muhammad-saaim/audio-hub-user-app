import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';
import 'cart_page.dart';
import 'edit_profile_page.dart';
import 'orders_page.dart';
import 'edit_address_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final LoginController loginCtrl = Get.find(); // Controller inject

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        loginCtrl.userName.value,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      const SizedBox(height: 4),
                      Obx(() => Text(
                        loginCtrl.userEmail.value,
                        style: const TextStyle(color: Colors.black54),
                      )),
                      const SizedBox(height: 4),
                      Obx(() => Text(
                        loginCtrl.userPhone.value,
                        style: const TextStyle(color: Colors.black54),
                      )),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.deepPurple),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Address Section
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text("Address"),
            subtitle: Obx(() => Text(
              loginCtrl.userAddress.value.isEmpty
                  ? "No address added"
                  : loginCtrl.userAddress.value,
              style: const TextStyle(color: Colors.black54),
            )),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.deepPurple),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditAddressPage(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Menu Options
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text("My Cart"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_bag),
                  title: const Text("My Orders"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrdersPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () async {
                    await loginCtrl.logout(); // ✅ Fully functional logout
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
