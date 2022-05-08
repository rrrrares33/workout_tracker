import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' as place;
import 'package:location/location.dart';

import '../utils/firebase/authentication_service.dart';
import '../utils/firebase/database_service.dart';
import '../utils/models/exercise.dart';
import '../utils/models/user_database.dart';
import '../utils/models/weight_tracker.dart';
import '../utils/models/workout_template.dart';

double calculateBMI(double weight, WeightMetric metric, double height) {
  if (metric == WeightMetric.LBS) {
    weight *= 0.45359237;
  }
  return weight / ((height / 100) * (height / 100));
}

String determineBMIRange(double bmi) {
  if (bmi < 18.5) {
    return 'Underweight';
  }
  if (bmi < 25) {
    return 'Normal';
  }
  if (bmi < 30) {
    return 'Overweight';
  }
  if (bmi < 35) {
    return 'Obese';
  }
  if (bmi < 40) {
    return 'Severely Obese';
  }
  return 'Normal';
}

Future<LocationData?> getUserLocation() async {
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  final Location location = Location();

  // Check if location service is enable
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  // Check if permission is granted
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  final LocationData _locationData = await location.getLocation();
  return _locationData;
}

void logOutAccount(List<WorkoutTemplate> templates, List<Exercise> exercises, WeightTracker weightTracker,
    DatabaseService databaseService, AuthenticationService authenticationService) {
  templates.clear();
  exercises.clear();
  weightTracker.dates.clear();
  weightTracker.weights.clear();
  databaseService.clearClass();
  authenticationService.signOutFromFirebase();
}

Future<List<Marker>> getLocations(LocationData _userLocation, place.GooglePlace googlePlace) async {
  final place.Location userLocation = place.Location(lat: _userLocation.latitude, lng: _userLocation.longitude);
  String? nextPageToken;
  final List<Marker> markers = <Marker>[];
  do {
    final place.NearBySearchResponse? result =
        await googlePlace.search.getNearBySearch(userLocation, 1500, keyword: 'gym', pagetoken: nextPageToken);
    result!.results?.forEach((place.SearchResult element) {
      markers.add(Marker(
        markerId: MarkerId(element.placeId!),
        position: LatLng(element.geometry!.location!.lat!, element.geometry!.location!.lng!),
        infoWindow: InfoWindow(title: element.name, snippet: element.vicinity),
        icon: BitmapDescriptor.defaultMarkerWithHue(160),
        onTap: () {},
      ));
    });
    nextPageToken = result.nextPageToken;
  } while (nextPageToken != null);
  return markers;
}
