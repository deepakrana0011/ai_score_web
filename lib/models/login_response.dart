import 'package:ai_score/models/success_response.dart';

class LoginResponse extends SuccessResponse{
 late Data data;

  LoginResponse.fromJson(Map<String, dynamic> parsedJson) : super.fromJson(parsedJson){
    if (parsedJson['data'] != null) {
      data = Data.fromJson(parsedJson['data']);
    }
  }
}

class Data{
  String? id;
  String? email;
  String? name;
  String? token;
  String? type;

  Data.fromJson(Map<String, dynamic> parsedJson){
    id = parsedJson['_id'];
    email = parsedJson['email'];
    name = parsedJson['name'];
    token = parsedJson['token'];
    type = parsedJson['type'];
  }
}