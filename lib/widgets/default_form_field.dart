// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class DefaultFormField extends StatelessWidget {
   DefaultFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.prefix,
    required this.validator,
    this.keyboardType,
    this.onTap
  }) : super(key: key);
  final TextEditingController controller;
  final String labelText;
  final IconData prefix;
  final FormFieldValidator<String> validator;
  final TextInputType? keyboardType;
  void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefix),
          border: const OutlineInputBorder()),
    );
  }
}
