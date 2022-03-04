class Exercise {
  Exercise(this.name, this.description, this.id, this.whoCreatedThisExercise, this.category, this.bodyPart, this.icon,
      this.biggerImage,
      [this.exerciseVideo, this.difficulty]);

  Exercise.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'].toString(),
        description = json['description'].toString(),
        id = json['id'].toString(),
        whoCreatedThisExercise = json['whoCreatedThisExercise'].toString(),
        category = json['category'].toString(),
        bodyPart = json['bodyPart'].toString(),
        icon = json['icon'].toString(),
        biggerImage = json['biggerImage'].toString(),
        exerciseVideo = json['exerciseVideo'].toString(),
        difficulty = json['difficulty'].toString();

  Map<String, String?> toJson() => <String, String?>{
        'name': name,
        'description': description,
        'id': id,
        'whoCreatedThisExercise': whoCreatedThisExercise,
        'category': category,
        'bodyPart': bodyPart,
        'icon': icon,
        'biggerImage': biggerImage,
        'exerciseVideo': exerciseVideo,
        'difficulty': difficulty
      };

  final String name;
  final String description;

  // Id will look like: user who {created_the_exercise}_{exercise_name}
  final String id;

  // This will store who created this exercise ('system' will be assigned to default exercises)
  final String whoCreatedThisExercise;

  // Barbell, Dumbbell, Machine, Weighted Bodyweight, Assisted Bodyweight, Reps, Cardio, Duration.
  final String category;

  // Targeted body part.
  final String bodyPart;

  // Smaller icon that appears all over the place for an image.
  final String icon;

  // Bigger image that shows the complete exercise in the exercise's description.
  final String biggerImage;

  // Video that explains how to do the exercise right
  final String? exerciseVideo;

  // The difficulty of the exercise.
  final String? difficulty;
}
