import '../ui/text/all_exercises_text.dart';
import '../utils/models/exercise.dart';

List<Exercise> filterBasedOnCategory(List<Exercise> exerciseList, String selectedCategory) {
  final List<Exercise> newList = <Exercise>[];
  for (final Exercise element in exerciseList) {
    if (element.category == selectedCategory) {
      newList.add(element);
    }
  }
  return newList;
}

List<Exercise> filterBasedOnBodyPart(List<Exercise> exerciseList, String selectedBodyPart) {
  final List<Exercise> newList = <Exercise>[];
  for (final Exercise element in exerciseList) {
    if (element.bodyPart == selectedBodyPart) {
      newList.add(element);
    }
  }
  return newList;
}

List<Exercise> filterBasedOnName(List<Exercise> exerciseList, String searchBoxText) {
  final List<Exercise> newList = <Exercise>[];
  for (final Exercise element in exerciseList) {
    if (element.name.toLowerCase().contains(searchBoxText.toLowerCase())) {
      newList.add(element);
    }
  }
  return newList;
}

List<Exercise> filterResults(
    List<Exercise> exerciseList, String selectedCategory, String selectedBodyPart, String searchBoxText) {
  if (selectedCategory != defaultCategory) {
    exerciseList = filterBasedOnCategory(exerciseList, selectedCategory);
  }
  if (selectedBodyPart != defaultBodyPart) {
    exerciseList = filterBasedOnBodyPart(exerciseList, selectedBodyPart);
  }
  if (searchBoxText != '') {
    exerciseList = filterBasedOnName(exerciseList, searchBoxText);
  }
  return exerciseList;
}
