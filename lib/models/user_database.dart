enum WeightMetric { KG, LBS }

class UserDB {
  UserDB(this.uid, this.email, this.firstEntry,
      [this.name, this.surname, this.age, this.weight, this.height, this.weightType]);

  UserDB.fromJson(Map<dynamic, dynamic> json)
      : uid = json['uid'] as String,
        email = json['email'] as String,
        firstEntry = json['firstEntry'] == 'true',
        name = json['name'] as String? ?? '',
        surname = json['surname'] as String? ?? '',
        age = json['age'] as int? ?? -1,
        weight = json['weight'] as double? ?? -1,
        height = json['height'] as double? ?? -1,
        weightType = json['weightType'] as WeightMetric? ?? WeightMetric.KG;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'uid': uid,
        'email': email,
        'name': name,
        'surname': surname,
        'firstEntry': firstEntry.toString(),
        'age': age.toString(),
        'weight': weight.toString(),
        'height': height.toString(),
        'weightType': weightType.toString()
      };

  final String email;
  final String uid;
  final bool? firstEntry;
  late final String? name;
  late final String? surname;
  late final int? age;
  late final double? weight;
  late final double? height;
  late final WeightMetric? weightType;
}
