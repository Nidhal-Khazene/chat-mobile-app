import 'package:flutter/material.dart';

class CustomFormTextField extends StatefulWidget {
  const CustomFormTextField({
    super.key,
    this.hintText,
    this.icon,
    this.inverseIcon,
    this.onChanged,
  });
  final String? hintText;
  final IconData? icon;
  final IconData? inverseIcon;
  final Function(String)? onChanged;

  @override
  State<CustomFormTextField> createState() => _CustomFormTextFieldState();
}

class _CustomFormTextFieldState extends State<CustomFormTextField> {
  bool _isPasswordSecure = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (data) {
        if (data!.isEmpty) {
          return "Field is required.";
        }
        return null;
      },
      onChanged: widget.onChanged,
      obscureText: _isPasswordSecure,
      decoration: InputDecoration(
        suffixIcon: togglePassword(),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isPasswordSecure = !_isPasswordSecure;
        });
      },
      icon: _isPasswordSecure ? Icon(widget.icon) : Icon(widget.inverseIcon),
      color: Colors.white,
    );
  }
}
