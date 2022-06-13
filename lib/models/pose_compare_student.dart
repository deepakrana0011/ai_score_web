class PoseCompareResponse{
  String? message;
  bool? status;
  Data? data;

  PoseCompareResponse.fromJson(Map<String, dynamic> parsedJson){
    message = parsedJson['message'];
    status = parsedJson['status'];
    if(parsedJson['data'] != null){
      data = Data.fromJson(parsedJson['data']);
    }
  }
}

class Data{
  String? badPoses;
  List<dynamic>? scores = [];

  Data.fromJson(Map<String, dynamic> parsedJson){
    badPoses = parsedJson['bad_poses'];
    scores = parsedJson['scores'];
  }
}