import 'package:flutter/material.dart';

import '../models/user_database.dart';
import '../ui/text/entry_form_text.dart';

// Regex for validating first name and second name
final RegExp nameRegex = RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$");

bool checkIfFilled(String? firstName, String? firstNameError, String? secondName, String? secondNameError, String? age,
    String? ageError, String? weight, String? weightError, String? height, String? heightError) {
  if (firstName!.isEmpty || secondName!.isEmpty || age!.isEmpty || height!.isEmpty || weight!.isEmpty) {
    return false;
  }
  if (firstNameError != null ||
      secondNameError != null ||
      ageError != null ||
      weightError != null ||
      heightError != null) {
    return false;
  }
  return true;
}

String? firstNameVerify(String? content) {
  if (content!.isEmpty || nameRegex.hasMatch(content)) {
    return null;
  }
  return firstNameErrorText;
}

String? secondNameVerify(String? content) {
  if (content!.isEmpty || nameRegex.hasMatch(content)) {
    return null;
  }
  return secondNameErrorText;
}

String? ageVerify(String? content) {
  if (content!.isEmpty) {
    return null;
  }
  final int? contentParsed = int.tryParse(content);
  if (contentParsed != null) {
    if (contentParsed < 100 && contentParsed > 14) {
      return null;
    }
  }
  return ageErrorText;
}

String? heightVerify(String? content){
  if (content!.isEmpty) {
    return null;
  }
  final int? contentParsed = int.tryParse(content);
  if (contentParsed != null) {
    if (contentParsed >= 120 && contentParsed <= 230) {
      return null;
    }
  }
  return heightErrorText;
}

Color? getWeightButtonColor(WeightMetric metric, String thisButtonMetric){
  if (metric == WeightMetric.KG && thisButtonMetric == 'KG') {
    return Colors.greenAccent[400];
  }
  if (metric == WeightMetric.LBS && thisButtonMetric == 'LBS') {
    return Colors.greenAccent[400];
  }
  return Colors.grey;
}

String? weightVerify(String? content, WeightMetric? metric) {
  if (content!.isEmpty) {
    return null;
  }
  final double? contentParsed = double.tryParse(content);
  if (contentParsed != null) {
    if (metric! == WeightMetric.KG) {
      if (contentParsed > 40 && contentParsed < 250) {
        return null;
      }
    } else {
      if (contentParsed > 80 && contentParsed < 500) {
        return null;
      }
    }
  }
  return weightErrorText;
}

WeightMetric weightMetricButtonSwitch(WeightMetric metric){
  if (metric == WeightMetric.KG) {
    return WeightMetric.LBS;
  }
  return WeightMetric.KG;
}
