import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:secvault/features/auth/presentation/widgets/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool agreed = false;

  void agreeTermsAndConditions(bool? value) {
    setState(() {
      agreed = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFAFAFAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/images/undraw_adventure_map.svg",
                      width: 100,
                      height: 100,
                    ),
                    const Text(
                      "Get started",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Let's create a free account",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  MyTextField(
                    obscureText: false,
                    hintText: "Full name",
                    controller: nameController,
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    obscureText: false,
                    hintText: "Valid email",
                    controller: emailController,
                    icon: Icons.mail_outline_rounded,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    obscureText: true,
                    hintText: "Strong password",
                    controller: passwordController,
                    icon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    obscureText: true,
                    hintText: "Confirm password",
                    controller: confirmPasswordController,
                    icon: Icons.lock_outline,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: agreed,
                        onChanged: agreeTermsAndConditions,
                        checkColor: const Color(0xFFFD3951),
                        activeColor: Colors.transparent,
                      ),
                      Text(
                        "Do you agree our Terms and Conditions ?",
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('/home'); // Navigate to home page
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFD3951),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.white,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already a member? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/login'); // Navigate to login page
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                            color: Color(0xFFFD3951),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
