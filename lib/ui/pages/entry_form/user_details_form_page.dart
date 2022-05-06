import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../business_logic/user_details_logic.dart';
import '../../../utils/firebase/database_service.dart';
import '../../../utils/firebase/firebase_service.dart';
import '../../../utils/models/user_database.dart';
import '../../text/entry_form_text.dart';
import '../../widgets/button.dart';
import '../../widgets/padding.dart';
import '../../widgets/text.dart';
import '../../widgets/text_field.dart';
import 'check_first_time_and_load_db_intermediary.dart';

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
  bool isMan = true;
  bool isWomen = false;

  // Controller for weight metric button selection.
  static WeightMetric weightMetric = WeightMetric.KG;

  // This need to be store locally in the widget too.
  //  In order to manage error from changing
  static String? weightErrorMessage;
  static String? formIsNotFilledError;

  @override
  void initState() {
    super.initState();
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
                PaddingWidget(
                  type: 'symmetric',
                  vertical: 2.0,
                  horizontal: 25.0,
                  child: TextFieldWidget(
                    controller: firstNameController,
                    labelText: firstNameLabel,
                    onChangedCustom: firstNameVerify,
                  ),
                ),
                PaddingWidget(
                  type: 'symmetric',
                  vertical: 2.0,
                  horizontal: 25.0,
                  child: TextFieldWidget(
                    controller: secondNameController,
                    labelText: secondNameLabel,
                    onChangedCustom: secondNameVerify,
                  ),
                ),
                PaddingWidget(
                  type: 'symmetric',
                  vertical: 2.0,
                  horizontal: 25.0,
                  child: TextFieldWidget(
                    controller: ageController,
                    labelText: ageLabel,
                    onChangedCustom: ageVerify,
                  ),
                ),
                PaddingWidget(
                  type: 'symmetric',
                  vertical: 2.0,
                  horizontal: 25.0,
                  child: TextFieldWidget(
                    controller: heightController,
                    labelText: heightLabel,
                    onChangedCustom: heightVerify,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: PaddingWidget(
                        type: 'only',
                        onlyLeft: 25.0,
                        child: TextFieldWidget(
                          controller: weightController,
                          labelText: weightLabel,
                          weightMetric: weightMetric,
                          onChangedWeight: weightVerify,
                          errorText: weightErrorMessage,
                        ),
                      ),
                    ),
                    PaddingWidget(
                        type: 'symmetric',
                        horizontal: 5.0,
                        child: ButtonWidget(
                          onPressed: () {
                            setState(() {
                              weightErrorMessage = null;
                              weightMetric = weightMetricButtonSwitch(weightMetric);
                              weightErrorMessage = weightVerify(weightController.text, weightMetric);
                            });
                          },
                          primaryColor: getWeightButtonColor(weightMetric, 'KG'),
                          text: const TextWidget(text: metricKG),
                        )),
                    PaddingWidget(
                        type: 'only',
                        onlyLeft: 5.0,
                        onlyRight: 40.0,
                        child: ButtonWidget(
                          onPressed: () {
                            setState(() {
                              weightErrorMessage = null;
                              weightMetric = weightMetricButtonSwitch(weightMetric);
                              weightErrorMessage = weightVerify(weightController.text, weightMetric);
                            });
                          },
                          primaryColor: getWeightButtonColor(weightMetric, 'LBS'),
                          text: const TextWidget(text: metricLBS),
                        )),
                  ],
                ),
                PaddingWidget(
                  type: 'only',
                  onlyTop: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      PaddingWidget(
                          type: 'symmetric',
                          horizontal: 5.0,
                          child: ButtonWidget(
                            onPressed: () {
                              setState(() {
                                isMan = true;
                                isWomen = false;
                              });
                            },
                            primaryColor: isMan ? Colors.greenAccent[400] : Colors.grey,
                            text: const TextWidget(text: 'Man'),
                          )),
                      PaddingWidget(
                          type: 'symmetric',
                          horizontal: 5.0,
                          child: ButtonWidget(
                            onPressed: () {
                              setState(() {
                                isMan = false;
                                isWomen = true;
                              });
                            },
                            primaryColor: isWomen ? Colors.greenAccent[400] : Colors.grey,
                            text: const TextWidget(text: 'Women'),
                          )),
                    ],
                  ),
                ),
                PaddingWidget(
                  type: 'only',
                  onlyTop: 10.0,
                  child: PaddingWidget(
                      type: 'symmetric',
                      horizontal: 25.0,
                      child: TextWidget(
                        text: formIsNotFilledError,
                        color: Colors.red,
                      )),
                ),
                Container(
                  alignment: Alignment.center,
                  child: PaddingWidget(
                    type: 'only',
                    onlyTop: 10.0,
                    onlyLeft: 20.0,
                    onlyRight: 20.0,
                    child: ButtonWidget(
                      minimumSize: const Size.fromHeight(42),
                      onPressed: () {
                        if (checkIfFilled(
                            firstNameController.text,
                            firstNameVerify(firstNameController.text),
                            secondNameController.text,
                            secondNameVerify(secondNameController.text),
                            ageController.text,
                            ageVerify(ageController.text),
                            weightController.text,
                            weightVerify(weightController.text, weightMetric),
                            heightController.text,
                            heightVerify(heightController.text))) {
                          databaseService.createUserWithFullDetails(
                            widget.loggedUserUid,
                            widget.loggedEmail,
                            firstNameController.text,
                            secondNameController.text,
                            isMan ? 'male' : 'women',
                            int.parse(ageController.text),
                            double.parse(weightController.text),
                            double.parse(heightController.text),
                            weightMetric,
                            FirebaseService(),
                          );
                          if (!mounted) return;

                          // We shall wait 2 seconds to give time for data to be written in the database.
                          sleep(const Duration(seconds: 1));
                          ScaffoldMessenger.of(context).showSnackBar(formFilled);

                          Navigator.push(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: <WidgetBuilder>(BuildContext context) => CheckFirstTimeAndLoadDB(
                                    loggedUserUid: widget.loggedUserUid, loggedEmail: widget.loggedEmail),
                              ));
                        } else {
                          setState(() {
                            formIsNotFilledError = formNotFilled;
                          });
                        }
                      },
                      text: const TextWidget(text: submitButtonText),
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
