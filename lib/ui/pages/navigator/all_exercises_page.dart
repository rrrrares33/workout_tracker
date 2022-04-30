import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../business_logic/all_exercises_logic.dart';
import '../../../utils/firebase/database_service.dart';
import '../../../utils/firebase/firebase_service.dart';
import '../../../utils/models/current_workout.dart';
import '../../../utils/models/editing_template.dart';
import '../../../utils/models/exercise.dart';
import '../../../utils/models/exercise_set.dart';
import '../../../utils/models/user_database.dart';
import '../../text/all_exercises_text.dart';
import '../../widgets/add_new_exercise_alert.dart';
import '../../widgets/dropdown_button.dart';
import '../../widgets/exercise_full.dart';
import '../../widgets/exercise_small.dart';
import '../../widgets/no_exercise_found.dart';
import '../../widgets/padding.dart';
import '../../widgets/sliver_top_bar.dart';

const double expandedHeight = 50;
const double toolbarHeight = 25;

class AllExercisesPage extends StatefulWidget {
  const AllExercisesPage({Key? key, required this.callback}) : super(key: key);
  final void Function(int) callback;

  @override
  State<AllExercisesPage> createState() => _AllExercisesPageState();
}

class _AllExercisesPageState extends State<AllExercisesPage> {
  late ScrollController _scrollController;
  String _chosenValueBodyPart = defaultBodyPart;
  String _chosenValueCategory = defaultCategory;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _newTitleController = TextEditingController();
  final TextEditingController _newDescriptionController = TextEditingController();

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
    final DatabaseService databaseService = Provider.of<DatabaseService>(context);
    final List<Exercise> exercisesProvider = Provider.of<List<Exercise>>(context);
    final EditingTemplate editingTemplate = Provider.of<EditingTemplate>(context);
    final CurrentWorkout currentWorkout = Provider.of<CurrentWorkout>(context);
    final UserDB user = Provider.of<UserDB>(context);
    final Size screenSize = MediaQuery.of(context).size;

    List<Exercise>? exerciseList = exercisesProvider;
    exerciseList
        .sort((Exercise a, Exercise b) => removeCategoryFromName(a.name).compareTo(removeCategoryFromName(b.name)));
    exerciseList = filterResults(exerciseList, _chosenValueCategory, _chosenValueBodyPart, _searchController.text);

