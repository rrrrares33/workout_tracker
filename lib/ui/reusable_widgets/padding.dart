import 'package:flutter/material.dart';

class PaddingWidget extends StatelessWidget {
  const PaddingWidget(
      {Key? key,
      required this.type,
      this.onlyTop,
      this.onlyBottom,
      this.onlyLeft,
      this.onlyRight,
      this.horizontal,
      this.vertical,
      this.all,
      this.child})
      : super(key: key);
  final String type;
  final double? onlyTop;
  final double? onlyBottom;
  final double? onlyLeft;
  final double? onlyRight;
  final double? horizontal;
  final double? vertical;
  final double? all;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (type == 'only') {
      return Padding(
        padding: EdgeInsets.only(
            top: onlyTop ?? 0.0, bottom: onlyBottom ?? 0.0, right: onlyRight ?? 0.0, left: onlyLeft ?? 0.0),
        child: child,
      );
    } else if (type == 'symmetric') {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal ?? 0.0, vertical: vertical ?? 0.0),
        child: child,
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(all ?? 0.0),
        child: child,
      );
    }
  }
}
