import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ircell/login/auth.dart';
import 'package:ircell/login/onboarding.dart';
import 'package:ircell/screens/tabs_screen.dart';

const Color accentBlue = Colors.blueAccent; // Replace with your custom blue if needed

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  // Show popup dialog with error
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Okay!',
              style: TextStyle(color: accentBlue),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        showErrorDialog('Email and password cannot be empty');
        return;
      }
      await Auth().signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      showErrorDialog(e.message ?? 'Login failed');
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      if (passwordController.text != confirmPasswordController.text) {
        showErrorDialog('Passwords do not match');
        return;
      }
      if (passwordController.text.length < 6) {
        showErrorDialog('Password must be at least 6 characters');
        return;
      }
      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(emailController.text)) {
        showErrorDialog('Invalid email format');
        return;
      }
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        showErrorDialog('Email and password cannot be empty');
        return;
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Onboarding(
              email: emailController.text,
              password: passwordController.text,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      showErrorDialog(e.message ?? 'Registration failed');
    }
  }

  Widget title() {
    return const Text('Login Page');
  }

  Widget emailField() {
    return TextField(
      controller: emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget passwordField() {
    return TextField(
      controller: passwordController,
      obscureText: !showPassword,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
        ),
      ),
    );
  }

  Widget confirmPasswordField() {
    return Visibility(
      visible: !isLogin,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: TextField(
          controller: confirmPasswordController,
          obscureText: !showConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                  showConfirmPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  showConfirmPassword = !showConfirmPassword;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
          passwordController.clear();
          confirmPasswordController.clear();
          showPassword = false;
          showConfirmPassword = false;
        });
      },
      child: Text(
        isLogin ? 'Create an account' : 'Already have an account?',
        style: TextStyle(color: accentBlue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title(),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                emailField(),
                const SizedBox(height: 20),
                passwordField(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TabsScreen(),
                      ),
                    );
                  },
                  child: const Text('Temp Login'),
                ),
                confirmPasswordField(),
                const SizedBox(height: 20),
                submitButton(),
                const SizedBox(height: 20),
                loginOrRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
