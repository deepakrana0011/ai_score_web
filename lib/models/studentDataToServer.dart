// To parse this JSON data, do
//
//     final studentDataToServer = studentDataToServerFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';


class CategoryDetailServer {
  CategoryDetailServer({
    this.category,
    this.image,
    this.student,
  });

  String? category;
  String? image;
  List<StudentDetail>? student;

  factory CategoryDetailServer.fromJson(Map<String, dynamic> json) => CategoryDetailServer(
    category: json["category"],
    image: json["image"],
    student: List<StudentDetail>.from(json["student"].map((x) => StudentDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "image": image,
    "student": List<dynamic>.from(student!.map((x) => x.toJson())),
  };

}

class StudentDetail {
  StudentDetail({
     this.studentId,
     this.score,
  });

  String? studentId;
  double? score;

  factory StudentDetail.fromJson(Map<String, dynamic> json) => StudentDetail(
    studentId: json["studentId"],
    score: json["score"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "studentId": studentId,
    "score": score,
  };
}
