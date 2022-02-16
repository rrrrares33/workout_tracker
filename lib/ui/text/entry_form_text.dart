import 'package:flutter/material.dart';

// General text
const String appBarTitle = 'Details required for metrics';
const String submitButtonText = 'Start your journey to a smarter workout';
const SnackBar formFilled = SnackBar(content: Text('You have successfully completed the metrics for your new account'));

// Labels text const
String firstNameLabel = 'First name';
const String secondNameLabel = 'Second name';
const String ageLabel = 'Age';
const String heightLabel = 'Height (cm)';
const String weightLabel = 'Weight';
const String metricKG = 'KG';
const String metricLBS = 'LBS';

// Error messages text
const String firstNameErrorText = 'This name is invalid';
const String secondNameErrorText = 'This name is invalid';
const String ageErrorText = 'Age is invalid';
const String heightErrorText = 'Height is invalid';
const String weightErrorText = 'Weight is invalid';

// Regex for validating first name and second name
final RegExp nameRegex = RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$");
