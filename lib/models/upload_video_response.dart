import 'package:ai_score/models/success_response.dart';

class UploadVideoResponse extends SuccessResponse{
  String? data;

  UploadVideoResponse.fromJson(Map<String, dynamic> parsedJson) : super.fromJson(parsedJson){
    if(parsedJson['data'] != null){
      data = parsedJson['data'];
    }
  }
}