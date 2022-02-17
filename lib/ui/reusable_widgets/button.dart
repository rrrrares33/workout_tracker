import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({Key? key, required this.onPressed, required this.child, this.primaryColor, this.minimumSize}) : super(key: key);

  final void Function()? onPressed;
  final Widget child;
  final Color? primaryColor;
  final Size? minimumSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          minimumSize: minimumSize,
          primary: primaryColor,
        ),
        onPressed: onPressed,
        child: child
    );
  }
}
