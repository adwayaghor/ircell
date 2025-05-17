import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ircell/login/auth.dart';

class Page4 extends StatelessWidget {
  Page4({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    try {
      await Auth().signOut();
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Widget title() {
    return const Text('Home Page');
  }

  Widget userUID() {
    return Text(user?.email ?? 'User email');
  }

  Widget signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page 4')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [userUID(), const SizedBox(height: 20), signOutButton()],
        ),
      ),
    );
  }
}
