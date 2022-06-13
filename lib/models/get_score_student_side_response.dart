

class GetScoreStudentSideResponse {
  bool success;
  List<GetScoreData> data;

  GetScoreStudentSideResponse({required this.success, required this.data});

  factory GetScoreStudentSideResponse.fromJson(Map<String, dynamic> json) => GetScoreStudentSideResponse(
    success: json["success"],
    data: List<GetScoreData>.from(
        json["data"].map((x) => GetScoreData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class GetScoreData {
  String id;
  String studentId;
  double category;
  int testType;
  int time;
  String wrongImage;
  double angleScore;
  double teacherScore;
  int round;
  int v;
  GetScoreData(
      {required this.id,
        required this.studentId,
        required this.category,
        required this.testType,
        required this.time,
        required this.angleScore,
        required this.teacherScore, required this.round,
        required this.v, required this.wrongImage
      });

  factory GetScoreData.fromJson(Map<String, dynamic> json) => GetScoreData(
      id: json["_id"],
      studentId: json["studentId"],
      category: json["category"],
      testType: json["testType"],
      time: json["time"],
      wrongImage: json["wrongImage"],
      angleScore: json["angleScore"],
      teacherScore: json["totalScore"],
      round: json["round"],
      v: json["__v"]);

  Map<String, dynamic> toJson() => {
    "_id": id,
    "student": studentId,
    "category": category,
    "testType": testType,
    "wrongImage": wrongImage,
    "time": time,
    "angleScore": angleScore,
    "totalScore": teacherScore,
    "round":round,
    "__v": v,
  };
}
