import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../business_logic/my_profile_logic.dart';
import '../../../business_logic/user_details_logic.dart';
import '../../../utils/firebase/authentication_service.dart';
import '../../../utils/firebase/database_service.dart';
import '../../../utils/firebase/firebase_service.dart';
import '../../../utils/models/exercise.dart';
import '../../../utils/models/history_workout.dart';
import '../../../utils/models/user_database.dart';
import '../../../utils/models/weight_tracker.dart';
import '../../../utils/models/workout_template.dart';
import '../../widgets/button.dart';
import '../../widgets/gauge_chart.dart';
import '../../widgets/padding.dart';
import '../../widgets/sliver_top_bar.dart';
import '../../widgets/text.dart';

const double expandedHeight = 50;
const double toolbarHeight = 35;

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key, required this.callback}) : super(key: key);
  final void Function(int) callback;

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late ScrollController _scrollController;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  bool get _showBigLeftTitle {
    return _scrollController.hasClients && _scrollController.offset > expandedHeight - toolbarHeight;
  }

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationService authenticationService = Provider.of<AuthenticationService>(context);
    final List<HistoryWorkout> historyWorkouts = Provider.of<List<HistoryWorkout>>(context);
    final DatabaseService databaseService = Provider.of<DatabaseService>(context);
    final WeightTracker weightTracker = Provider.of<WeightTracker>(context);
    final List<WorkoutTemplate> templates = Provider.of<List<WorkoutTemplate>>(context);
    final List<Exercise> exercises = Provider.of<List<Exercise>>(context);
    final UserDB user = Provider.of<UserDB>(context);
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverTopBar(
              expandedHeight: expandedHeight,
              toolbarHeight: toolbarHeight,
              textExpanded: 'Profile',
              textToolbar: 'Profile',
              showBigTitle: _showBigLeftTitle),
          SliverToBoxAdapter(
            child: PaddingWidget(
              type: 'all',
              all: screenSize.width / 50,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: PaddingWidget(
                    type: 'only',
                    onlyLeft: screenSize.width / 20,
                    onlyTop: screenSize.height / 50,
                    onlyBottom: screenSize.height / 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            TextWidget(
                              text: 'Hello, ${user.name ?? ''}!',
                              fontSize: screenSize.height / 40,
                              weight: FontWeight.bold,
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String? errorHeight;
                                    String? errorSurname;
                                    String? errorName;
                                    String? errorAge;
                                    return StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          alignment: Alignment.topCenter,
                                          title: const TextWidget(
                                              text: 'Edit profile', weight: FontWeight.bold, fontSize: 23),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              children: <Widget>[
                                                PaddingWidget(
                                                  type: 'symmetric',
                                                  vertical: screenSize.height / 100,
                                                ),
                                                PaddingWidget(
                                                  type: 'only',
                                                  onlyTop: 10,
                                                  child: TextFormField(
                                                    controller: nameController,
                                                    maxLength: 15,
                                                    decoration: InputDecoration(
                                                      border: const OutlineInputBorder(),
                                                      label: Text('Name: ${user.name}'),
                                                      errorText: errorName,
                                                    ),
                                                  ),
                                                ),
                                                PaddingWidget(
                                                  type: 'symmetric',
                                                  vertical: screenSize.height / 100,
                                                ),
                                                TextField(
                                                  controller: surnameController,
                                                  maxLength: 15,
                                                  decoration: InputDecoration(
                                                    border: const OutlineInputBorder(),
                                                    label: Text('Surname: ${user.surname}'),
                                                    errorText: errorSurname,
                                                  ),
                                                ),
                                                PaddingWidget(
                                                  type: 'symmetric',
                                                  vertical: screenSize.height / 100,
                                                ),
                                                TextField(
                                                  controller: heightController,
                                                  maxLength: 4,
                                                  decoration: InputDecoration(
                                                    border: const OutlineInputBorder(),
                                                    label: Text('Height(cm): ${user.height}'),
                                                    errorText: errorHeight,
                                                  ),
                                                ),
                                                PaddingWidget(
                                                  type: 'symmetric',
                                                  vertical: screenSize.height / 100,
                                                ),
                                                TextField(
                                                  controller: ageController,
                                                  maxLength: 3,
                                                  decoration: InputDecoration(
                                                    border: const OutlineInputBorder(),
                                                    label: Text('Age(years): ${user.age}'),
                                                    errorText: errorAge,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actionsAlignment: MainAxisAlignment.center,
                                          actions: <Widget>[
                                            ButtonWidget(
                                              onPressed: () {
                                                setState(() {
                                                  nameController.clear();
                                                  surnameController.clear();
                                                  heightController.clear();
                                                  ageController.clear();
                                                });
                                                Navigator.pop(context);
                                              },
                                              text: const Text('Cancel'),
                                              primaryColor: Colors.redAccent,
                                            ),
                                            ButtonWidget(
                                                onPressed: () {
                                                  setState(() {
                                                    errorName = firstNameVerify(nameController.text);
                                                    errorSurname = secondNameVerify(surnameController.text);
                                                    errorHeight = heightVerify(heightController.text);
                                                    errorAge = ageVerify(ageController.text);
                                                  });
                                                  if (errorName == null &&
                                                      errorSurname == null &&
                                                      errorHeight == null &&
                                                      errorAge == null) {
                                                    final UserDB newUser = UserDB(
                                                        user.uid,
                                                        user.email,
                                                        false,
                                                        nameController.text != '' ? nameController.text : user.name,
                                                        surnameController.text != ''
                                                            ? surnameController.text
                                                            : user.surname,
                                                        ageController.text != ''
                                                            ? int.tryParse(ageController.text)
                                                            : user.age,
                                                        user.weight,
                                                        heightController.text != ''
                                                            ? double.tryParse(heightController.text)
                                                            : user.height,
                                                        user.weightType);
                                                    setState(() {
                                                      user.changeName(newUser.name!);
                                                      user.changeAge(newUser.age!);
                                                      user.changeSurname(newUser.surname!);
                                                      user.changeHeight(newUser.height!);
                                                    });
                                                    databaseService.createUserWithFullDetails(
                                                        newUser.uid,
                                                        newUser.email,
                                                        newUser.name!,
                                                        newUser.surname!,
                                                        newUser.age!,
                                                        newUser.weight!,
                                                        newUser.height!,
                                                        newUser.weightType!,
                                                        FirebaseService());
                                                    widget.callback(2);
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                text: const Text('Save')),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                              icon: const Icon(FontAwesomeIcons.gear),
                              color: Colors.green,
                            )
                          ],
                        ),
                        TextWidget(
                          text:
                              'total workouts: ${historyWorkouts.length.toString() != '0' ? historyWorkouts.length.toString() : 'no workouts performed'}',
                          fontSize: screenSize.height / 50,
                          weight: FontWeight.w100,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    )),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: PaddingWidget(
                    type: 'only',
                    onlyLeft: screenSize.width / 20,
                    onlyTop: screenSize.height / 50,
                    onlyBottom: screenSize.height / 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextWidget(
                          text: 'Update Your Weight',
                          fontSize: screenSize.height / 45,
                          weight: FontWeight.bold,
                        ),
                        PaddingWidget(
                          type: 'symmetric',
                          vertical: screenSize.height / 200,
                        ),
                        TextWidget(
                          text:
                              'Last date recorded: ${weightTracker.dates.last.day}.${weightTracker.dates.last.month}.${weightTracker.dates.last.year}',
                          fontSize: screenSize.height / 55,
                          weight: FontWeight.w100,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        TextWidget(
                          text:
                              'Last weight recorded: ${weightTracker.weights.last} ${user.weightType.toString().replaceAll('WeightMetric.', '')}',
                          fontSize: screenSize.height / 55,
                          weight: FontWeight.w100,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        if ((DateTime.now().day == weightTracker.dates.last.day) &&
                            (DateTime.now().month == weightTracker.dates.last.month) &&
                            (DateTime.now().year == weightTracker.dates.last.year))
                          PaddingWidget(
                            type: 'only',
                            onlyTop: screenSize.height / 100,
                            child: TextWidget(
                              text:
                                  "Today's weight check:  ${weightTracker.weights.last}  ${user.weightType.toString().replaceAll('WeightMetric.', '')}",
                              fontSize: screenSize.height / 50,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        else
                          Row(
                            children: <Widget>[
                              TextWidget(
                                text: "Today's weight check:",
                                fontSize: screenSize.height / 50,
                              ),
                              const Spacer(),
                              SizedBox(
                                width: screenSize.width / 5,
                                height: screenSize.height / 25,
                                child: TextField(
                                  maxLength: 6,
                                  controller: weightController,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    label: TextWidget(
                                      text: 'Weight',
                                      fontSize: screenSize.width / 35,
                                    ),
                                    counterText: '',
                                  ),
                                ),
                              ),
                              TextWidget(
                                text: '  ${user.weightType.toString().replaceAll('WeightMetric.', '')}',
                                fontSize: screenSize.height / 50,
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    final double? weight = double.tryParse(weightController.text.replaceAll(',', '.'));
                                    if (weight != null) {
                                      if (user.weightType == WeightMetric.KG && weight <= 250 && weight >= 40) {
                                        setState(() {
                                          weightTracker.weights.add(weight);
                                          weightTracker.dates.add(DateTime.now());
                                          databaseService.updateTracker(weightTracker, FirebaseService());
                                          user.changeWeight(weight);
                                        });
                                      } else if (user.weightType == WeightMetric.LBS && weight <= 500 && weight >= 80) {
                                        setState(() {
                                          weightTracker.weights.add(weight);
                                          weightTracker.dates.add(DateTime.now());
                                          databaseService.updateTracker(weightTracker, FirebaseService());
                                          user.changeWeight(weight);
                                        });
                                      }
                                    }
                                  },
                                  icon: const Icon(FontAwesomeIcons.circleCheck)),
                            ],
                          ),
                      ],
                    ))),
          )),
          SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: PaddingWidget(
                          type: 'only',
                          onlyLeft: screenSize.width / 20,
                          onlyTop: screenSize.height / 50,
                          onlyBottom: screenSize.height / 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextWidget(
                                text: 'B.M.I. Index',
                                fontSize: screenSize.height / 45,
                                weight: FontWeight.bold,
                              ),
                              TextWidget(
                                text: 'Body Mass Index',
                                fontSize: screenSize.height / 55,
                                weight: FontWeight.w100,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              SizedBox(
                                width: screenSize.width / 1,
                                height: screenSize.height / 3,
                                child: Align(
                                  child: GaugeChart(
                                    valueToPoint: calculateBMI(user.weight!, user.weightType!, user.height!),
                                  ),
                                ),
                              ),
                              Align(
                                child: TextWidget(
                                  text:
                                      'Your B.M.I. is ${calculateBMI(user.weight!, user.weightType!, user.height!).truncateToDouble()} which is ${determineBMIRange(calculateBMI(user.weight!, user.weightType!, user.height!).truncateToDouble())}',
                                  fontSize: screenSize.height / 50,
                                  fontStyle: FontStyle.italic,
                                  align: TextAlign.center,
                                ),
                              ),
                            ],
                          ))))),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ButtonWidget(
                text: const Text('Find nearest Gym'),
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Container(),
                      );
                    }),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ButtonWidget(
                text: const Text('Delete your account'),
                onPressed: () {
                  setState(() {
                    databaseService.deleteAnUserAndCascade(
                        user, weightTracker, historyWorkouts, templates, exercises, FirebaseService());

                    /// TO DO - Throws error
                    databaseService.deleteAnUser(FirebaseService(), user.uid);
                    authenticationService.signOutFromFirebase();
                  });
                },
                primaryColor: Colors.redAccent[400],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
