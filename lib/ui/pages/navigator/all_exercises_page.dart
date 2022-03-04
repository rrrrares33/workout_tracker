import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../business_logic/all_exercises_logic.dart';
import '../../../utils/firebase/database_service.dart';
import '../../../utils/models/exercise.dart';
import '../../../utils/models/user_database.dart';
import '../../reusable_widgets/dropdown_button.dart';
import '../../reusable_widgets/exercise_full.dart';
import '../../reusable_widgets/exercise_small.dart';
import '../../reusable_widgets/loading.dart';
import '../../reusable_widgets/padding.dart';
import '../../reusable_widgets/sliver_top_bar.dart';
import '../../text/all_exercises_text.dart';

const double expandedHeight = 50;
const double toolbarHeight = 25;

class AllExercisesPage extends StatefulWidget {
  const AllExercisesPage({Key? key, required this.user}) : super(key: key);
  final UserDB user;

  @override
  State<AllExercisesPage> createState() => _AllExercisesPageState();
}

class _AllExercisesPageState extends State<AllExercisesPage> {
  late ScrollController _scrollController;
  String _chosenValueBodyPart = defaultBodyPart;
  String _chosenValueCategory = defaultCategory;
  final TextEditingController _searchController = TextEditingController();

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
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: FutureBuilder<List<Exercise>>(
          future: databaseService.getAllExercisesFromDatabaseForUser(widget.user.uid),
          builder: (BuildContext context, AsyncSnapshot<List<Exercise>> snapshot) {
            if (snapshot.hasData) {
              List<Exercise>? exerciseList = snapshot.data;
              exerciseList?.sort(
                  (Exercise a, Exercise b) => removeCategoryFromName(a.name).compareTo(removeCategoryFromName(b.name)));
              exerciseList = filterResults(
                  exerciseList ?? <Exercise>[], _chosenValueCategory, _chosenValueBodyPart, _searchController.text);
              return CustomScrollView(
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
                    toolbarHeight: 115,
                    primary: false,
                    pinned: true,
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    title: Column(
                      children: <Widget>[
                        PaddingWidget(
                          type: 'only',
                          onlyTop: 20,
                          child: SizedBox(
                              height: screenSize.height / 22.5,
                              width: screenSize.width * 0.95,
                              child: CupertinoTextField(
                                controller: _searchController,
                                onChanged: (_) {
                                  setState(() {});
                                },
                                keyboardType: TextInputType.text,
                                placeholder: placeHolderSearchBar,
                                prefix: const Padding(
                                  padding: EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
                                  child: Icon(
                                    Icons.search,
                                    color: Color(0xffC4C6CC),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: const Color(0xffF0F1F5),
                                ),
                                suffix: PaddingWidget(
                                  type: 'all',
                                  all: 5,
                                  child: GestureDetector(
                                    child: _searchController.text != ''
                                        ? const Icon(FontAwesomeIcons.solidTimesCircle, color: Colors.grey)
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
                      return ExerciseSmallShow(
                        image: (exerciseList?[index].icon)!,
                        name: (exerciseList?[index].name)!,
                        bodyPart: (exerciseList?[index].bodyPart)!,
                        category: exerciseList?[index].category,
                        imageWidth: screenSize.width / 6,
                        imageHeight: screenSize.width / 6,
                        onTap: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => ExerciseFull(
                            image: (exerciseList?[index].icon)!,
                            name: (exerciseList?[index].name)!,
                            bodyPart: (exerciseList?[index].bodyPart)!,
                            category: exerciseList?[index].category,
                            description: exerciseList?[index].description,
                          ),
                        ),
                      );
                    },
                    childCount: exerciseList.length,
                  ))
                ],
              );
            } else {
              return const Center(
                child: LoadingWidget(),
              );
            }
          }),
    );
  }
}
