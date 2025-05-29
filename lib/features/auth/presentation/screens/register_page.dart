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
                      "Welcome to Secvault",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 5),
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
              // const SizedBox(height: 20),
              Column(
                children: [
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
                  // const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
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
                ],
              ),
              // const Spacer(),
              Column(
                children: [
                  Container(
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
                  const SizedBox(height: 15),
                  Center(
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "New member? ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          TextSpan(
                            text: "Register now",
                            style: TextStyle(
                              color: Color(0xFFFD3951),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
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
