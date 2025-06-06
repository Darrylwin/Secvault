import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:secvault/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secvault/features/auth/presentation/bloc/auth_event.dart';
import 'package:secvault/features/auth/presentation/bloc/auth_state.dart';
import 'package:secvault/features/auth/presentation/widgets/my_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
        }
      },
    );
  }

  bool remember = false;

  void rememberMe(bool? value) {
    setState(() {
      remember = value ?? false;
    });
  }

  void Function()? _onLoginPressed() {
    context.read<AuthBloc>().add(
          LoginRequested(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
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
                SnackBar(content: Text(state.failureMessage)),
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
                              "Welcome back",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Sign in to access your account",
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
                            hintText: "Enter your email",
                            controller: emailController,
                            icon: Icons.mail_outline_rounded,
                            focusNode: _emailFocusNode,
                          ),
                          const SizedBox(height: 20),
                          MyTextField(
                            obscureText: true,
                            hintText: "Password",
                            controller: passwordController,
                            icon: Icons.lock_outline,
                            focusNode: _passwordFocusNode,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: remember,
                                    onChanged: rememberMe,
                                    checkColor: const Color(0xFFFD3951),
                                    activeColor: Colors.transparent,
                                  ),
                                  Text(
                                    "Remember me",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                "Forgot password ?",
                                style: TextStyle(
                                  color: Color(0xFFFD3951),
                                  fontSize: 14,
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
                            onTap: _onLoginPressed,
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
                                "New member? ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      '/register'); // Navigate to register page
                                },
                                child: const Text(
                                  "Register now",
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
