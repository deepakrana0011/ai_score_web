import 'package:ai_score/models/success_response.dart';

class AddEditStudentResponse extends SuccessResponse{
  late Data data;

  AddEditStudentResponse.fromJson(Map<String, dynamic> parsedJson) : super.fromJson(parsedJson){
    if (parsedJson['data'] != null) {
      data = Data.fromJson(parsedJson['data']);
    }
  }
}

class Data{
  String? studentName;
  String? studentNo;
  String? password;
  int? status;
  String? id;
  String? createdDate;
  String? updatedDate;

  Data({this.studentName, this.studentNo, this.password, this.status, this.id});

  Data.fromJson(Map<String, dynamic> parsedJson){
    studentName = parsedJson['studentName'];
    studentNo = parsedJson['studentNo'];
    password = parsedJson['password'];
    status = parsedJson['status'];
    id = parsedJson['_id'];
    createdDate = parsedJson['createdAt'] ?? DateTime.now().toString();
    updatedDate = parsedJson['updatedAt'] ?? DateTime.now().toString();
  }
}