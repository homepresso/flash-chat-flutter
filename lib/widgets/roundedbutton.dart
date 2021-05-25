  import 'package:flutter/material.dart';

  class RoundedButton extends StatelessWidget {

  // ignore: non_constant_identifier_names
  RoundedButton({@required this.Color, @required this.text, @required this.onPressed});

  // ignore: non_constant_identifier_names
  final Color;
  final text;
  final Function onPressed;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: Color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}

