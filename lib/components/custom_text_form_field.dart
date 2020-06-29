import "package:flutter/material.dart";

class CustomTextFormFieldWidget extends StatefulWidget {
  CustomTextFormFieldWidget(
      {Key key,
      this.hintText,
      this.icon,
      this.validator,
      this.type,
      this.obscureText = false,
      this.maxLines = 1,
      this.readonly = false,
      this.autofocus = false,
      this.onSaved})
      : super(key: key);

  final String hintText;
  final Icon icon;
  final String Function(String) validator;
  final TextInputType type;
  final bool obscureText;
  final int maxLines;
  final bool readonly;
  final bool autofocus;
  final void Function(String) onSaved;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      readOnly: widget.readonly,
      maxLines: widget.maxLines,
      autocorrect: true,
      enableSuggestions: true,
      keyboardType: widget.type,
      obscureText: widget.obscureText,
      autofocus: widget.autofocus,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.icon.icon,
          color: Colors.white,
        ),
        focusColor: Theme.of(context).primaryColor,
        border: InputBorder.none,
        filled: false,
        hintStyle: new TextStyle(color: Colors.grey[600]),
        hintText: widget.hintText,
        fillColor: Colors.white70,
      ),
      textAlign: TextAlign.left,
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
