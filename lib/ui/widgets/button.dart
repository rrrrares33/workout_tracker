import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.primaryColor,
      this.minimumSize,
      this.icon,
      this.fontSize})
      : super(key: key);

  final void Function()? onPressed;
  final Widget text;
  final Color? primaryColor;
  final Size? minimumSize;
  final Widget? icon;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            minimumSize: minimumSize,
            primary: primaryColor,
            textStyle: TextStyle(
              fontSize: fontSize,
            ),
          ),
          onPressed: onPressed,
          child: text);
    }
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        minimumSize: minimumSize,
        primary: primaryColor,
        textStyle: TextStyle(
          fontSize: fontSize,
        ),
      ),
      onPressed: onPressed,
      icon: icon!,
      label: text,
    );
  }
}
