/*
class PoseCompare30 {
  List<Data>? data;
  String? message;
  bool? status;


  PoseCompare30.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }


}

class Data {
  String? category;
  String? badPoses;
  List<double>? scores;

  Data.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    badPoses = json['image'];
    scores = json['scores'].cast<double>();
  }
}*/
class PoseCompareResponse30 {
  PoseCompareResponse30({
    required this.data,
    required this.message,
    required this.status,
  });

  List<CategoryDetail> data;
  String message;
  bool status;

  factory PoseCompareResponse30.fromJson(Map<String, dynamic> json) => PoseCompareResponse30(
    data: List<CategoryDetail>.from(json["data"].map((x) => CategoryDetail.fromJson(x))),
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
    "status": status,
  };
}

class CategoryDetail {
  CategoryDetail({
    required this.category,
    required this.image,
    required this.scores,
    required this.score
  });

  String category;
  String image;
  List<double> scores;
  int? score;

  factory CategoryDetail.fromJson(Map<String, dynamic> json) => CategoryDetail(
    category: json["category"],
    image: json["image"],
    scores: json["scores"] == 0 ? [] : List<double>.from(json["scores"].map((x) => x.toDouble())),
    score : json["scores"] ?? null
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "image": image,
    "scores": List<dynamic>.from(scores.map((x) => x)),
  };
}


