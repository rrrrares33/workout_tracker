import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'padding.dart';
import 'text.dart';

class InfoIcon extends StatelessWidget {
  const InfoIcon({Key? key, required this.text, required this.screenSize}) : super(key: key);
  final String text;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: PaddingWidget(
                    type: 'symmetric',
                    horizontal: screenSize.width / 20,
                    vertical: screenSize.height / 20,
                    child: TextWidget(
                      text: text,
                      align: TextAlign.start,
                    )),
              ),
            ),
        splashRadius: 0.1,
        padding: EdgeInsets.zero,
        icon: const Icon(FontAwesomeIcons.circleInfo));
  }
}
