import "package:flutter/material.dart";

class CustomTextFormFieldWidget extends StatefulWidget {
  CustomTextFormFieldWidget(
      {Key key,
      this.hintText,
      this.icon,
      this.validator,
      this.type,
      this.obscureText = false,
      this.onSaved})
      : super(key: key);

  final String hintText;
  final Icon icon;
  final String Function(String) validator;
  final TextInputType type;
  final bool obscureText;
  final void Function(String) onSaved;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.type,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        icon: widget.icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        hintStyle: new TextStyle(color: Colors.grey[800]),
        hintText: widget.hintText,
        fillColor: Colors.white70,
      ),
      textAlign: TextAlign.center,
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
