enum WeightMetric { KG, LBS }

class UserDB {
  UserDB(this.uid, this.email, this.firstEntry,
      [this.name, this.surname, this.age, this.weight, this.height, this.weightType]);

  UserDB.fromJson(Map<dynamic, dynamic> json)
      : uid = json['uid'].toString(),
        email = json['email'].toString(),
        firstEntry = json['firstEntry'].toString() == 'true',
        name = json['name'].toString(),
        surname = json['surname'].toString(),
        age = int.tryParse(json['age'].toString()) ?? -1,
        weight = double.tryParse(json['weight'].toString()) ?? -1,
        height = double.tryParse(json['height'].toString()) ?? -1,
        weightType = json['weightType'].toString() == WeightMetric.KG.toString() ? WeightMetric.KG : WeightMetric.LBS;

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
