import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:workout_tracker/business_logic/login_and_register_logic.dart';
import 'package:workout_tracker/utils/firebase/database_service.dart';
import 'package:workout_tracker/utils/firebase/firebase_service.dart';
import 'package:workout_tracker/utils/models/current_workout.dart';
import 'package:workout_tracker/utils/models/exercise.dart';
import 'package:workout_tracker/utils/models/exercise_set.dart';
import 'package:workout_tracker/utils/models/history_workout.dart';
import 'package:workout_tracker/utils/models/user_database.dart';
import 'package:workout_tracker/utils/models/workout_template.dart';

import 'mocks/database_unit_tests.mocks.dart';

/// This file should test all functionalities of database_service.dart

@GenerateMocks(<Type>[FirebaseService])
void main() {
  late DatabaseService databaseService;
  late MockFirebaseService firebaseServiceInstance;

  setUp(() {
    databaseService = DatabaseService();
    firebaseServiceInstance = MockFirebaseService();
  });

  group('Users DB Interactions', () {
    test(
        'GIVEN the application is not loaded yet '
        'WHEN the application starts '
        'THEN it should have no users inside of databaseService', () {
      expect(databaseService.getUsers().length, 0);
      expect(databaseService.getUsers().runtimeType == <UserDB>[].runtimeType, true);
    });

    test(
        'GIVEN application is starting '
        'WHEN we want to load all uid of already registered users in the application '
        'THEN we shall have all of the data loaded properly about them', () async {
      // ARRANGE - We mock an I/O answer because we do not want to do I/O operations in a test
      const String uidToCheck1 = 'cNAhne042lV6GPCAK9Fl82sCwtJ3';
      const String uidToCheck2 = 'BGMRMvIpuDPY76ptuEJICIvLhkI3';
      const String nameUid1 = 'Rares';
      when(firebaseServiceInstance.getData('Users')).thenAnswer((_) async => <dynamic, dynamic>{
            // user with full details completed (form completed)
            uidToCheck1: <dynamic, dynamic>{
              'uid': uidToCheck1,
              'weightType': 'WeightMetric.KG',
              'surname': 'Gherasim',
              'name': nameUid1,
              'weight': '80.0',
              'firstEntry': 'false',
              'age': '21',
              'email': 'rares.gherasim@my.fmi.unibuc.ro',
              'height': '185.0',
            },
            //user without form completed
            uidToCheck2: <dynamic, dynamic>{'uid': uidToCheck2, 'email': 'sgds@yahoo.com', 'firstEntry': 'true'}
          });

      // ACT - We execute de I/O request and result parsing
      await databaseService.loadUsers(firebaseServiceInstance);
      final List<UserDB> results = await databaseService.getAllUsers(firebaseServiceInstance);

      // ASSERT - We check if the data for users has been loaded properly
      expect(results.length, 2);
      expect(results[0].uid == uidToCheck1, true);
      expect(results[0].name == nameUid1, true);
      expect(results[0].firstEntry, false);
      expect(results[1].uid == uidToCheck2, true);
      expect(results[1].name == null, false); //it will not be null because it is not assigned at all
      expect(results[1].firstEntry, true);
    });

    test(
        'GIVEN an users enters the application '
        'WHEN he login/register '
        'THEN we shall determine whether he already has account, is a firstTimer(without form completed) or is a full user(with form completed)',
        () async {
      // ARRANGE - We mock an I/O answer because we do not want to do I/O operations in a test
      const String uidToTest1 = 'cNAhne042lV6GPCAK9Fl82sCwtJ3';
      const String emailToTest1 = 'rares.gherasim@my.fmi.unibuc.ro';
      const String name1 = 'Rares';
      const String uidToTest2 = 'BGMRMvIpuDPY76ptuEJICIvLhkI3';
      const String emailToTest2 = 'sgds@yahoo.com';
      const String uidToTest3 = 'GDSGDSsgddgsGDSgdssGDSgdfs213';
      const String emailToTest3 = 'test@yahoo.com';
      when(firebaseServiceInstance.getData('Users')).thenAnswer((_) async => <dynamic, dynamic>{
            // user with full details completed (form completed)
            uidToTest1: <dynamic, dynamic>{
              'uid': uidToTest1,
              'weightType': 'WeightMetric.KG',
              'surname': 'Gherasim',
              'name': name1,
              'weight': '80.0',
              'firstEntry': 'false',
              'age': '21',
              'email': emailToTest1,
              'height': '185.0',
            },
            //user without form completed
            uidToTest2: <dynamic, dynamic>{'uid': uidToTest2, 'email': emailToTest2, 'firstEntry': 'true'}
          });
      when(firebaseServiceInstance.createUserBeforeDetails(any, any)).thenAnswer((_) async => <String, dynamic>{});
      await databaseService.loadUsers(firebaseServiceInstance);

      // ACT
      final UserDB? alreadyRegisteredUserWithFullDetails =
          getUserOrCreateIfNullUsingUID(firebaseServiceInstance, databaseService, uidToTest1, emailToTest1);
      final UserDB? alreadyRegisteredUserWithoutFullDetails =
          getUserOrCreateIfNullUsingUID(firebaseServiceInstance, databaseService, uidToTest2, emailToTest2);
      final UserDB? notRegisteredUser =
          getUserOrCreateIfNullUsingUID(firebaseServiceInstance, databaseService, uidToTest3, emailToTest3);

      // ASSERT
      expect(alreadyRegisteredUserWithFullDetails != null, true);
      expect(alreadyRegisteredUserWithFullDetails!.firstEntry == true, false);
      expect(alreadyRegisteredUserWithFullDetails.uid == uidToTest1, true);
      expect(alreadyRegisteredUserWithFullDetails.name == name1, true);

      expect(alreadyRegisteredUserWithoutFullDetails != null, true);
      expect(alreadyRegisteredUserWithoutFullDetails!.firstEntry == true, true);
      expect(alreadyRegisteredUserWithoutFullDetails.uid == uidToTest2, true);
      expect(alreadyRegisteredUserWithoutFullDetails.name == null, true);
      expect(alreadyRegisteredUserWithoutFullDetails.weight == null, true);

      expect(notRegisteredUser != null, true);
      expect(notRegisteredUser!.firstEntry == true, true);
      expect(notRegisteredUser.uid == uidToTest3, true);
      expect(notRegisteredUser.name == null, true);
      expect(notRegisteredUser.weight == null, true);
    });

    test(
        'GIVEN an user creates an account for the first time '
        'WHEN he created the account '
        'THEN his account should be added to the accounts list with firstTime == true (without form completed',
        () async {
      // ARRANGE - We mock an I/O answer because we do not want to do I/O operations in a test
      const String uidToTest = 'cNAhne042lV6GPCAK9Fl82sCwtJ3';
      when(firebaseServiceInstance.getData('Users')).thenAnswer((_) async => <dynamic, dynamic>{
            // user with full details completed (form completed)
            'sgdgdsvSADFGGDSF21dsg': <dynamic, dynamic>{
              'uid': 'sgdgdsvSADFGGDSF21dsg',
              'weightType': 'WeightMetric.KG',
              'surname': 'Gherasim',
              'name': 'Rares',
              'weight': '80.0',
              'firstEntry': 'false',
              'age': '21',
              'email': 'rares.gherasim@my.fmi.unibuc.ro',
              'height': '185.0',
            },
          });
      when(firebaseServiceInstance.createUserBeforeDetails(any, any)).thenAnswer((_) async => <String, dynamic>{});
      final bool loaded = await databaseService.loadUsers(firebaseServiceInstance);

      expect(loaded, true);
      expect(databaseService.getUsers().length == 1, true);
      expect(databaseService.getUserBaseOnUid(uidToTest) == null, true);

      // ACT - We override the already created user with a full one
      await databaseService.createUserBeforeDetails(firebaseServiceInstance, uidToTest, 'sgds@yahoo.com');

      // ASSERT
      expect(databaseService.getUsers().length == 2, true);
      expect(databaseService.getUserBaseOnUid(uidToTest) != null, true);
      expect(databaseService.getUserBaseOnUid(uidToTest)!.firstEntry, true);
      expect(databaseService.getUserBaseOnUid(uidToTest)!.name == null, true);
    });

    test(
        'GIVEN an user has created an account without completing the details form '
        'WHEN he will complete and save the form '
        'THEN his previous stored data will be deleted and replaced by the more detailed one provided', () async {
      // ARRANGE - We mock an I/O answer because we do not want to do I/O operations in a test
      const String uidToTest = 'BGMRMvIpuDPY76ptuEJICIvLhkI3';
      const String newName = 'Matei';
      const double newHeight = 180;
      when(firebaseServiceInstance.getData('Users')).thenAnswer((_) async => <dynamic, dynamic>{
            // user with full details completed (form completed)
            'cNAhne042lV6GPCAK9Fl82sCwtJ3': <dynamic, dynamic>{
              'uid': 'cNAhne042lV6GPCAK9Fl82sCwtJ3',
              'weightType': 'WeightMetric.KG',
              'surname': 'Gherasim',
              'name': 'Rares',
              'weight': '80.0',
              'firstEntry': 'false',
              'age': '21',
              'email': 'rares.gherasim@my.fmi.unibuc.ro',
              'height': '185.0',
            },
            //user without form completed
            uidToTest: <dynamic, dynamic>{'uid': uidToTest, 'email': 'sgds@yahoo.com', 'firstEntry': 'true'}
          });
      when(firebaseServiceInstance.removeUserBasedOnUID(uidToTest)).thenAnswer((_) async => true);
      when(firebaseServiceInstance.createUserWithFullDetails(any, any, any, any, any, any, any, any))
          .thenAnswer((_) async => <String, dynamic>{});
      final bool loaded = await databaseService.loadUsers(firebaseServiceInstance);

      expect(loaded, true);
      expect(databaseService.getUsers().length == 2, true);
      expect(databaseService.getUserBaseOnUid(uidToTest)!.firstEntry, true);
      expect(databaseService.getUserBaseOnUid(uidToTest)!.name == null, true);

      // ACT - We override the already created user with a full one
      await databaseService.createUserWithFullDetails(
          uidToTest, 'sgds@yahoo.com', newName, 'Babara', 33, 65, newHeight, WeightMetric.LBS, firebaseServiceInstance);

      // ASSERT
      expect(databaseService.getUsers().length == 2, true);
      expect(databaseService.getUserBaseOnUid(uidToTest)!.firstEntry, false);
      expect(databaseService.getUserBaseOnUid(uidToTest)!.name == newName, true);
      expect(databaseService.getUserBaseOnUid(uidToTest)!.height == newHeight, true);
    });

    test(
        'GIVEN an user is logged into its account (with form completed) '
        'WHEN he wants to update the weight stored in database '
        'THEN the weight from database will actually be updated ', () async {
      // ARRANGE - We mock an I/O answer because we do not want to do I/O operations in a test
      const String uidToTest = 'cNAhne042lV6GPCAK9Fl82sCwtJ3';
      const double newWeight = 60.5;
      const double previousWeight = 80;
      when(firebaseServiceInstance.getData('Users')).thenAnswer((_) async => <dynamic, dynamic>{
            // user with full details completed (form completed)
            uidToTest: <dynamic, dynamic>{
              'uid': uidToTest,
              'weightType': 'WeightMetric.KG',
              'surname': 'Gherasim',
              'name': 'Rares',
              'weight': previousWeight,
              'firstEntry': 'false',
              'age': '21',
              'email': 'rares.gherasim@my.fmi.unibuc.ro',
              'height': '185.0',
            }
          });
      when(firebaseServiceInstance.changeUserWeight(uidToTest, newWeight)).thenAnswer((_) async => true);
      final bool loaded = await databaseService.loadUsers(firebaseServiceInstance);

      expect(loaded, true);
      expect(databaseService.getUserBaseOnUid(uidToTest)!.weight == previousWeight, true);

      // ACT
      final bool done = await databaseService.updateUserWeight(firebaseServiceInstance, uidToTest, newWeight);

      // ASSERT
      expect(done, true);
      expect(databaseService.getUserBaseOnUid(uidToTest)!.weight != previousWeight, true);
      expect(databaseService.getUserBaseOnUid(uidToTest)!.weight == newWeight, true);
    });

    test(
        'GIVEN an users scrolls through the app '
        'WHEN he wants to delete its account '
        'THEN his account should be deleted ', () async {
      // ARRANGE - We mock an I/O answer because we do not want to do I/O operations in a test
      const String uidToTest = 'BGMRMvIpuDPY76ptuEJICIvLhkI3';
      when(firebaseServiceInstance.getData('Users')).thenAnswer((_) async => <dynamic, dynamic>{
            //user without form completed
            uidToTest: <dynamic, dynamic>{'uid': uidToTest, 'email': 'sgds@yahoo.com', 'firstEntry': 'true'}
          });
      when(firebaseServiceInstance.removeUserBasedOnUID(uidToTest)).thenAnswer((_) async => true);
      final bool loaded = await databaseService.loadUsers(firebaseServiceInstance);
      expect(loaded, true);
      expect(databaseService.getUsers().length == 1, true);

      // ACT - remove User
      final bool result = await databaseService.deleteAnUser(firebaseServiceInstance, uidToTest);

      // ASSERT
      expect(result, true);
      expect(databaseService.getUsers().isEmpty, true);
    });
  });

  group('Exercises DB Interactions', () {
    test(
        'GIVEN a user logs into the application '
        'WHEN he enters the application '
        'THEN all exercises that HE CAN SEE shall be loaded (based on his uid)', () async {
      // ARRANGE
      const String systemExerciseIdTest = 'system_EZBarCurlsNarrowStanding';
      const String dummyUserUID = '214fdvs214gds';
      const String dummyUserSavedExerciseId = 'DummyExerciseName';
      const String dummyUserSavedExerciseCategory = 'Barbell';
      const String dummyUserUidAnotherUser = '421dsgfgbsf214df';
      when(firebaseServiceInstance.getData('Exercises')).thenAnswer((_) async => <dynamic, dynamic>{
            'system_latPulldownUnderhandMachine': <dynamic, dynamic>{
              'id': 'system_latPulldownUnderhandMachine',
              'category': 'Machine',
              'bodyPart': 'back',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/back_images/icons/Icon_Underhand_Grip_Lat_Pulldown_Machine.png',
              'name': 'Lat Pulldown Underhand Machine',
              'whoCreatedThisExercise': 'system',
              'description': 'Dummy description',
            },
            systemExerciseIdTest: <dynamic, dynamic>{
              'id': systemExerciseIdTest,
              'category': 'Barbell',
              'bodyPart': 'biceps',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/biceps_images/icons/Icon_Narrow_Grip_Standing_EZ_Bar_Curls.png',
              'name': 'EZ Bar Curls Narrow Grip',
              'whoCreatedThisExercise': 'system',
              'description': 'Dummy description 2',
            },
            '${dummyUserUID}_$dummyUserSavedExerciseId': <dynamic, dynamic>{
              'id': '${dummyUserUID}_$dummyUserSavedExerciseId',
              'category': dummyUserSavedExerciseCategory,
              'bodyPart': 'biceps',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/biceps_images/icons/Icon_Narrow_Grip_Standing_EZ_Bar_Curls.png',
              'name': 'EZ Bar Curls Narrow Grip',
              'whoCreatedThisExercise': dummyUserUID,
              'description': 'Dummy description 3',
            },
            '${dummyUserUidAnotherUser}_IrrelevantName': <dynamic, dynamic>{
              'id': '${dummyUserUidAnotherUser}_IrrelevantName',
              'category': 'Dumbbells',
              'bodyPart': 'chest',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/biceps_images/icons/Icon_Narrow_Grip_Standing_EZ_Bar_Curls.png',
              'name': 'Bench Press',
              'whoCreatedThisExercise': dummyUserUidAnotherUser,
              'description': 'Dummy description 4',
            },
          });

      // ACT
      final List<Exercise> result =
          await databaseService.getAllExercisesForUser(dummyUserUID, null, firebaseServiceInstance);

      // ASSERT
      expect(result.length == 3, true);
      expect(
          result.indexWhere((Exercise element) =>
                  element.id == '${dummyUserUID}_$dummyUserSavedExerciseId' &&
                  element.whoCreatedThisExercise == dummyUserUID) !=
              -1,
          true);
      expect(
          result.indexWhere((Exercise element) =>
                  element.id == '${dummyUserUidAnotherUser}_IrrelevantName' ||
                  element.whoCreatedThisExercise == dummyUserUidAnotherUser) ==
              -1,
          true);
      expect(
          result.indexWhere((Exercise element) =>
                  element.id == systemExerciseIdTest && element.whoCreatedThisExercise == 'system') !=
              -1,
          true);
    });

    test(
        'GIVEN user wants to start a workout '
        'WHEN he sees that he does not have a certain exercise that he wants to perform by default in the app '
        'THEN he wants to create a new exercise', () async {
      // ARRANGE
      const String systemExerciseIdTest = 'system_EZBarCurlsNarrowStanding';
      const String dummyUserUID = '214fdvs214gds';
      const String dummyUserUidAnotherUser = '421dsgfgbsf214df';
      const String newExerciseName = 'Dummy New Name';
      const String newExerciseCategory = 'Barbell';
      when(firebaseServiceInstance.getData('Exercises')).thenAnswer((_) async => <dynamic, dynamic>{
            'system_latPulldownUnderhandMachine': <dynamic, dynamic>{
              'id': 'system_latPulldownUnderhandMachine',
              'category': 'Machine',
              'bodyPart': 'back',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/back_images/icons/Icon_Underhand_Grip_Lat_Pulldown_Machine.png',
              'name': 'Lat Pulldown Underhand Machine',
              'whoCreatedThisExercise': 'system',
              'description': 'Dummy description',
            },
            systemExerciseIdTest: <dynamic, dynamic>{
              'id': systemExerciseIdTest,
              'category': 'Barbell',
              'bodyPart': 'biceps',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/biceps_images/icons/Icon_Narrow_Grip_Standing_EZ_Bar_Curls.png',
              'name': 'EZ Bar Curls Narrow Grip',
              'whoCreatedThisExercise': 'system',
              'description': 'Dummy description 2',
            },
            '${dummyUserUID}_IrellevantName': <dynamic, dynamic>{
              'id': '${dummyUserUID}_IrellevantName',
              'category': 'Barbell',
              'bodyPart': 'biceps',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/biceps_images/icons/Icon_Narrow_Grip_Standing_EZ_Bar_Curls.png',
              'name': 'EZ Bar Curls Narrow Grip',
              'whoCreatedThisExercise': dummyUserUID,
              'description': 'Dummy description 3',
            },
            '${dummyUserUidAnotherUser}_IrrelevantName': <dynamic, dynamic>{
              'id': '${dummyUserUidAnotherUser}_IrrelevantName',
              'category': 'Dumbbells',
              'bodyPart': 'chest',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/biceps_images/icons/Icon_Narrow_Grip_Standing_EZ_Bar_Curls.png',
              'name': 'Bench Press',
              'whoCreatedThisExercise': dummyUserUidAnotherUser,
              'description': 'Dummy description 4',
            },
          });
      when(firebaseServiceInstance.createNewExercise(any, any, any, any, any, any))
          .thenAnswer((_) async => <String, dynamic>{});
      // CHECK data before ACT and ASSERT
      expect((await databaseService.getAllExercisesForUser(dummyUserUID, null, firebaseServiceInstance)).length, 3);
      expect(
          (await databaseService.getAllExercisesForUser(dummyUserUID, null, firebaseServiceInstance)).indexWhere(
              (Exercise element) =>
                  element.name == newExerciseName &&
                  element.whoCreatedThisExercise == dummyUserUID &&
                  element.category == newExerciseCategory),
          -1);

      // ACT
      await databaseService.createNewExercise(
          dummyUserUID, newExerciseName, 'dummyText', newExerciseCategory, 'dummyBodyType', firebaseServiceInstance);
      final List<Exercise> result =
          await databaseService.getAllExercisesForUser(dummyUserUID, null, firebaseServiceInstance);

      // ASSERT
      expect(result.length, 4);
      expect(
          result.indexWhere((Exercise element) =>
                  element.name == newExerciseName &&
                  element.whoCreatedThisExercise == dummyUserUID &&
                  element.category == newExerciseCategory) !=
              -1,
          true);
    });

    test(
        'GIVEN user looks though all exercise page '
        'WHEN he sees an exercise that he no longer wants to do '
        'THEN he can remove that exercise from the exercise list', () async {
      // ARRANGE
      const String exerciseToDeleteID = 'system_EZBarCurlsNarrowStanding';
      when(firebaseServiceInstance.getData('Exercises')).thenAnswer((_) async => <dynamic, dynamic>{
            'system_latPulldownUnderhandMachine': <dynamic, dynamic>{
              'id': 'system_latPulldownUnderhandMachine',
              'category': 'Machine',
              'bodyPart': 'back',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/back_images/icons/Icon_Underhand_Grip_Lat_Pulldown_Machine.png',
              'name': 'Lat Pulldown Underhand Machine',
              'whoCreatedThisExercise': 'system',
              'description': 'Dummy description',
            },
            exerciseToDeleteID: <dynamic, dynamic>{
              'id': exerciseToDeleteID,
              'category': 'Barbell',
              'bodyPart': 'biceps',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/biceps_images/icons/Icon_Narrow_Grip_Standing_EZ_Bar_Curls.png',
              'name': 'EZ Bar Curls Narrow Grip',
              'whoCreatedThisExercise': 'system',
              'description': 'Dummy description 2',
            },
          });
      when(firebaseServiceInstance.removeExerciseBasedOnId(any)).thenAnswer((_) async => true);
      expect((await databaseService.getAllExercisesForUser('', null, firebaseServiceInstance)).length, 2);
      expect(
          (await databaseService.getAllExercisesForUser('', null, firebaseServiceInstance))
                  .indexWhere((Exercise element) => element.id == exerciseToDeleteID) !=
              -1,
          true);

      // ACT
      expect(await databaseService.deleteAnExercise(firebaseServiceInstance, exerciseToDeleteID), true);

      // ASSERT
      expect((await databaseService.getAllExercisesForUser('', null, firebaseServiceInstance)).length, 1);
      expect(
          (await databaseService.getAllExercisesForUser('', null, firebaseServiceInstance))
              .indexWhere((Exercise element) => element.id == exerciseToDeleteID),
          -1);
    });
  });

  group('History DB Interactions', () {
    const String uidCreatedExercise = 'sdg214dvs12';
    const String uidCreatedExercise2 = 'gfdsghfd21dgfs243';

    setUp(() async {
      // history is dependant on a loaded list of exercise, so we try to mock it here.
      when(firebaseServiceInstance.getData('Exercises')).thenAnswer((_) async => <dynamic, dynamic>{
            'system_latPulldownUnderhandMachine': <dynamic, dynamic>{
              'id': 'system_latPulldownUnderhandMachine',
              'category': 'Machine',
              'bodyPart': 'back',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/back_images/icons/Icon_Underhand_Grip_Lat_Pulldown_Machine.png',
              'name': 'Lat Pulldown Underhand Machine',
              'whoCreatedThisExercise': 'system',
              'description': 'Dummy description',
            },
            'system_latPulldown': <dynamic, dynamic>{
              'id': 'system_latPulldown',
              'category': 'Bodywheight',
              'bodyPart': 'back',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/biceps_images/icons/Icon_Narrow_Grip_Standing_EZ_Bar_Curls.png',
              'name': 'Lat Pulldown',
              'whoCreatedThisExercise': 'system',
              'description': 'Dummy description 2',
            },
            'system_chestDips': <dynamic, dynamic>{
              'id': 'system_chestDips',
              'category': 'Bodywheight',
              'bodyPart': 'chest',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/biceps_images/icons/Icon_Narrow_Grip_Standing_EZ_Bar_Curls.png',
              'name': 'Chest Dips',
              'whoCreatedThisExercise': 'system',
              'description': 'Dummy description 3',
            },
            '${uidCreatedExercise}_pushups': <dynamic, dynamic>{
              'id': '${uidCreatedExercise}_pushups',
              'category': 'Bodywheight',
              'bodyPart': 'chest',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/biceps_images/icons/Icon_Narrow_Grip_Standing_EZ_Bar_Curls.png',
              'name': 'Push Ups',
              'whoCreatedThisExercise': uidCreatedExercise,
              'description': 'Dummy description 4',
            },
            '${uidCreatedExercise2}_benchPressBarbell': <dynamic, dynamic>{
              'id': '${uidCreatedExercise2}_bechPressBarbell',
              'category': 'Barbell',
              'bodyPart': 'chest',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/biceps_images/icons/Icon_Narrow_Grip_Standing_EZ_Bar_Curls.png',
              'name': 'Bench Press Barbell',
              'whoCreatedThisExercise': uidCreatedExercise2,
              'description': 'Dummy description 5',
            },
          });
      when(firebaseServiceInstance.getData('History')).thenAnswer((_) async => <dynamic, dynamic>{
            '${uidCreatedExercise}_2022-4-27|22-52': <dynamic, dynamic>{
              'duration': '00:35',
              'id': '${uidCreatedExercise}_2022-4-27|22-52',
              'startTime': '2022-4-27|22-52',
              'notes': 'Workout Dummy Notes',
              'name': 'Workout Dummy Name',
              'exercisesAndSets': <dynamic, dynamic>{
                '1_system_latPulldown': <dynamic, dynamic>{
                  'sets': <dynamic>['null', '10_0', '10_0', '10_0'],
                  'assignedExercise': 'system_latPulldown',
                  'type': 'ExerciseSetWeight'
                },
                '2_system_latPulldownUnderhandMachine': <dynamic, dynamic>{
                  'sets': <dynamic>['null', '10_30', '10_30', '10_30'],
                  'assignedExercise': 'system_latPulldownUnderhandMachine',
                  'type': 'ExerciseSetWeight'
                },
                '3_${uidCreatedExercise}_pushups': <dynamic, dynamic>{
                  'sets': <dynamic>['null', '10_10', '10_10', '10_10'],
                  'assignedExercise': '${uidCreatedExercise}_pushups',
                  'type': 'ExerciseSetWeight'
                },
              }
            },
            '${uidCreatedExercise2}_2022-4-23|22-10': <dynamic, dynamic>{
              'duration': '00:50',
              'startTime': '2022-4-23|22-10',
              'id': '${uidCreatedExercise2}_2022-4-23|22-10',
              'notes': 'Workout Dummy Notes 2',
              'name': 'Workout Dummy Name 2',
              'exercisesAndSets': <dynamic, dynamic>{
                '1_system_latPulldownUnderhandMachine': <dynamic, dynamic>{
                  'sets': <dynamic>['null', '10_30', '10_30', '10_30'],
                  'assignedExercise': 'system_latPulldownUnderhandMachine',
                  'type': 'ExerciseSetWeight'
                },
                '3_${uidCreatedExercise2}_benchPressBarbell': <dynamic, dynamic>{
                  'sets': <dynamic>['null', '10_10', '10_10', '10_10'],
                  'assignedExercise': '${uidCreatedExercise2}_benchPressBarbell',
                  'type': 'ExerciseSetWeight'
                },
              }
            },
          });
    });

    test(
        'GIVEN opens the application '
        'WHEN he logs into the application '
        'THEN his workout history should be loaded', () async {
      // ARRANGE
      final List<Exercise> exerciseList =
          await databaseService.getAllExercisesForUser(uidCreatedExercise, null, firebaseServiceInstance);

      // ACT
      await databaseService.getAllHistoryFromDBForUser(uidCreatedExercise, exerciseList, firebaseServiceInstance);

      // ASSERT
      expect(
          (await databaseService.getAllHistoryFromDBForUser(uidCreatedExercise, exerciseList, firebaseServiceInstance))
              .length,
          1);
      expect(
          (await databaseService.getAllHistoryFromDBForUser(uidCreatedExercise, exerciseList, firebaseServiceInstance))
                  .indexWhere((HistoryWorkout element) => element.workoutName == 'Workout Dummy Name') !=
              -1,
          true);
      expect(
          (await databaseService.getAllHistoryFromDBForUser(
                  uidCreatedExercise, exerciseList, firebaseServiceInstance))[0]
              .exercises
              .length,
          3);
      expect(
          (await databaseService.getAllHistoryFromDBForUser(
                      uidCreatedExercise, exerciseList, firebaseServiceInstance))[0]
                  .exercises
                  .indexWhere(
                      (ExerciseSet element) => element.assignedExercise.name == 'Lat Pulldown Underhand Machine') !=
              -1,
          true);
    });

    test(
        'GIVEN an user runs an workout '
        'WHEN he finishes the workout '
        'THEN he wants to save it', () async {
      // ARRANGE
      final List<Exercise> exerciseList =
          await databaseService.getAllExercisesForUser(uidCreatedExercise, null, firebaseServiceInstance);
      when(firebaseServiceInstance.addWorkoutToHistory(any, any, any, any, any, any))
          .thenAnswer((_) async => <String, dynamic>{});
      final CurrentWorkout workoutToAddToHistory = CurrentWorkout();
      workoutToAddToHistory.startTime = DateTime.parse('1969-07-20 20:18:04Z');
      final ExerciseSet exerciseToAdd1 =
          ExerciseSetWeight(exerciseList.firstWhere((Exercise element) => element.id == 'system_latPulldown'));
      exerciseToAdd1.sets.addAll(<List<TextEditingController>>[
        <TextEditingController>[
          TextEditingController(text: '10'),
          TextEditingController(text: '10'),
          TextEditingController(text: 'checked')
        ],
        <TextEditingController>[
          TextEditingController(text: '10'),
          TextEditingController(text: '20'),
          TextEditingController(text: 'checked')
        ],
        <TextEditingController>[
          TextEditingController(text: '10'),
          TextEditingController(text: '30'),
          TextEditingController(text: 'checked')
        ]
      ]);
      workoutToAddToHistory.exercises.add(exerciseToAdd1);
      final ExerciseSet exerciseToAdd2 =
          ExerciseSetWeight(exerciseList.firstWhere((Exercise element) => element.id == 'system_chestDips'));
      exerciseToAdd2.sets.addAll(<List<TextEditingController>>[
        <TextEditingController>[
          TextEditingController(text: '10'),
          TextEditingController(text: '0'),
          TextEditingController(text: 'checked')
        ],
        <TextEditingController>[
          TextEditingController(text: '10'),
          TextEditingController(text: '0'),
          TextEditingController(text: 'checked')
        ],
        <TextEditingController>[
          TextEditingController(text: '10'),
          TextEditingController(text: '10'),
          TextEditingController(text: 'checked')
        ]
      ]);
      workoutToAddToHistory.exercises.add(exerciseToAdd2);
      await databaseService.getAllHistoryFromDBForUser(uidCreatedExercise, exerciseList, firebaseServiceInstance);

      // ACT
      await databaseService.addWorkoutToHistory(
          workoutToAddToHistory, uidCreatedExercise, null, firebaseServiceInstance);

      // ASSERT
      expect(
          (await databaseService.getAllHistoryFromDBForUser(uidCreatedExercise, exerciseList, firebaseServiceInstance))
              .length,
          2);
      expect(
          (await databaseService.getAllHistoryFromDBForUser(uidCreatedExercise, exerciseList, firebaseServiceInstance))
                  .indexWhere((HistoryWorkout element) => element.workoutName == 'Daily workout') !=
              -1,
          true);
      expect(
          (await databaseService.getAllHistoryFromDBForUser(
                  uidCreatedExercise, exerciseList, firebaseServiceInstance))[0]
              .exercises
              .length,
          2);
      expect(
          (await databaseService.getAllHistoryFromDBForUser(
                  uidCreatedExercise, exerciseList, firebaseServiceInstance))[0]
              .exercises[0]
              .sets
              .length,
          3);
    });

    test(
        'GIVEN an looks over his workout history '
        'WHEN he does not like a previous workout that he had '
        'THEN he wants to remove it', () async {
      // ARRANGE
      when(firebaseServiceInstance.removeHistory(any)).thenAnswer((_) async => true);
      final List<Exercise> exerciseList =
          await databaseService.getAllExercisesForUser(uidCreatedExercise, null, firebaseServiceInstance);
      await databaseService.getAllHistoryFromDBForUser(uidCreatedExercise, exerciseList, firebaseServiceInstance);

      // ACT
      final bool result = await databaseService.removeWorkoutFromHistory(
          '${uidCreatedExercise}_2022-4-27|22-52', firebaseServiceInstance);

      // EXPECT - 0 history workouts now for this user
      expect(result, true);
      expect(databaseService.getCurrentHistory().isEmpty, true);
    });
  });

  group('Templates DB Interactions', () {
    const String uidCreatedExercise = 'sdg214dvs12';
    const String systemTemplateId = 'system_gdsgsd214vds21fd';
    const String createdUserTemplateId = 'sdg214dvs12_hfrdshsdf23gfds';

    setUp(() async {
      // history is dependant on a loaded list of exercise, so we try to mock it here.
      when(firebaseServiceInstance.getData('Exercises')).thenAnswer((_) async => <dynamic, dynamic>{
            'system_latPulldownUnderhandMachine': <dynamic, dynamic>{
              'id': 'system_latPulldownUnderhandMachine',
              'category': 'Machine',
              'bodyPart': 'back',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/back_images/icons/Icon_Underhand_Grip_Lat_Pulldown_Machine.png',
              'name': 'Lat Pulldown Underhand Machine',
              'whoCreatedThisExercise': 'system',
              'description': 'Dummy description',
            },
            'system_latPulldown': <dynamic, dynamic>{
              'id': 'system_latPulldown',
              'category': 'Bodywheight',
              'bodyPart': 'back',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/biceps_images/icons/Icon_Narrow_Grip_Standing_EZ_Bar_Curls.png',
              'name': 'Lat Pulldown',
              'whoCreatedThisExercise': 'system',
              'description': 'Dummy description 2',
            },
            'system_chestDips': <dynamic, dynamic>{
              'id': 'system_chestDips',
              'category': 'Bodywheight',
              'bodyPart': 'chest',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/biceps_images/icons/Icon_Narrow_Grip_Standing_EZ_Bar_Curls.png',
              'name': 'Chest Dips',
              'whoCreatedThisExercise': 'system',
              'description': 'Dummy description 3',
            },
            '${uidCreatedExercise}_pushups': <dynamic, dynamic>{
              'id': '${uidCreatedExercise}_pushups',
              'category': 'Bodywheight',
              'bodyPart': 'chest',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/biceps_images/icons/Icon_Narrow_Grip_Standing_EZ_Bar_Curls.png',
              'name': 'Push Ups',
              'whoCreatedThisExercise': uidCreatedExercise,
              'description': 'Dummy description 4',
            },
            '${uidCreatedExercise}_benchPressBarbell': <dynamic, dynamic>{
              'id': '${uidCreatedExercise}_benchPressBarbell',
              'category': 'Barbell',
              'bodyPart': 'chest',
              'biggerImage': 'www.example.org',
              'icon': 'assets/all_icons/biceps_images/icons/Icon_Narrow_Grip_Standing_EZ_Bar_Curls.png',
              'name': 'Bench Press Barbell',
              'whoCreatedThisExercise': uidCreatedExercise,
              'description': 'Dummy description 5',
            },
          });
      when(firebaseServiceInstance.getData('Templates')).thenAnswer((_) async => <dynamic, dynamic>{
            systemTemplateId: <dynamic, dynamic>{
              'id': systemTemplateId,
              'notes': 'System Template Notes',
              'name': 'System Template Name',
              'exercises': <dynamic, dynamic>{
                '1_system_latPulldown': <dynamic, dynamic>{
                  'sets': <dynamic>[
                    <dynamic>['0', '0', '0'],
                    <dynamic>['0', '0', '0'],
                    <dynamic>['0', '0', '0']
                  ],
                  'assignedExercise': 'system_latPulldown',
                  'type': 'ExerciseSetWeight'
                },
                '2_system_latPulldownUnderhandMachine': <dynamic, dynamic>{
                  'sets': <dynamic>[
                    <dynamic>['0', '0', '0'],
                    <dynamic>['0', '0', '0'],
                    <dynamic>['0', '0', '0']
                  ],
                  'assignedExercise': 'system_latPulldownUnderhandMachine',
                  'type': 'ExerciseSetWeight'
                },
                '3_${uidCreatedExercise}_pushups': <dynamic, dynamic>{
                  'sets': <dynamic>[
                    <dynamic>['0', '0', '0'],
                    <dynamic>['0', '0', '0'],
                    <dynamic>['0', '0', '0']
                  ],
                  'assignedExercise': '${uidCreatedExercise}_pushups',
                  'type': 'ExerciseSetWeight'
                },
              }
            },
            createdUserTemplateId: <dynamic, dynamic>{
              'id': createdUserTemplateId,
              'notes': 'Workout Dummy Notes 2',
              'name': 'Workout Dummy Name 2',
              'exercises': <dynamic, dynamic>{
                '1_system_latPulldownUnderhandMachine': <dynamic, dynamic>{
                  'sets': <dynamic>[
                    <dynamic>['0', '0', '0'],
                    <dynamic>['0', '0', '0'],
                    <dynamic>['0', '0', '0']
                  ],
                  'assignedExercise': 'system_latPulldownUnderhandMachine',
                  'type': 'ExerciseSetWeight'
                },
                '2_${uidCreatedExercise}_benchPressBarbell': <dynamic, dynamic>{
                  'sets': <dynamic>[
                    <dynamic>['0', '0', '0'],
                    <dynamic>['0', '0', '0'],
                    <dynamic>['0', '0', '0']
                  ],
                  'assignedExercise': '${uidCreatedExercise}_benchPressBarbell',
                  'type': 'ExerciseSetWeight'
                },
              }
            },
          });
    });

    test(
        'GIVEN an user opens the application '
        'WHEN the system starts loading its assets '
        'THEN the system should load all templates', () async {
      // ARRANGE
      final List<Exercise> exerciseList =
          await databaseService.getAllExercisesForUser(uidCreatedExercise, null, firebaseServiceInstance);

      // ACT
      await databaseService.getAllWorkoutTemplatesFromDBForUser(
          uidCreatedExercise, exerciseList, firebaseServiceInstance);
      final List<WorkoutTemplate> templates = databaseService.getWorkoutTemplates();

      // ASSERT
      expect(templates.length, 2);
      expect(templates.indexWhere((WorkoutTemplate element) => element.id == createdUserTemplateId) != -1, true);
      expect(templates.indexWhere((WorkoutTemplate element) => element.id == systemTemplateId) != -1, true);
      expect(
          templates.indexWhere((WorkoutTemplate element) =>
                  element.exercises.length == 2 &&
                  element.exercises[1].sets.length == 3 &&
                  element.exercises[1].assignedExercise.name == 'Bench Press Barbell') !=
              -1,
          true);
      expect(
          templates.indexWhere((WorkoutTemplate element) =>
                  element.exercises.length == 3 &&
                  element.name.contains('System') &&
                  element.exercises[1].sets.length == 3 &&
                  element.exercises[1].assignedExercise.name == 'Lat Pulldown Underhand Machine') !=
              -1,
          true);
    });

    test(
        'GIVEN an user does not find the desired system template '
        'WHEN he wants to create a new template '
        'THEN template should be saved successfully', () async {
      // ARRANGE
      final List<Exercise> exerciseList =
          await databaseService.getAllExercisesForUser(uidCreatedExercise, null, firebaseServiceInstance);
      const String exampleId = 'ghfds214rbfgvds';
      final List<ExerciseSet> exercisesReceived = <ExerciseSet>[];
      final ExerciseSet exerciseToAdd1 =
          ExerciseSetWeight(exerciseList.firstWhere((Exercise element) => element.id == 'system_latPulldown'));
      exerciseToAdd1.sets.addAll(<List<TextEditingController>>[
        <TextEditingController>[
          TextEditingController(text: '0'),
          TextEditingController(text: '0'),
          TextEditingController(text: 'checked')
        ],
        <TextEditingController>[
          TextEditingController(text: '0'),
          TextEditingController(text: '0'),
          TextEditingController(text: 'checked')
        ],
        <TextEditingController>[
          TextEditingController(text: '0'),
          TextEditingController(text: '0'),
          TextEditingController(text: 'checked')
        ]
      ]);
      final ExerciseSet exerciseToAdd2 =
          ExerciseSetWeight(exerciseList.firstWhere((Exercise element) => element.id == 'system_chestDips'));
      exerciseToAdd2.sets.addAll(<List<TextEditingController>>[
        <TextEditingController>[
          TextEditingController(text: '0'),
          TextEditingController(text: '0'),
          TextEditingController(text: 'checked')
        ],
        <TextEditingController>[
          TextEditingController(text: '0'),
          TextEditingController(text: '0'),
          TextEditingController(text: 'checked')
        ],
        <TextEditingController>[
          TextEditingController(text: '0'),
          TextEditingController(text: '0'),
          TextEditingController(text: 'checked')
        ]
      ]);
      exercisesReceived.addAll(<ExerciseSet>[exerciseToAdd1, exerciseToAdd2]);
      final WorkoutTemplate workoutTemplate =
          WorkoutTemplate('dummy name', 'dummy notes', exercisesReceived, exampleId);
      await databaseService.getAllWorkoutTemplatesFromDBForUser(
          uidCreatedExercise, exerciseList, firebaseServiceInstance);
      when(firebaseServiceInstance.addWorkoutTemplate(any, any, any, any)).thenAnswer((_) async => <String, dynamic>{});

      // ACT
      await databaseService.addWorkoutTemplateToDB(workoutTemplate, firebaseServiceInstance);

      // ASSERT
      final List<WorkoutTemplate> result = databaseService.getWorkoutTemplates();
      expect(result.length, 3);
      expect(
          result.indexWhere((WorkoutTemplate element) =>
                  element.id == exampleId &&
                  element.name == 'dummy name' &&
                  element.notes == 'dummy notes' &&
                  element.exercises.length == 2 &&
                  element.exercises[0].sets.length == 3 &&
                  element.exercises[1].sets.length == 3 &&
                  element.exercises[1].assignedExercise.id == 'system_chestDips') !=
              -1,
          true);
    });

    test(
        'GIVEN an user is looking for his templates '
        'WHEN he does not like one of the templates he created '
        'THEN he shall be able to delete it', () async {
      // ARRANGE
      final List<Exercise> exerciseList =
          await databaseService.getAllExercisesForUser(uidCreatedExercise, null, firebaseServiceInstance);
      await databaseService.getAllWorkoutTemplatesFromDBForUser(
          uidCreatedExercise, exerciseList, firebaseServiceInstance);
      when(firebaseServiceInstance.removeTemplate(any)).thenAnswer((_) async => true);

      // ACT
      final bool result = await databaseService.removeTemplate(createdUserTemplateId, firebaseServiceInstance);

      // ASSERT
      expect(result, true);
      expect(databaseService.getWorkoutTemplates().length, 1);
      expect(
          databaseService
              .getWorkoutTemplates()
              .indexWhere((WorkoutTemplate element) => element.id == createdUserTemplateId),
          -1);
    });
  });
}
