import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  ButtonPrimary(
      {Key key,
      @required this.text,
      @required this.handlerFn,
      this.buttonColor,
      this.textColor})
      : super(key: key);

  final String text;
  final Function handlerFn;
  final Color buttonColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      child: new Text(
        this.text,
        style: TextStyle(
          // color: textColor != null ? textColor : Theme.of(context).accentColor,
        ),
      ),
      color: buttonColor != null ? buttonColor : Theme.of(context).buttonColor,
      onPressed: () {
        this.handlerFn();
      },
    );
  }
}
