import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../business_logic/user_details_logic.dart';
import '../../../firebase/database_service.dart';
import '../../../models/user_database.dart';
import '../../reusable_widgets/button.dart';
import '../../reusable_widgets/padding.dart';
import '../../reusable_widgets/text.dart';
import '../../reusable_widgets/text_field.dart';
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
