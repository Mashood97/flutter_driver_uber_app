import 'package:flutter/material.dart';

class UserTextField extends StatelessWidget {
  final titleLabel;
  final maxLength;
  final icon;
  final controller;
  final inputType;
  final Function fieldSubmit;
  final focusnode;
  final validator;
  final inputAction;

  UserTextField(
      {@required this.titleLabel,
      @required this.maxLength,
      @required this.icon,
      @required this.validator,
      @required this.controller,
      @required this.inputAction,
      this.focusnode,
      this.fieldSubmit,
      @required this.inputType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        maxLength: maxLength,
        controller: controller,
        keyboardType: inputType,
        validator: validator,
        textInputAction: inputAction,
        onFieldSubmitted: fieldSubmit,
        focusNode: focusnode,
        decoration: InputDecoration(
          labelText: titleLabel,
          suffixIcon: Icon(
            icon,
            color: Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
