import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({Key? key, this.color, this.fontSize, this.fontStyle, this.align, this.text}) : super(key: key);
  final String? text;
  final Color? color;
  final double? fontSize;
  final FontStyle? fontStyle;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      textAlign: align ?? TextAlign.center,
      style: TextStyle(
        color: color ?? Colors.black,
        fontSize: fontSize ?? 14.0,
        fontStyle: fontStyle ?? FontStyle.normal,
      ),
    );
  }
}
