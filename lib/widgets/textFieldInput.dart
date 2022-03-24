import 'package:flutter/material.dart';
import 'package:flutter_svg/avd.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput(
      {Key? key,
      required this.hintText,
      required this.controller,
      required this.keyboardType,
      this.isPass = false})
      : super(key: key);

  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPass;

  @override
  Widget build(BuildContext context) {
    final inputBorderDecoration =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorderDecoration,
        focusedBorder: inputBorderDecoration,
        enabledBorder: inputBorderDecoration,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: keyboardType,
      obscureText: isPass,
    );
  } 
}
