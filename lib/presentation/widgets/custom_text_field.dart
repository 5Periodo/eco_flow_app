import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObscure;
  final bool? obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isObscure    = false,
    this.obscureText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveObscureText = obscureText ?? isObscure;

    return TextFormField(
      controller:  controller,
      obscureText: effectiveObscureText,
      style:       const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText:       hintText,
        hintStyle:      const TextStyle(color: Colors.white24, fontSize: 14),
        filled:         true,
        fillColor:      const Color(0xFF0A2E2A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide.none,
        ),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, color: Colors.white54),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}