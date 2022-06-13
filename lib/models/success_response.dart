class SuccessResponse{

  late bool success;
  late String message = " ";

  SuccessResponse();

  SuccessResponse.fromJson(Map<String, dynamic> parsedJson){
    success = parsedJson['success'];
    if(parsedJson['message'] != null){
      message = parsedJson['message'];
    }
  }
}