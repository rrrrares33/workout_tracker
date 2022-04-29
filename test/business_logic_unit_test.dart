import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_tracker/business_logic/all_exercises_logic.dart';
import 'package:workout_tracker/business_logic/login_and_register_logic.dart';
import 'package:workout_tracker/business_logic/user_details_logic.dart';
import 'package:workout_tracker/business_logic/workout_history_logic.dart';
import 'package:workout_tracker/business_logic/workout_logic.dart';
import 'package:workout_tracker/ui/text/entry_form_text.dart';
import 'package:workout_tracker/utils/models/exercise.dart';
import 'package:workout_tracker/utils/models/exercise_set.dart';
import 'package:workout_tracker/utils/models/history_workout.dart';
import 'package:workout_tracker/utils/models/user_auth.dart';
import 'package:workout_tracker/utils/models/user_database.dart';

void main() {
  group('All Exercises Page Logic Tests', () {
    final List<Exercise> exerciseList = <Exercise>[];
    setUp(() {
      exerciseList.clear();
      exerciseList.addAll(<Exercise>[
        Exercise('Barbell Bench Press', '', 'system_barbellBenchPress', 'system', 'Barbell', 'Chest', '', ''),
        Exercise('Lateral Raises Bent Over Cable', '', 'system_lateralRaisesBentOverCable', 'system', 'Cable',
            'Shoulders', '', ''),
        Exercise('Upright Row Smith', '', 'system_uprightRowSmith', 'system', 'Smith', 'Shoulders', '', ''),
        Exercise('Landmine One Legged Deadlift', '', 'system_landmineOneLeggedRomanianDeadlift', 'system', 'Barbell',
            'Legs', '', ''),
        Exercise('Lounge Dumbbell', '', 'system_lungeDumbbell', 'system', 'Dumbbell', 'Legs', '', ''),
        Exercise('Overhead Rope Extension', '', 'system_overheadRopeExtension', 'system', 'Cable', 'Triceps', '', ''),
        Exercise('Overhead Barbell Extensions', '', 'system_tricepsOverheadBarbellExtensions', 'system', 'Barbell',
            'Triceps', '', ''),
        Exercise('Wrist Curl Palms Up Barbell', '', 'system_wristCurlPalmsUpBarbell', 'system', 'Barbell', 'Forearms',
            '', ''),
        Exercise(
            'Biceps Curl Dumbbell', '', 'system_standingBicepsCurlDumbbell', 'system', 'Dumbbell', 'Biceps', '', ''),
        Exercise('Side Plank Pushes', '', 'system_sidePlankPushes', 'system', 'Bodywheight', 'Core', '', ''),
        Exercise('Incline Bench Press Smith', '', 'system_inclineBenchPressSmith', 'system', 'Smith', 'Chest', '', ''),
      ]);
    });

    test(
        'GIVEN an user is on the all exercises page of the app '
        'WHEN he wants to filter the 300+ exercises by category '
        'THEN he should see only the exercises that are part of the category that he picked ', () {
      // ARRANGE
      const String bodywheightCategory = 'Bodywheight';
      const String smithCategory = 'Smith';
      const String dumbbellCategory = 'Dumbbell';
      const String barbellCategory = 'Barbell';

      // ACT
      final List<Exercise> resultForFilterOnBodywheight = filterBasedOnCategory(exerciseList, bodywheightCategory);
      final List<Exercise> resultForFilterOnSmith = filterBasedOnCategory(exerciseList, smithCategory);
      final List<Exercise> resultForFilterOnDumbbell = filterBasedOnCategory(exerciseList, dumbbellCategory);
      final List<Exercise> resultForFilterOnBarbell = filterBasedOnCategory(exerciseList, barbellCategory);

      // ASSERT
      expect(resultForFilterOnBodywheight.length, 1);
      expect(resultForFilterOnSmith.length, 2);
      expect(resultForFilterOnDumbbell.length, 2);
      expect(resultForFilterOnBarbell.length, 4);
    });

    test(
        'GIVEN an user is on the all exercises page of the app '
        'WHEN he wants to filter the 300+ exercises by body part '
        'THEN he should see only the exercises that work the body part that he picked ', () {
      // ARRANGE
      const String chestCategory = 'Chest';
      const String tricepsCategory = 'Triceps';
      const String bicepsCategory = 'Biceps';
      const String shoulderCategory = 'Shoulders';

      // ACT
      final List<Exercise> resultForFilterOnChest = filterBasedOnBodyPart(exerciseList, chestCategory);
      final List<Exercise> resultForFilterOnTriceps = filterBasedOnBodyPart(exerciseList, tricepsCategory);
      final List<Exercise> resultForFilterOnBiceps = filterBasedOnBodyPart(exerciseList, bicepsCategory);
      final List<Exercise> resultForFilterOnShoulder = filterBasedOnBodyPart(exerciseList, shoulderCategory);

      // ASSERT
      expect(resultForFilterOnChest.length, 2);
      expect(resultForFilterOnTriceps.length, 2);
      expect(resultForFilterOnBiceps.length, 1);
      expect(resultForFilterOnShoulder.length, 2);
    });

    test(
        'GIVEN an user is on the all exercises page of the app '
        'WHEN he wants to search for a certain/multiple exercises by their name '
        'THEN he should be able to search by writing a part of the name in the search box', () {
      // ARRANGE
      const String searchString1 = 'overhead';
      const String searchString2 = 'bench press';
      const String searchString3 = 'incline';
      const String searchString4 = '';
      const String searchString5 = 'random not found string';

      // ACT
      final List<Exercise> resultSearchString1 = filterBasedOnName(exerciseList, searchString1);
      final List<Exercise> resultSearchString2 = filterBasedOnName(exerciseList, searchString2);
      final List<Exercise> resultSearchString3 = filterBasedOnName(exerciseList, searchString3);
      final List<Exercise> resultSearchString4 = filterBasedOnName(exerciseList, searchString4);
      final List<Exercise> resultSearchString5 = filterBasedOnName(exerciseList, searchString5);

      // ASSERT
      expect(resultSearchString1.length, 2);
      expect(resultSearchString2.length, 2);
      expect(resultSearchString3.length, 1);
      expect(resultSearchString4.length, exerciseList.length);
      expect(resultSearchString5.length, 0);
    });

    test(
        'GIVEN an user is on the all exercises page of the app '
        'WHEN he wants to use multiple filters from the page '
        'THEN he should only see results correctly filtered by all filters', () {
      // ARRANGE
      const String categoryFilter1 = 'Barbell';
      const String bodyPartFilter1 = 'Chest';
      const String searchBoxFilter1 = '';

      const String categoryFilter2 = 'Barbell';
      const String bodyPartFilter2 = 'Legs';
      const String searchBoxFilter2 = 'curl';

      // ACT
      final List<Exercise> resultsFiltered1 =
          filterResults(exerciseList, categoryFilter1, bodyPartFilter1, searchBoxFilter1);
      final List<Exercise> resultsFiltered2 =
          filterResults(exerciseList, categoryFilter2, bodyPartFilter2, searchBoxFilter2);

      // ASSERT
      expect(resultsFiltered1.length, 1);
      expect(resultsFiltered2.length, 0);
    });
  });
  group('Login and Register Pages Logic Tests', () {
    test('tests function Widget returnIfUserConnected(User?)', () {
      // ARRANGE
      final User user = User('dummy', 'email@yahoo.com');
      const User? nullUser = null;

      // ACT
      final Widget response1 = returnIfUserConnected(user);
      final Widget response2 = returnIfUserConnected(nullUser);

      // ASSERT
      expect(response1.toStringShort(), 'CheckFirstTimeAndLoadDB');
      expect(response2.toStringShort(), 'LogInPage');
    });
    test('tests function String? validateEmail(String? content)', () {
      // ARRANGE
      const String stringToTest1 = 'random 124 text';
      const String stringToTest2 = 'randomWith@text';
      const String stringToTest3 = '412241';
      const String stringToTest4 = 'correct@anything.com';
      const String stringToTest5 = 'correct2@something.something';
      const String stringToTest6 = '@fail.something';

      // ACT
      final String? result1 = validateEmail(stringToTest1);
      final String? result2 = validateEmail(stringToTest2);
      final String? result3 = validateEmail(stringToTest3);
      final String? result4 = validateEmail(stringToTest4);
      final String? result5 = validateEmail(stringToTest5);
      final String? result6 = validateEmail(stringToTest6);

      // ASSERT
      expect(result1, 'Email is not valid');
      expect(result2, 'Email is not valid');
      expect(result3, 'Email is not valid');
      expect(result4, null);
      expect(result5, null);
      expect(result6, 'Email is not valid');
    });
    test('tests function pickColorRightWrong(bool aux)', () {
      // ARRANGE
      const bool auxTrue = true;
      const bool auxFalse = false;
      // ACT
      final Color? res1 = pickColorRightWrong(auxTrue);
      final Color? res2 = pickColorRightWrong(auxFalse);
      // ASSERT
      expect(res1, Colors.greenAccent[400]);
      expect(res2, Colors.red);
    });
    test('tests function pickIconRightWrong(bool aux)', () {
      // ARRANGE
      const bool auxTrue = true;
      const bool auxFalse = false;
      // ACT
      final Widget? res1 = pickIconRightWrong(auxTrue);
      final Widget? res2 = pickIconRightWrong(auxFalse);
      // ASSERT
      expect(res1?.toStringDeep().contains('U+0F058'), true);
      expect(res2?.toStringDeep().contains('U+0F057'), true);
    });
    test('tests password security validation', () {
      // ARRANGE
      const String examplePassword0 = '';
      const String examplePassword1 = 'pizza';
      const String examplePassword2 = 'pizza123';
      const String examplePassword3 = 'pizza123.';
      const String examplePassword4 = 'piZza123;';

      // ACT
      final bool isSecurePassword0 = testCapital(examplePassword0) &&
          testLower(examplePassword0) &&
          testNumbers(examplePassword0) &&
          testSymbol(examplePassword0);
      final bool isSecurePassword1 = testCapital(examplePassword1) &&
          testLower(examplePassword1) &&
          testNumbers(examplePassword1) &&
          testSymbol(examplePassword1);
      final bool isSecurePassword2 = testCapital(examplePassword2) &&
          testLower(examplePassword2) &&
          testNumbers(examplePassword2) &&
          testSymbol(examplePassword2);
      final bool isSecurePassword3 = testCapital(examplePassword3) &&
          testLower(examplePassword3) &&
          testNumbers(examplePassword3) &&
          testSymbol(examplePassword3);
      final bool isSecurePassword4 = testCapital(examplePassword4) &&
          testLower(examplePassword4) &&
          testNumbers(examplePassword4) &&
          testSymbol(examplePassword4);

      // ASSERT
      expect(isSecurePassword0, false);
      expect(isSecurePassword1, false);
      expect(isSecurePassword2, false);
      expect(isSecurePassword3, false);
      expect(isSecurePassword4, true);
    });
    test('tests function verifyRegistrationFilled', () {
      expect(verifyRegistrationFilled(true, true, true, true, true, 'correct@email.com', 'notEmpty'), true);
      expect(verifyRegistrationFilled(true, true, false, true, true, 'correct@email.com', 'notEmpty'), false);
      expect(verifyRegistrationFilled(true, true, true, true, true, 'correct@com', 'notEmpty'), false);
      expect(verifyRegistrationFilled(true, true, true, true, true, 'correct@email.com', ''), false);
    });
  });
  group('Workout History Page Logic Tests', () {
    test('tests String getDateAndTimeForPrinting(String hoursSpaceDate)', () {
      // ARRANGE
      const String incorrectFormat = 'dummy x 123';
      const String Friday29April2022 = '10:23  29.4.2022';
      const String Wednesday1May2019 = '20:15  1.5.2019';

      // ACT
      final String result1 = getDateAndTimeForPrinting(incorrectFormat);
      final String result2 = getDateAndTimeForPrinting(Friday29April2022);
      final String result3 = getDateAndTimeForPrinting(Wednesday1May2019);

      // ASSERT
      expect(result1, '');
      expect(result2, 'Friday   29 April 2022');
      expect(result3, 'Wednesday   1 May 2019');
    });
    test('tests String getWorkoutLengthForPrinting(String duration)', () {
      // ARRANGE
      const String duration1 = '00:30';
      const String duration2 = '0023';
      const String duration3 = '01:53';
      const String duration4 = '05:33';

      // ACT
      final String result1 = getWorkoutLengthForPrinting(duration1);
      final String result2 = getWorkoutLengthForPrinting(duration2);
      final String result3 = getWorkoutLengthForPrinting(duration3);
      final String result4 = getWorkoutLengthForPrinting(duration4);

      // EXPECT
      expect(result1, '30m');
      expect(result2, '');
      expect(result3, '1h 53m');
      expect(result4, '5h 33m');
    });
    test('tests String getTotalWeightOfAnWorkout', () {
      // ARRANGE
      final Exercise exercise1 = Exercise('Bench Press', '', '', 'system', 'Barbell', 'Chest', '', '');
      final ExerciseSet set1 = ExerciseSetWeight(exercise1);
      set1.type = 'ExerciseSetWeight';
      set1.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '10'),
        TextEditingController(text: 'checked')
      ]);
      set1.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '20'),
        TextEditingController(text: 'checked')
      ]);
      set1.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '30'),
        TextEditingController(text: 'checked')
      ]);
      final Exercise exercise2 = Exercise('Assited Dips', '', '', 'system', 'Assisted Bodyweight', 'Triceps', '', '');
      final ExerciseSet set2 = ExerciseSetMinusWeight(exercise2);
      set2.type = 'ExerciseSetMinusWeight';
      set2.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '10'),
        TextEditingController(text: 'checked')
      ]);
      set2.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '20'),
        TextEditingController(text: 'checked')
      ]);
      set2.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '30'),
        TextEditingController(text: 'checked')
      ]);
      final Exercise exercise3 = Exercise('Hollow hold', '', '', 'system', 'Time', 'Core', '', '');
      final ExerciseSet set3 = ExerciseSetDuration(exercise3);
      set3.type = 'ExerciseSetDuration';
      set3.sets.add(<TextEditingController>[
        TextEditingController(text: '01:30'),
        TextEditingController(text: ''),
        TextEditingController(text: 'checked')
      ]);
      set3.sets.add(<TextEditingController>[
        TextEditingController(text: '02:00'),
        TextEditingController(text: ''),
        TextEditingController(text: 'checked')
      ]);
      set3.sets.add(<TextEditingController>[
        TextEditingController(text: '01:00'),
        TextEditingController(text: ''),
        TextEditingController(text: 'checked')
      ]);
      final List<ExerciseSet> sets = <ExerciseSet>[set1, set2, set3];

      // ACT
      final String answer = getTotalWeightOfAnWorkout(sets, 60, WeightMetric.KG);

      // ASSERT
      expect(answer, '1800.0 kg');
    });
    test('tests String getBestSet from an ExerciseSet', () {
      // ARRANGE
      final Exercise exercise1 = Exercise('Bench Press', '', '', 'system', 'Barbell', 'Chest', '', '');
      final ExerciseSet set1 = ExerciseSetWeight(exercise1);
      set1.type = 'ExerciseSetWeight';
      set1.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '10'),
        TextEditingController(text: 'checked')
      ]);
      set1.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '20'),
        TextEditingController(text: 'checked')
      ]);
      set1.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '30'),
        TextEditingController(text: 'checked')
      ]);
      final Exercise exercise2 = Exercise('Assited Dips', '', '', 'system', 'Assisted Bodyweight', 'Triceps', '', '');
      final ExerciseSet set2 = ExerciseSetMinusWeight(exercise2);
      set2.type = 'ExerciseSetMinusWeight';
      set2.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '10'),
        TextEditingController(text: 'checked')
      ]);
      set2.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '20'),
        TextEditingController(text: 'checked')
      ]);
      set2.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '30'),
        TextEditingController(text: 'checked')
      ]);
      final Exercise exercise3 = Exercise('Hollow hold', '', '', 'system', 'Time', 'Core', '', '');
      final ExerciseSet set3 = ExerciseSetDuration(exercise3);
      set3.type = 'ExerciseSetDuration';
      set3.sets.add(<TextEditingController>[
        TextEditingController(text: '01:30'),
        TextEditingController(text: ''),
        TextEditingController(text: 'checked')
      ]);
      set3.sets.add(<TextEditingController>[
        TextEditingController(text: '02:00'),
        TextEditingController(text: ''),
        TextEditingController(text: 'checked')
      ]);
      set3.sets.add(<TextEditingController>[
        TextEditingController(text: '01:00'),
        TextEditingController(text: ''),
        TextEditingController(text: 'checked')
      ]);

      // ACT
      final String result1 = getBestSet(set1, 60, WeightMetric.KG);
      final String result2 = getBestSet(set2, 60, WeightMetric.KG);
      final String result3 = getBestSet(set3, 60, WeightMetric.KG);

      // ARRANGE
      expect(result1, '30kg x 10reps');
      expect(result2, '10kg x 10reps');
      expect(result3, '02:00');
    });
    test('tests String reduceString(String stringToReduce, int aux)', () {
      // ARRANGE
      const int aux = 10;
      const String test11 = 'gdsgds213gdsf213';
      const String test12 = 'gds23vc';

      // ACT
      final String result1 = reduceString(test11, aux);
      final String result2 = reduceString(test12, aux);

      // ASSERT
      expect(result1, 'gdsgds213g..');
      expect(result2, test12);
    });
    test('tests List<DateTime> getAllDateTimesOfWorkouts(List<HistoryWorkout> workouts)', () {
      // ARRANGE
      final List<HistoryWorkout> workouts = <HistoryWorkout>[
        HistoryWorkout('dummyId', '2022-4-27|22-52', 'dummyName', 'dummyNotes', <ExerciseSet>[], '00:00'),
        HistoryWorkout('dummyId1', '2022-5-23|10-30', 'dummyName1', 'dummyNotes1', <ExerciseSet>[], '00:00'),
        HistoryWorkout('dummyId2', '2022-4-24|23-25', 'dummyName2', 'dummyNotes2', <ExerciseSet>[], '00:00'),
        HistoryWorkout('dummyI3', '2022-4-21|20-10', 'dummyName3', 'dummyNotes3', <ExerciseSet>[], '00:00'),
      ];

      // ACT
      final List<DateTime> dates = getAllDateTimesOfWorkouts(workouts);

      // ASSERT
      expect(dates.length, 4);
      expect(
          dates.indexWhere((DateTime element) => element.day == 23 && element.month == 5 && element.year == 2022) != -1,
          true);
      expect(dates.indexWhere((DateTime element) => element.day == 21 && element.month == 4) != -1, true);
    });
  });
  group('Start Workout Page Logic Tests', () {
    test('tests int convertTimeToSeconds(String? time)', () {
      // ARRANGE
      const String? time1 = null;
      const String time2 = '20';
      const String time3 = '04:35';
      const String time4 = '02:35:20';

      // ACT
      final int result1 = convertTimeToSeconds(time1);
      final int result2 = convertTimeToSeconds(time2);
      final int result3 = convertTimeToSeconds(time3);
      final int result4 = convertTimeToSeconds(time4);

      // ASSERT
      expect(result1, 0);
      expect(result2, 20);
      expect(result3, 4 * 60 + 35);
      expect(result4, 2 * 60 * 60 + 35 * 60 + 20);
    });
    test('tests String getPrintableTimer(String secondsStr)', () {
      // ARRANGE
      const String seconds1 = 'dfgs2';
      const String seconds2 = '150';
      const String seconds3 = '9000'; // 2h 30 min
      const String seconds4 = '1800'; // 30 min
      const String seconds5 = '3599'; // 59 min 59 sec

      // ACT
      final String answer1 = getPrintableTimer(seconds1);
      final String answer2 = getPrintableTimer(seconds2);
      final String answer3 = getPrintableTimer(seconds3);
      final String answer4 = getPrintableTimer(seconds4);
      final String answer5 = getPrintableTimer(seconds5);

      // ASSERT
      expect(answer1, '');
      expect(answer2, '02:30');
      expect(answer3, '02:30:00');
      expect(answer4, '30:00');
      expect(answer5, '59:59');
    });
    test('tests String getPrintableTimerSinceStarting(String secondsStr)', () {
      // ARRANGE
      const String seconds1 = 'dfgs2';
      const String seconds2 = '150';
      const String seconds3 = '9000'; // 2h 30 min
      const String seconds4 = '1800'; // 30 min
      const String seconds5 = '3599'; // 59 min 59 sec

      // ACT
      final String answer1 = getPrintableTimerSinceStart(seconds1);
      final String answer2 = getPrintableTimerSinceStart(seconds2);
      final String answer3 = getPrintableTimerSinceStart(seconds3);
      final String answer4 = getPrintableTimerSinceStart(seconds4);
      final String answer5 = getPrintableTimerSinceStart(seconds5);

      // ASSERT
      expect(answer1, '');
      expect(answer2, '02:30');
      expect(answer3, '02:30:00');
      expect(answer4, '30:00');
      expect(answer5, '59:59');
    });
    test('tests bool validateWorkoutSets(List<ExerciseSet> exerciseSets)', () {
// ARRANGE
      final Exercise exercise1 = Exercise('Bench Press', '', '', 'system', 'Barbell', 'Chest', '', '');
      final ExerciseSet set1 = ExerciseSetWeight(exercise1);
      set1.type = 'ExerciseSetWeight';
      set1.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '10'),
        TextEditingController(text: 'checked')
      ]);
      set1.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '20'),
        TextEditingController(text: 'checked')
      ]);
      set1.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '30'),
        TextEditingController(text: 'checked')
      ]);
      final Exercise exercise2 = Exercise('Assited Dips', '', '', 'system', 'Assisted Bodyweight', 'Triceps', '', '');
      final ExerciseSet set2 = ExerciseSetMinusWeight(exercise2);
      set2.type = 'ExerciseSetMinusWeight';
      set2.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '10'),
        TextEditingController(text: 'checked')
      ]);
      set2.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '20'),
        TextEditingController(text: 'checked')
      ]);
      set2.sets.add(<TextEditingController>[
        TextEditingController(text: '10'),
        TextEditingController(text: '30'),
        TextEditingController(text: 'checked')
      ]);
      final Exercise exercise3 = Exercise('Hollow hold', '', '', 'system', 'Time', 'Core', '', '');
      final ExerciseSet set3 = ExerciseSetDuration(exercise3);
      set3.type = 'ExerciseSetDuration';
      set3.sets.add(<TextEditingController>[
        TextEditingController(text: '01:30'),
        TextEditingController(text: ''),
        TextEditingController(text: 'checked')
      ]);
      set3.sets.add(<TextEditingController>[
        TextEditingController(text: '02:00'),
        TextEditingController(text: ''),
        TextEditingController(text: 'checked')
      ]);
      set3.sets.add(<TextEditingController>[
        TextEditingController(text: '01:00'),
        TextEditingController(text: ''),
        TextEditingController(text: 'checked')
      ]);
      final List<ExerciseSet> sets1 = <ExerciseSet>[set1, set2, set3];

      final bool testSet1 = validateWorkoutSets(sets1);

      expect(testSet1, true);

      set1.sets.clear();
      set2.sets.clear();
      set3.sets.clear();
      final List<ExerciseSet> sets2 = <ExerciseSet>[set1, set2, set3];

      final bool testSet2 = validateWorkoutSets(sets2);

      expect(testSet2, false);
    });
  });
  group('User Details/Form Page Logic Tests', () {
    test('tests bool checkIfFilled', () {
      expect(checkIfFilled('dummy', null, 'dummy', null, 'dummy', null, 'dummy', null, 'dummy', null), true);
      expect(checkIfFilled('', null, 'dummy', null, 'dummy', null, 'dummy', null, 'dummy', null), false);
      expect(checkIfFilled('dummy', null, 'dummy', null, 'dummy', 'error', 'dummy', null, 'dummy', null), false);
    });
    test('tests String? firstNameVerify(String? content)', () {
      expect(firstNameVerify(''), null);
      expect(firstNameVerify('test'), null);
      expect(firstNameVerify('Test'), null);
      expect(firstNameVerify('Test214'), firstNameErrorText);
      expect(firstNameVerify('3421'), firstNameErrorText);
    });
    test('tests String? secondNameVerify(String? content)', () {
      expect(secondNameVerify(''), null);
      expect(secondNameVerify('test'), null);
      expect(secondNameVerify('Test'), null);
      expect(secondNameVerify('Test214'), firstNameErrorText);
      expect(secondNameVerify('3421'), firstNameErrorText);
    });
    test('tests String? heightVerify(String? content)', () {
      expect(heightVerify(''), null);
      expect(heightVerify('90'), heightErrorText);
      expect(heightVerify('300'), heightErrorText);
      expect(heightVerify('150'), null);
      expect(heightVerify('200'), null);
    });
    test('tests weightVerify(String? content, WeightMetric? metric)', () {
      expect(weightVerify('60', WeightMetric.KG), null);
      expect(weightVerify('200', WeightMetric.KG), null);
      expect(weightVerify('30', WeightMetric.KG), weightErrorText);
      expect(weightVerify('260', WeightMetric.KG), weightErrorText);
      expect(weightVerify('60', WeightMetric.LBS), weightErrorText);
      expect(weightVerify('510', WeightMetric.LBS), weightErrorText);
      expect(weightVerify('90', WeightMetric.LBS), null);
      expect(weightVerify('450', WeightMetric.LBS), null);
    });
    test('tests String? getWeightButtonColor(WeightMetric metric, String thisButtonMetric)', () {
      expect(getWeightButtonColor(WeightMetric.LBS, 'LBS'), Colors.greenAccent[400]);
      expect(getWeightButtonColor(WeightMetric.LBS, 'KG'), Colors.grey);
      expect(getWeightButtonColor(WeightMetric.KG, 'LBS'), Colors.grey);
      expect(getWeightButtonColor(WeightMetric.KG, 'KG'), Colors.greenAccent[400]);
    });
    test('tests weightMetricButtonSwitch(WeightMetric metric)', () {
      expect(weightMetricButtonSwitch(WeightMetric.KG), WeightMetric.LBS);
      expect(weightMetricButtonSwitch(WeightMetric.LBS), WeightMetric.KG);
    });
  });
}
