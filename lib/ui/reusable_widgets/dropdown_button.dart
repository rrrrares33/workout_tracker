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
      required this.defaultValue,
      this.iconSize,
      this.align})
      : super(key: key);
  final List<String> items;
  final String currentValue;
  final String defaultValue;
  final void Function(String?)? onChanged;
  final double width;
  final double height;
  final double? fontSize;
  final bool? bolt;
  final double? iconSize;
  final Alignment? align;

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
                    color: Theme.of(context).primaryColor,
                  )),
                );
              }).toList(),
              value: currentValue,
              onChanged: onChanged,
              underline: Container(),
              alignment: align ?? AlignmentDirectional.center,
              buttonWidth: width,
              buttonHeight: height,
              dropdownDecoration: const BoxDecoration(
                color: Colors.white,
              ),
              iconSize: iconSize ?? 0.0,
              isExpanded: true,
              isDense: true,
            )));
  }
}
