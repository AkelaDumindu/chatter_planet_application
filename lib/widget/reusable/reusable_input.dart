import 'package:chatter_planet_application/utilz/colors.dart';
import 'package:flutter/material.dart';

class ReusableInput extends StatelessWidget {
  final TextEditingController controller;
  final String lableText;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? valiator;
  const ReusableInput(
      {super.key,
      required this.controller,
      required this.lableText,
      required this.icon,
      required this.obscureText,
      this.valiator});

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(10),
    );
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: borderStyle,
        focusedBorder: borderStyle,
        enabledBorder: borderStyle,
        labelText: lableText,
        labelStyle: TextStyle(color: mainWhiteColor),
        filled: true,
        prefixIcon: Icon(
          icon,
          color: mainWhiteColor,
          size: 20,
        ),
      ),
      obscureText: obscureText,
      validator: valiator,
    );
  }
}
