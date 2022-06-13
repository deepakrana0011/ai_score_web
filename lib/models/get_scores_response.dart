import 'package:ai_score/models/success_response.dart';

class GetScoreResponse extends SuccessResponse{

  List<Data> getScores = [];
  int? totalCount;
  GetScoreResponse.fromJson(Map<String, dynamic> parsedJson) : super.fromJson(parsedJson){
    totalCount= parsedJson["totalCount"] ?? 0;
    if(parsedJson['data'] != null){
      List<Data> list = [];
      for(int i = 0 ; i < parsedJson['data'].length ; i++){
        list.add(Data(parsedJson['data'][i]));
      }
      getScores = list;
    }

  }
}

class Data{
  String? id;
  String? studentId;
  double? category;
  int? testType;
  int? time;
  String? wrongImage;
  double? angleScore;
  double? totalScore;
  String? examDate;
  double? teacherScore;
  Student? student;

  Data(Map<String, dynamic>parsedJson){
    id = parsedJson['_id'];
    studentId = parsedJson['studentId'];
    category = parsedJson['category'];
    testType = parsedJson['testType'];
    time = parsedJson['time'];
    wrongImage = parsedJson['wrongImage'];
    angleScore = parsedJson['angleScore'] ?? 0;
    totalScore = parsedJson['totalScore'] ?? 0;
    examDate = parsedJson['examDate'];
    teacherScore = parsedJson['teacherScore'] ?? 0;
    if(parsedJson['student'] != null){
      student = Student(parsedJson['student']);
    }
  }
}


class Student{
  String? sId;
  String? studentName;
  String? studentNo;

  Student(Map<String, dynamic>parsedJson){
    sId = parsedJson['_id'];
    studentName = parsedJson['studentName'];
    studentNo = parsedJson['studentNo'];
  }
}