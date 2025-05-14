import 'package:flutter/material.dart';
import 'package:secvault/features/auth/presentation/widgets/my_text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFAFAFAFF),
      body: Center(
        child: Column(
          children: [
            Image.asset("assets/images/undraw_adventure_map.png"),
            const SizedBox(height: 20),
            MyTextField(
              obscureText: false,
              hintText: "Enter your email",
              controller: emailController,
              icon: Icons.mail_outline_rounded,
            ),
            const SizedBox(height: 20),
            MyTextField(
              obscureText: true,
              hintText: "Password",
              controller: passwordController,
              icon: Icons.lock_outline,
            ),
          ],
        ),
      ),
    );
  }
}
