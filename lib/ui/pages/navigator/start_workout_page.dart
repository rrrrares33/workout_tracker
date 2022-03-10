import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

import '../../../utils/models/current_workout.dart';
import '../../reusable_widgets/button.dart';
import '../../reusable_widgets/padding.dart';
import '../../reusable_widgets/sliver_top_bar.dart';
import '../../reusable_widgets/text.dart';
import '../../reusable_widgets/timer_alert.dart';
import '../../text/start_workout_text.dart';

const double expandedHeight = 50;
const double toolbarHeight = 25;

class StartWorkoutPage extends StatefulWidget {
  const StartWorkoutPage({Key? key}) : super(key: key);

  @override
  State<StartWorkoutPage> createState() => _StartWorkoutPageState();
}

class _StartWorkoutPageState extends State<StartWorkoutPage> {
  late ScrollController _scrollController;
  String? timerCurrentTime;

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
    final CurrentWorkout currentWorkout = Provider.of<CurrentWorkout>(context);
    final Size screenSize = MediaQuery.of(context).size;

    if (currentWorkout.startTime == null) {
      return Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverTopBar(
                expandedHeight: expandedHeight,
                toolbarHeight: toolbarHeight,
                textExpanded: 'Start Workout',
                textToolbar: 'Start Workout',
                leading: Container(),
                showBigTitle: _showBigLeftTitle),
            SliverToBoxAdapter(
              child: PaddingWidget(
                type: 'symmetric',
                vertical: screenSize.height / 50,
                horizontal: screenSize.width / 30,
                child: Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(27))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      PaddingWidget(
                        type: 'only',
                        onlyLeft: 17,
                        onlyTop: screenSize.height / 50,
                        child: TextWidget(
                          text: 'Quick Start',
                          weight: FontWeight.bold,
                          fontSize: screenSize.width / 22,
                        ),
                      ),
                      PaddingWidget(
                        type: 'symmetric',
                        horizontal: 17,
                        vertical: 13.5,
                        child: ButtonWidget(
                          text: TextWidget(
                            text: 'Begin  A  New  Empty  Workout',
                            weight: FontWeight.bold,
                            fontSize: screenSize.width / 25,
                          ),
                          primaryColor: Colors.greenAccent[400],
                          onPressed: () {
                            setState(() {
                              currentWorkout.startTime = DateTime.now();
                            });
                          },
                          minimumSize: Size.fromHeight(screenSize.height / 17.5),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Scaffold(
          body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            leadingWidth: screenSize.width / 4.5,
            leading: PaddingWidget(
              type: 'only',
              onlyBottom: 4,
              onlyTop: 4,
              onlyLeft: 8,
              child: Align(
                child: SizedBox(
                  width: 100,
                  child: Card(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                    color: Colors.greenAccent[400],
                    child: TimerWidget(
                      screenWidth: screenSize.width,
                      screenHeight: screenSize.height,
                      context: context,
                    ),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              PaddingWidget(
                type: 'all',
                all: screenSize.width / 50,
                child: ButtonWidget(
                  onPressed: () {},
                  text: TextWidget(
                    text: finishText,
                    weight: FontWeight.bold,
                    fontSize: screenSize.width / 20,
                  ),
                  minimumSize: const Size.fromRadius(5),
                  primaryColor: Colors.greenAccent[400],
                ),
              ),
            ],
          ),
        ],
      ));
    }
  }
}
