import 'package:flutter/material.dart';

class ProfileTopSection extends StatelessWidget {
  final String name;
  final String email;

  const ProfileTopSection({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 30,
        child: Icon(Icons.person, size: 30),
      ),
      title: Text(
        name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(email),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          // TODO: Edit profile logic
        },
      ),
    );
  }
}
