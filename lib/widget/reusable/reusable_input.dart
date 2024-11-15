import 'package:chatter_planet_application/utilz/colors.dart';
import 'package:flutter/material.dart';

class ReusableInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?) validator;

  const ReusableInput({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.obscureText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(8),
    );
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: mainWhiteColor,
        ),
        filled: true,
        prefixIcon: Icon(
          icon,
          color: mainWhiteColor,
          size: 20,
        ),
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }
}
