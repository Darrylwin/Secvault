import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:secvault/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secvault/features/auth/presentation/bloc/auth_event.dart';
import 'package:secvault/features/auth/presentation/bloc/auth_state.dart';
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

  final ScrollController _scrollController = ScrollController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();

  bool agreed = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onFocusChange);
    _confirmPasswordFocusNode.addListener(_onFocusChange);
    _nameFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _emailFocusNode.dispose();
    _nameFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        if (_scrollController.hasClients) {
          // Ajouter un espace supplémentaire pour s'assurer que le champ est visible
          final offset = _scrollController.position.maxScrollExtent + 150;
          _scrollController.animateTo(
            offset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
        }
      },
    );
  }

  void agreeTermsAndConditions(bool? value) {
    setState(() {
      agreed = value ?? false;
    });
  }

  void Function()? _onregisterPressed() {
    if (!agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must agree to the terms.")),
      );
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match.")),
      );
    }

    context.read<AuthBloc>().add(
          RegisterRequested(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            // name: nameController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFAFAFAFF),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.of(context).pushReplacementNamed('/home');
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failureMessage),
                ),
              );
            }
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
                child: IntrinsicHeight(
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
                            focusNode: _nameFocusNode,
                          ),
                          const SizedBox(height: 15),
                          MyTextField(
                            obscureText: false,
                            hintText: "Valid email",
                            controller: emailController,
                            icon: Icons.mail_outline_rounded,
                            focusNode: _emailFocusNode,
                          ),
                          const SizedBox(height: 15),
                          MyTextField(
                            obscureText: true,
                            hintText: "Strong password",
                            controller: passwordController,
                            icon: Icons.lock_outline,
                            focusNode: _passwordFocusNode,
                          ),
                          const SizedBox(height: 15),
                          MyTextField(
                            obscureText: true,
                            hintText: "Confirm password",
                            controller: confirmPasswordController,
                            icon: Icons.lock_outline,
                            focusNode: _confirmPasswordFocusNode,
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
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Do you agree with our ",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: "Terms and Conditions ?",
                                      style: TextStyle(
                                        color: Color(0xFFFD3951),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: _onregisterPressed,
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
                                  Navigator.of(context).pushReplacementNamed(
                                      '/login'); // Navigate to login page
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
            ),
          ),
        ),
      ),
    );
  }
}
