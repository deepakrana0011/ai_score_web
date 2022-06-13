class ChartDataResponse {
  bool? success;
  Data? data;

  ChartDataResponse({this.success, this.data});

  ChartDataResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

}

class Data {
  int? practiceCount;
  double? avgPracticeTime;
  double? avgPracticeScore;
  List<Exams>? exams;
  int? totalTime;
  dynamic score;
  int? percentage;
  dynamic teacherScore;
  dynamic avgScore;
  dynamic totalcount;
  List<Scores>? scores;


  Data.fromJson(Map<String, dynamic> json) {
    practiceCount = json['practiceCount'];
    avgPracticeTime = json['avgPracticeTime'];
    avgPracticeScore = json['avgPracticeScore'];
    if (json['exams'] != null) {
      exams = <Exams>[];
      json['exams'].forEach((v) {
        exams!.add( Exams.fromJson(v));
      });
    }
    totalTime = json['totalTime'];
    score = json['score'];
    percentage = json['percentage'];
    teacherScore = json['teacherScore'];
    avgScore = json['avgScore'];
    totalcount = json['totalcount'];
    if (json['scores'] != null) {
      scores = <Scores>[];
      json['scores'].forEach((v) {
        scores!.add(new Scores.fromJson(v));
      });
    }
  }
}

class Exams {
  int? iId;
  int? category;
  int? count;
  int? totalTime;
  dynamic totalScore;
  dynamic totalAIScore;

  Exams.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    category = json['category'];
    count = json['count'];
    totalTime = json['totalTime'];
    totalScore = json['totalScore'];
    totalAIScore = json['totalAIScore'];
  }
}

class Scores {
  String? sId;
  dynamic month;
  dynamic totalAIScore;
  dynamic totalScore;
  dynamic totalTeacherScore;
  String? createdAt;


  Scores.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    month = json['month'];
    totalAIScore = json['totalAIScore'];
    totalScore = json['totalScore'];
    totalTeacherScore = json['totalTeacherScore'];
    createdAt = json['createdAt'] ?? "";
  }
}

