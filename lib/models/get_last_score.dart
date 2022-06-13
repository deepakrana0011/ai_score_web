class GetLastScoreResponse {
  bool success;
  Data? data;

  GetLastScoreResponse({required this.success, required this.data});

  factory GetLastScoreResponse.fromJson(Map<String, dynamic> json) =>
      GetLastScoreResponse(
        success: json['success'],
        data:  Data.fromJson(json["data"]),
      );
  Map<String, dynamic> toJson() => {"success": success, "data": data!.toJson()};
}

class Data {
  int round;
  List<ScoresList> scores;
  Data({required this.round, required this.scores});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    round: json['round'],
    scores: List<ScoresList>.from(
        json["scores"].map((x) => ScoresList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "round": round,
    "scores": scores,
  };
}

class ScoresList {
  String id;
  String id2;
  double totalScore;
  ScoresList({required this.id, required this.totalScore,required this.id2});
  factory ScoresList.fromJson(Map<String, dynamic> json) => ScoresList(
    id: json['id'],
    id2: json['_id'],
    totalScore: json['totalScore'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "_id":id2,
    "totalScore": totalScore,
  };
}
