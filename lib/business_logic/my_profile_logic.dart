import '../utils/models/user_database.dart';

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
