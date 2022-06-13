import 'package:ai_score/models/get_scores_response.dart';
import 'package:ai_score/models/success_response.dart';

class UpdateScoreResponse extends SuccessResponse{
  Data? data;

  UpdateScoreResponse.fromJson(Map<String, dynamic> parsedJson) : super.fromJson(parsedJson){
    if(parsedJson['data'] != null){
      data = Data(parsedJson);
    }
  }
}