import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {

  bool hidePass = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: hidePass,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        prefixIcon: const Icon(
          Icons.lock,
          color: Color(0xFF424242)
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: Color(0xFF424242)
          ),
          onPressed: () {
            setState(() {
              hidePass = !hidePass;
            });
          },
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: 16.0)
      )
    );
  }
}