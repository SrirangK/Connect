import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final controller;
  final hinttext;
  final obscuretext;
  final labelTexT;
  const MyTextfield({Key? key, this.controller, this.hinttext, this.obscuretext, this.labelTexT}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscuretext,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(10)
          ),
          hintText: hinttext,
          labelText: labelTexT,
        ),
    );
  }
}
