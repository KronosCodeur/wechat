import 'package:flutter/material.dart';

void showSnackbar(
    BuildContext context, String text, TextStyle style, Color color) {
  final snackbar = SnackBar(
    content: Text(text, style: style),
    backgroundColor: color,
    duration: Duration(seconds: 3),
    dismissDirection: DismissDirection.down,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
