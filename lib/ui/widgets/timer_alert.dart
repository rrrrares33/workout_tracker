import 'dart:async';
import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../business_logic/workout_logic.dart';
import '../../utils/models/current_workout.dart';
import '../text/start_workout_text.dart';
import 'button.dart';
import 'padding.dart';
import 'text.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.context,
  }) : super(key: key);
  final double screenWidth;
  final double screenHeight;
  final BuildContext context;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  // We need to avoid rebuilding the timer on scroll (later rebuilds inside the same page)
  //  So we keep track of the first rebuild and start the timer forced only on it
  bool? firstBuild;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CurrentWorkout currentWorkout = Provider.of<CurrentWorkout>(widget.context);

    void runTimer({bool buildCall = false}) {
      const Duration oneSec = Duration(seconds: 1, microseconds: 10);
      // If this is not a build call, we get the remaining time.
      if (!buildCall) {
        currentWorkout.currentTimeInSeconds = convertTimeToSeconds(currentWorkout.timerController.getTime());
      } else if (currentWorkout.currentTimeInSeconds != 0) {
        // If it is not a build call (moving between pages for example), we need to rebuild the timer
        if (DateTime.now().second - currentWorkout.lastDecrementForTimer.second >= 1) {
          currentWorkout.currentTimeInSeconds -= DateTime.now().second - currentWorkout.lastDecrementForTimer.second;
          currentWorkout.currentTimeInSeconds = max(0, currentWorkout.currentTimeInSeconds);
        }
      }
      // If a timer is already running we need to cancel it before starting a new one.
      if (currentWorkout.timer?.isActive == true) {
        currentWorkout.timer?.cancel();
      }
      // If there is still time that needs to pass, we start the timer with the remaining time.
      if (currentWorkout.currentTimeInSeconds != 0) {
        currentWorkout.timer = Timer.periodic(oneSec, (Timer timer) {
          if (currentWorkout.currentTimeInSeconds == 0) {
            setState(() {
              currentWorkout.timer?.cancel();
            });
          } else {
            setState(() {
              currentWorkout.lastDecrementForTimer = DateTime.now();
              currentWorkout.currentTimeInSeconds -= 1;
            });
          }
        });
      }
    }

    if (firstBuild == null) {
      runTimer(buildCall: true);
      firstBuild = false;
    }

    return SizedBox(
      height: 100,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () => showDialog<Widget>(
            context: context,
            builder: (BuildContext context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) => AlertDialog(
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                      contentPadding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
                      title: TextWidget(
                        text: timerName,
                        weight: FontWeight.bold,
                        fontSize: widget.screenWidth / 15,
                      ),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: currentWorkout.currentTimeInSeconds != 0
                          ? <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ButtonWidget(
                                      onPressed: () {
                                        setState(() {
                                          if (currentWorkout.timer?.isActive == true) {
                                            currentWorkout.currentTimeInSeconds += 10;
                                          }
                                          currentWorkout.timerController.restart(
                                              duration:
                                                  convertTimeToSeconds(currentWorkout.timerController.getTime()) + 10);
                                        });
                                      },
                                      text: TextWidget(
                                        text: increment10Sec,
                                        fontSize: widget.screenWidth / 20,
                                      )),
                                  PaddingWidget(
                                    type: 'symmetric',
                                    horizontal: widget.screenWidth / 30,
                                    child: ButtonWidget(
                                        onPressed: () {
                                          setState(() {
                                            if (currentWorkout.timer?.isActive == true) {
                                              currentWorkout.currentTimeInSeconds += 30;
                                            }
                                            currentWorkout.timerController.restart(
                                                duration:
                                                    convertTimeToSeconds(currentWorkout.timerController.getTime()) +
                                                        30);
                                          });
                                        },
                                        text: TextWidget(
                                          text: increment30Sec,
                                          fontSize: widget.screenWidth / 20,
                                        )),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ButtonWidget(
                                    onPressed: () {
                                      setState(() {
                                        currentWorkout.timerController.restart(
                                            duration:
                                                convertTimeToSeconds(currentWorkout.timerController.getTime()) - 10 > 0
                                                    ? convertTimeToSeconds(currentWorkout.timerController.getTime()) -
                                                        10
                                                    : 0);
                                        if (currentWorkout.currentTimeInSeconds > 10) {
                                          currentWorkout.currentTimeInSeconds -= 10;
                                        } else {
                                          currentWorkout.currentTimeInSeconds = 0;
                                        }
                                      });
                                    },
                                    text: TextWidget(
                                      text: decrement10Sec,
                                      fontSize: widget.screenWidth / 20,
                                    ),
                                    primaryColor: Colors.redAccent,
                                  ),
                                  PaddingWidget(
                                    type: 'symmetric',
                                    horizontal: widget.screenWidth / 30,
                                    child: ButtonWidget(
                                      onPressed: () {
                                        setState(() {
                                          currentWorkout.timerController.restart(
                                              duration: convertTimeToSeconds(currentWorkout.timerController.getTime()) -
                                                          30 >
                                                      0
                                                  ? convertTimeToSeconds(currentWorkout.timerController.getTime()) - 30
                                                  : 0);
                                          if (currentWorkout.currentTimeInSeconds > 30) {
                                            currentWorkout.currentTimeInSeconds -= 30;
                                          } else {
                                            currentWorkout.currentTimeInSeconds = 0;
                                          }
                                        });
                                      },
                                      text: TextWidget(
                                        text: decrement30Sec,
                                        fontSize: widget.screenWidth / 20,
                                      ),
                                      primaryColor: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ]
                          : <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  PaddingWidget(
                                    onlyTop: 15,
                                    onlyBottom: 10,
                                    type: 'only',
                                    child: TextWidget(
                                      text: pickYourTime,
                                      fontSize: widget.screenWidth / 20,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ButtonWidget(
                                      onPressed: () {
                                        setState(() {
                                          if (currentWorkout.timer?.isActive == true) {
                                            currentWorkout.currentTimeInSeconds += 60;
                                          }
                                          currentWorkout.timerController.restart(
                                              duration:
                                                  convertTimeToSeconds(currentWorkout.timerController.getTime()) + 60);
                                        });
                                      },
                                      text: TextWidget(
                                        text: oneMinute,
                                        fontSize: widget.screenWidth / 20,
                                      )),
                                  PaddingWidget(
                                    type: 'symmetric',
                                    horizontal: 15,
                                    child: ButtonWidget(
                                        onPressed: () {
                                          setState(() {
                                            if (currentWorkout.timer?.isActive == true) {
                                              currentWorkout.currentTimeInSeconds += 120;
                                            }
                                            currentWorkout.timerController.restart(
                                                duration:
                                                    convertTimeToSeconds(currentWorkout.timerController.getTime()) +
                                                        120);
                                          });
                                        },
                                        text: TextWidget(
                                          text: twoMinutes,
                                          fontSize: widget.screenWidth / 20,
                                        )),
                                  ),
                                  ButtonWidget(
                                      onPressed: () {
                                        setState(() {
                                          if (currentWorkout.timer?.isActive == true) {
                                            currentWorkout.currentTimeInSeconds += 180;
                                          }
                                          currentWorkout.timerController.restart(
                                              duration:
                                                  convertTimeToSeconds(currentWorkout.timerController.getTime()) + 180);
                                        });
                                      },
                                      text: TextWidget(
                                        text: threeMinutes,
                                        fontSize: widget.screenWidth / 20,
                                      )),
                                ],
                              ),
                            ],
                      content: PaddingWidget(
                        type: 'only',
                        onlyTop: 10,
                        onlyLeft: 10,
                        onlyRight: 10,
                        child: CircularCountDownTimer(
                          controller: currentWorkout.timerController,
                          textStyle: TextStyle(
                            fontSize: widget.screenWidth / 10,
                            fontWeight: FontWeight.bold,
                          ),
                          onComplete: () {
                            Navigator.pop(context);
                          },
                          onStart: () {
                            if (currentWorkout.currentTimeInSeconds == 0) {
                              runTimer();
                            }
                          },
                          height: widget.screenHeight / 3,
                          duration: currentWorkout.currentTimeInSeconds,
                          fillColor: Colors.grey,
                          ringColor: Colors.greenAccent[400] ?? Colors.green,
                          isReverse: true,
                          isReverseAnimation: true,
                          strokeWidth: 30,
                          width: widget.screenWidth / 1.5,
                          autoStart: currentWorkout.currentTimeInSeconds != 0,
                        ),
                      ),
                    ))),
        icon: currentWorkout.currentTimeInSeconds != 0
            ? Align(
                child: TextWidget(
                text: getPrintableTimer(currentWorkout.currentTimeInSeconds.toString()),
                color: Colors.white,
                fontSize: widget.screenWidth / 20,
                weight: FontWeight.bold,
              ))
            : const Icon(Icons.av_timer_rounded, size: 35),
      ),
    );
  }
}
