import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'padding.dart';
import 'text.dart';

class DropDownButtonWidget extends StatelessWidget {
  const DropDownButtonWidget(
      {Key? key,
      required this.items,
      this.onChanged,
      this.fontSize,
      this.bolt,
      required this.width,
      required this.height,
      required this.currentValue,
      required this.defaultValue})
      : super(key: key);
  final List<String> items;
  final String currentValue;
  final String defaultValue;
  final void Function(String?)? onChanged;
  final double width;
  final double height;
  final double? fontSize;
  final bool? bolt;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: currentValue == defaultValue ? const Color(0xffF0F1F5) : Colors.greenAccent[400],
        ),
        child: PaddingWidget(
            type: 'all',
            all: 5,
            child: DropdownButton2<String>(
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(
                      child: TextWidget(
                    text: value,
                    fontSize: fontSize ?? 12,
                    weight: (bolt ?? false) ? FontWeight.bold : FontWeight.normal,
                  )),
                );
              }).toList(),
              value: currentValue,
              onChanged: onChanged,
              underline: Container(),
              alignment: AlignmentDirectional.center,
              buttonWidth: width,
              buttonHeight: height,
              iconSize: 0.0,
              isExpanded: true,
              isDense: true,
            )));
  }
}
