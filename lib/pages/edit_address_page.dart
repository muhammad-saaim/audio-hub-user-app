import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({super.key});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final LoginController loginCtrl = Get.find();
  final TextEditingController addressCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    addressCtrl.text = loginCtrl.userAddress.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Address"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: addressCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Your Address",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Save Address",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () async {
                  if (addressCtrl.text.trim().isEmpty) {
                    Get.snackbar("Error", "Address cannot be empty");
                    return;
                  }

                  await loginCtrl.updateAddress(addressCtrl.text.trim());

                  Get.snackbar(
                    "Success",
                    "Address updated successfully ✅",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  Navigator.pop(context); // Back to Profile Page
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
