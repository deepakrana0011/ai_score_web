class AddScoreResponse {
  bool success;
  String message;

  AddScoreResponse({required this.success, required this.message});

  factory AddScoreResponse.fromJson(Map<String, dynamic> json) =>
      AddScoreResponse(success: json['success'], message: json['message']);

  Map<String, dynamic> toJson() => {"success": success, "message": message};
}
