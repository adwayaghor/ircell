import 'package:flutter/material.dart';
import 'package:ircell/login/auth.dart';
import 'package:ircell/screens/tabs_screen.dart';

class Onboarding extends StatelessWidget {
  Onboarding({super.key, required this.email, required this.password});
  final String email;
  final String password;
  final fullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await Auth().createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const TabsScreen(),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}