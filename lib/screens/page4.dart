import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ircell/login/auth.dart';
import 'package:ircell/app_theme.dart'; 

class Page4 extends StatelessWidget {
  Page4({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        contentTextStyle: Theme.of(context).textTheme.bodyLarge,
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await Auth().signOut();
      } on FirebaseAuthException catch (e) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppTheme.cardColor,
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            contentTextStyle: Theme.of(context).textTheme.bodyLarge,
            title: const Text('Error'),
            content: Text(e.message ?? 'An error occurred'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it!'),
              ),
            ],
          ),
        );
      }
    }
  }

  Widget userUID(BuildContext context) {
    return Text(
      user?.email ?? 'User email',
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => signOut(context),
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 4'),
      ),
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: Center(
          child: Container(
            decoration: AppTheme.cardDecoration,
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                userUID(context),
                const SizedBox(height: 20),
                signOutButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
