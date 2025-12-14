import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  const OutlinedText(
    this.text, {
    super.key,
    this.fontSize = 12,
    this.fillColor = Colors.white,
    this.outlineColor = Colors.black,
    this.outlineWidth = 2,
  });

  final String text;
  final double fontSize;
  final Color fillColor;
  final Color outlineColor;
  final double outlineWidth;

  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(fontSize: fontSize, fontWeight: .bold);
    return Stack(
      children: [
        Text(
          text,
          style: _style.copyWith(
            foreground: Paint()
              ..style = .stroke
              ..strokeWidth = outlineWidth
              ..color = outlineColor,
          ),
        ),
        Text(text, style: _style.copyWith(color: fillColor)),
      ],
    );
  }
}
