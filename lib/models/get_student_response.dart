import 'package:ai_score/models/add_edit_student_response.dart' as studentData;
import 'package:ai_score/models/success_response.dart';

class GetStudentsResponse extends SuccessResponse{

  List<studentData.Data> studentDataList = [];

  GetStudentsResponse.fromJson(Map<String, dynamic> parsedJson) : super.fromJson(parsedJson){
    if(parsedJson['data'] != null){
      List<studentData.Data>? list = [];
      for(int i = 0 ; i < parsedJson['data'].length ; i++){
        list.add(studentData.Data.fromJson(parsedJson['data'][i]));
      }
      studentDataList = list;
    }
  }

}
