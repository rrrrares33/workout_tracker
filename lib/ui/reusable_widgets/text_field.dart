import 'package:flutter/material.dart';

import '../../models/user_database.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget(
      {Key? key,
      required this.controller,
      required this.labelText,
      this.errorText,
      this.onChanged,
      this.onChangedWeight,
      this.borderType,
      this.contentPadding,
      this.validationREGEX,
      this.weightMetric})
      : super(key: key);
  final TextEditingController controller;
  final String labelText;
  final String? errorText;
  final Function(String?)? onChanged;
  final Function(String?, WeightMetric?)? onChangedWeight;
  final InputBorder? borderType;
  final EdgeInsetsGeometry? contentPadding;
  final RegExp? validationREGEX;
  final WeightMetric? weightMetric;

  @override
  TextFieldWidgetState createState() => TextFieldWidgetState();
}

class TextFieldWidgetState extends State<TextFieldWidget> {
  String? generatedError;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: (_) {
        if (widget.onChanged != null) {
          setState(() {
            generatedError = null;
            if (widget.weightMetric == null) {
              generatedError = widget.onChanged!(widget.controller.text) as String?;
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
      ),
    );
  }
}
