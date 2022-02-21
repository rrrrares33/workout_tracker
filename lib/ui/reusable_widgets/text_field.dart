import 'package:flutter/material.dart';

import '../../utils/models/user_database.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget(
      {Key? key,
      required this.controller,
      required this.labelText,
      this.errorText,
      this.onChangedCustom,
      this.onChangedWeight,
      this.borderType,
      this.contentPadding,
      this.validationREGEX,
      this.weightMetric,
      this.keyboardType,
      this.onChanged,
      this.autoCorrect,
      this.enableSuggestions,
      this.obscureText,
      this.suffixIcon})
      : super(key: key);
  final TextEditingController controller;
  final Function(String?)? onChangedCustom;
  final bool? autoCorrect;
  final bool? enableSuggestions;
  final bool? obscureText;
  final void Function(String?)? onChanged;
  final String labelText;
  final String? errorText;
  final Function(String?, WeightMetric?)? onChangedWeight;
  final InputBorder? borderType;
  final EdgeInsetsGeometry? contentPadding;
  final RegExp? validationREGEX;
  final WeightMetric? weightMetric;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  @override
  TextFieldWidgetState createState() => TextFieldWidgetState();
}

class TextFieldWidgetState extends State<TextFieldWidget> {
  String? generatedError;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: widget.autoCorrect ?? true,
      enableSuggestions: widget.enableSuggestions ?? true,
      obscureText: widget.obscureText ?? false,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged ??
          (_) {
            if (widget.onChangedCustom != null) {
              setState(() {
                generatedError = null;
                if (widget.weightMetric == null) {
                  generatedError = widget.onChangedCustom!(widget.controller.text) as String?;
                }
              });
              // Any text-field, except the one for weight,
              //  will get into this.
            } else {
              setState(() {
                generatedError = null;
                generatedError = widget.onChangedWeight!(widget.controller.text, widget.weightMetric) as String?;
              });
            }
          },
      decoration: InputDecoration(
        contentPadding: widget.contentPadding ?? const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: widget.borderType ?? const UnderlineInputBorder(),
        labelText: widget.labelText,
        errorText: widget.errorText == null
            ? generatedError
            : widget.onChangedWeight!(widget.controller.text, widget.weightMetric) as String?,
        suffixIcon: widget.suffixIcon,
      ),
    );
  }
}
