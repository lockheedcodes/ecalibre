import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  const MyTextfield(
      {super.key,
      required this.textValueController,
      required this.hintText,
      required this.labelText,
      required this.fieldIcon});

  final TextEditingController textValueController;
  final String hintText;
  final String labelText;
  final Icon fieldIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textValueController,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.black, width: 1.8)),
          iconColor: Colors.black,
          labelStyle: TextStyle(color: Colors.black, fontSize: 17),
          hintText: hintText,
          labelText: labelText,
          prefixIcon: fieldIcon,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              gapPadding: 1.0,
              borderRadius: BorderRadius.all(Radius.circular(12)))),
    );
  }
}