    return Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverTopBar(
                expandedHeight: expandedHeight,
                toolbarHeight: toolbarHeight,
                textExpanded: topSliverText,
                textToolbar: topSliverText,
                leading: Container(),
                showBigTitle: _showBigLeftTitle),
            SliverAppBar(
              elevation: 0,
              toolbarHeight: 100,
              primary: false,
              pinned: true,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Column(
                children: <Widget>[
                  PaddingWidget(
                    type: 'only',
                    onlyTop: 10,
                    child: SizedBox(
                        height: screenSize.height / 22.5,
                        width: screenSize.width * 0.95,
                        child: CupertinoTextField(
                          controller: _searchController,
                          onChanged: (_) {
                            setState(() {
                              _scrollController.jumpTo(_scrollController.position.minScrollExtent + 26);
                            });
                          },
                          keyboardType: TextInputType.text,
                          placeholder: placeHolderSearchBar,
                          prefix: Padding(
                            padding: const EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
                            child: Icon(
                              Icons.search,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: const Color(0xffF0F1F5),
                          ),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          suffix: PaddingWidget(
                            type: 'all',
                            all: 5,
                            child: GestureDetector(
                              child: _searchController.text != ''
                                  ? const Icon(FontAwesomeIcons.solidCircleXmark, color: Colors.grey)
                                  : Container(),
                              onTap: () {
                                setState(() {
                                  _searchController.clear();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                });
                              },
                            ),
                          ),
                        )),
                  ),
                  Center(
                    child: PaddingWidget(
                      type: 'symmetric',
                      vertical: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DropDownButtonWidget(
                            defaultValue: defaultBodyPart,
                            currentValue: _chosenValueBodyPart,
                            width: screenSize.width / 3,
                            height: screenSize.height / 27.5,
                            items: bodyPart,
                            bolt: true,
                            onChanged: (String? value) {
                              setState(() {
                                _chosenValueBodyPart = value!;
                                _scrollController.jumpTo(_scrollController.position.minScrollExtent + 26);
                              });
                            },
                          ),
                          PaddingWidget(type: 'symmetric', horizontal: screenSize.width / 10 / 2),
                          DropDownButtonWidget(
                            defaultValue: defaultCategory,
                            currentValue: _chosenValueCategory,
                            width: screenSize.width / 3,
                            height: screenSize.height / 27.5,
                            items: category,
                            bolt: true,
                            onChanged: (String? value) {
                              setState(() {
                                _chosenValueCategory = value!;
                                _scrollController.jumpTo(_scrollController.position.minScrollExtent + 26);
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Slidable(
                  enabled: currentWorkout.startTime != null || (editingTemplate.currentlyEditing ?? false),
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    extentRatio: 0.2,
                    openThreshold: 0.1,
                    children: <Widget>[
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          setState(() {
                            if (currentWorkout.startTime != null) {
                              ScaffoldMessenger.of(context).showSnackBar(newExerciseAddedToWorkout);
                              if (exerciseList![index].category == 'Time') {
                                currentWorkout.exercises.add(ExerciseSetDuration(exerciseList[index]));
                              } else if (exerciseList[index].category == 'Assisted Bodyweight') {
                                currentWorkout.exercises.add(ExerciseSetMinusWeight(exerciseList[index]));
                              } else {
                                currentWorkout.exercises.add(ExerciseSetWeight(exerciseList[index]));
                              }
                            } else if (editingTemplate.currentlyEditing ?? false) {
                              ScaffoldMessenger.of(context).showSnackBar(newExerciseAddedToTemplate);
                              if (exerciseList![index].category == 'Time') {
                                editingTemplate.exercises.add(ExerciseSetDuration(exerciseList[index]));
                              } else if (exerciseList[index].category == 'Assisted Bodyweight') {
                                editingTemplate.exercises.add(ExerciseSetMinusWeight(exerciseList[index]));
                              } else {
                                editingTemplate.exercises.add(ExerciseSetWeight(exerciseList[index]));
                              }
                              editingTemplate.exercises[editingTemplate.exercises.length - 1].sets
                                  .add(<TextEditingController>[TextEditingController(text: '1')]);
                            }
                            widget.callback(2);
                          });
                        },
                        foregroundColor: Colors.greenAccent[400],
                        icon: FontAwesomeIcons.circlePlus,
                        label: 'Add',
                      ),
                    ],
                  ),
                  child: ExerciseSmallShow(
                    image: (exerciseList?[index].icon)!,
                    name: (exerciseList?[index].name)!,
                    bodyPart: (exerciseList?[index].bodyPart)!,
                    category: exerciseList?[index].category,
                    imageWidth: screenSize.width / 6,
                    imageHeight: screenSize.width / 6,
                    onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => ExerciseFull(
                        image: (exerciseList?[index].biggerImage)!,
                        name: (exerciseList?[index].name)!,
                        bodyPart: (exerciseList?[index].bodyPart)!,
                        category: exerciseList?[index].category,
                        description: exerciseList?[index].description,
                        onPressedDeleteExercise: (String nameOfExercise) {
                          final int? indexToDelete = exerciseList?.indexWhere((Exercise element) =>
                              element.name == nameOfExercise && element.whoCreatedThisExercise != 'system');
                          setState(() {
                            if (indexToDelete != null) {
                              databaseService.deleteAnExercise(
                                  FirebaseService(), exerciseList?[indexToDelete].id ?? '');
                            }
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
              childCount: exerciseList.length,
            )),
            SliverToBoxAdapter(
                child: exerciseList.isEmpty
                    ? SizedBox(
                        height: screenSize.height / 2,
                        width: screenSize.width,
                        child: NoExerciseFound(
                          iconSize: screenSize.height / 10,
                        ))
                    : null),
          ],
        ),
        floatingActionButton: AddANewExerciseWidget(
          width: screenSize.width,
          newDescriptionController: _newDescriptionController,
          newTitleController: _newTitleController,
          formKey: _formKey,
          height: screenSize.height,
          userUid: user.uid,
          databaseService: databaseService,
          localExerciseList: exercisesProvider,
        ));
  }
}
