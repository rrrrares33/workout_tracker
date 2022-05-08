import 'package:flutter/material.dart';

import 'text.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        const CircularProgressIndicator(),
        const SizedBox(
          height: 50,
        ),
        TextWidget(
          text: text,
          align: TextAlign.center,
        ),
      ]),
    ));
  }
}
