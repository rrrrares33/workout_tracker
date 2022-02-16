import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../firebase/database_service.dart';
import '../../../models/user_database.dart';
import '../../text/entry_form_text.dart';
import 'check_first_time.dart';

class UserDetailsForm extends StatefulWidget {
  const UserDetailsForm({Key? key, required this.loggedUserUid, required this.loggedEmail}) : super(key: key);
  final String loggedUserUid;
  final String loggedEmail;

  @override
  State<UserDetailsForm> createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  // Controllers. (can not be set to static)
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  // Controller for weight metric button selection.
  static WeightMetric weightMetric = WeightMetric.KG;

  // Error messages. They are null when field empty or correct value entered.
  static String? firstNameErrorMessage;
  static String? secondNameErrorMessage;
  static String? ageErrorMessage;
  static String? weightErrorMessage;
  static String? heightErrorMessage;

  // Regex for validating first name and second name
  final RegExp nameRegex = RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$");

  // It checks if the form is complete and correct.
  bool checkIfFilled() {
    if (firstNameController.text.isEmpty || firstNameErrorMessage != null) {
      return false;
    }
    if (secondNameController.text.isEmpty || secondNameErrorMessage != null) {
      return false;
    }
    if (ageController.text.isEmpty || ageErrorMessage != null) {
      return false;
    }
    if (weightController.text.isEmpty || weightErrorMessage != null) {
      return false;
    }
    if (heightController.text.isEmpty || heightErrorMessage != null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Database service used to create new user at the end of this.
    final DatabaseService databaseService = Provider.of<DatabaseService>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(appBarTitle),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 25),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 25.0),
                  child: TextFormField(
                    controller: firstNameController,
                    onChanged: (_) {
                      setState(() {
                        if (firstNameController.text.isNotEmpty && nameRegex.hasMatch(firstNameController.text)) {
                          firstNameErrorMessage = null;
                        } else {
                          firstNameErrorMessage = firstNameErrorText;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: const UnderlineInputBorder(),
                      labelText: firstNameLabel,
                      errorText: firstNameErrorMessage,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 25.0),
                  child: TextFormField(
                    controller: secondNameController,
                    onChanged: (_) {
                      setState(() {
                        if (secondNameController.text.isEmpty || nameRegex.hasMatch(secondNameController.text)) {
                          secondNameErrorMessage = null;
                        } else {
                          secondNameErrorMessage = secondNameErrorText;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: const UnderlineInputBorder(),
                      labelText: secondNameLabel,
                      errorText: secondNameErrorMessage,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 25.0),
                  child: TextFormField(
                    controller: ageController,
                    onChanged: (_) {
                      setState(() {
                        if (ageController.text.isEmpty) {
                          ageErrorMessage = null;
                        } else if (int.tryParse(ageController.text) != null) {
                          if (int.tryParse(ageController.text)! < 100 && int.tryParse(ageController.text)! > 18) {
                            ageErrorMessage = null;
                          } else {
                            ageErrorMessage = ageErrorText;
                          }
                        } else {
                          ageErrorMessage = ageErrorText;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: const UnderlineInputBorder(),
                      labelText: ageLabel,
                      errorText: ageErrorMessage,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 25.0),
                  child: TextFormField(
                    controller: heightController,
                    onChanged: (_) {
                      setState(() {
                        if (heightController.text.isEmpty) {
                          heightErrorMessage = null;
                        } else {
                          if (int.tryParse(heightController.text) != null) {
                            if (int.tryParse(heightController.text)! < 120 ||
                                int.tryParse(heightController.text)! > 230) {
                              heightErrorMessage = heightErrorText;
                            } else {
                              heightErrorMessage = null;
                            }
                          } else {
                            heightErrorMessage = heightErrorText;
                          }
                        }
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: const UnderlineInputBorder(),
                      labelText: heightLabel,
                      errorText: heightErrorMessage,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: TextFormField(
                          controller: weightController,
                          onChanged: (_) {
                            setState(() {
                              if (weightController.text.isEmpty) {
                                weightErrorMessage = null;
                              } else {
                                if (double.tryParse(weightController.text) != null) {
                                  if ((double.tryParse(weightController.text)! >= 40 &&
                                          double.tryParse(weightController.text)! <= 250 &&
                                          weightMetric == WeightMetric.KG) ||
                                      (weightMetric == WeightMetric.LBS &&
                                          double.tryParse(weightController.text)! >= 80 &&
                                          double.tryParse(weightController.text)! <= 500)) {
                                    weightErrorMessage = null;
                                  } else {
                                    weightErrorMessage = weightErrorText;
                                  }
                                } else {
                                  weightErrorMessage = weightErrorText;
                                }
                              }
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: const UnderlineInputBorder(),
                            labelText: weightLabel,
                            errorText: weightErrorMessage,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          primary: weightMetric == WeightMetric.KG ? Colors.greenAccent[400] : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (weightMetric == WeightMetric.LBS) {
                              weightMetric = WeightMetric.KG;
                              if (weightController.text.isNotEmpty && weightErrorMessage == null) {
                                if (double.tryParse(weightController.text)! >= 40 &&
                                    double.tryParse(weightController.text)! <= 250 &&
                                    weightMetric == WeightMetric.KG) {
                                  weightErrorMessage = null;
                                } else {
                                  weightErrorMessage = weightErrorText;
                                }
                              }
                            }
                          });
                        },
                        child: const Text(metricKG),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 40),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          primary: weightMetric == WeightMetric.LBS ? Colors.greenAccent[400] : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (weightMetric == WeightMetric.KG) {
                              weightMetric = WeightMetric.LBS;
                              if (weightController.text.isNotEmpty && weightErrorMessage == null) {
                                if (weightMetric == WeightMetric.LBS &&
                                    double.tryParse(weightController.text)! >= 80 &&
                                    double.tryParse(weightController.text)! <= 500) {
                                  weightErrorMessage = null;
                                } else {
                                  weightErrorMessage = weightErrorText;
                                }
                              }
                            }
                          });
                        },
                        child: const Text(metricLBS),
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: const Size.fromHeight(42),
                        primary: checkIfFilled() ? Colors.greenAccent[400] : Colors.grey,
                      ),
                      onPressed: () {
                        if (checkIfFilled()) {
                          databaseService.createUserWithFullDetails(
                              widget.loggedUserUid,
                              widget.loggedEmail,
                              firstNameController.text,
                              secondNameController.text,
                              int.parse(ageController.text),
                              double.parse(weightController.text),
                              double.parse(heightController.text),
                              weightMetric);
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(formFilled);
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: <WidgetBuilder>(BuildContext context) => CheckFirstTime(
                                    loggedUserUid: widget.loggedUserUid, loggedEmail: widget.loggedEmail),
                              ));
                        }
                      },
                      child: const Text(submitButtonText),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
