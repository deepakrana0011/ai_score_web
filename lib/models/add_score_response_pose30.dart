class AddScorePose30Response {
  AddScorePose30Response({
    required this.success,
    required this.message,
    required this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory AddScorePose30Response.fromJson(Map<String, dynamic> json) => AddScorePose30Response(
    success: json["success"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.studentId,
    required this.category,
    required this.testType,
    required this.time,
    required this.wrongImage,
    required this.angleScore,
    required this.teacherScore,
    required this.totalScore,
    required this.id,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
    required this.datumId,
  });

  String studentId;
  double category;
  int testType;
  int time;
  String wrongImage;
  double angleScore;
  int teacherScore;
  double totalScore;
  String id;
  int v;
  DateTime createdAt;
  DateTime updatedAt;
  String datumId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    studentId: json["studentId"],
    category: json["category"].toDouble(),
    testType: json["testType"],
    time: json["time"],
    wrongImage: json["wrongImage"],
    angleScore: json["angleScore"].toDouble(),
    teacherScore: json["teacherScore"],
    totalScore: json["totalScore"].toDouble(),
    id: json["_id"],
    v: json["__v"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    datumId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "studentId": studentId,
    "category": category,
    "testType": testType,
    "time": time,
    "wrongImage": wrongImage,
    "angleScore": angleScore,
    "teacherScore": teacherScore,
    "totalScore": totalScore,
    "_id": id,
    "__v": v,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "id": datumId,
  };
}
