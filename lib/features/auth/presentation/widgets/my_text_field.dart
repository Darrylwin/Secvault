import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  MyTextField({
    super.key,
    required this.obscureText,
    required this.hintText,
    required this.controller,
    required this.icon,
    required this.focusNode,
  });

  final TextEditingController controller;
  bool obscureText;
  final String hintText;
  final IconData icon;
  FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: Icon(
          icon,
          color: Colors.grey.shade400,
          size: 24.0,
        ),
        filled: true,
        fillColor: const Color(0xffefefef),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      focusNode: focusNode,
    );
  }
}
