

class GetStudentChartData {
  bool? success;
  Data? data;

  GetStudentChartData({this.success, this.data});

  GetStudentChartData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }


}

class Data {
  int? practiceCount;
  double? avgPracticeTime;
  double? avgPracticeScore;
  int? totalTime;
  List<Exams>? exams;
  double? score;
  int? teacherScore;
  int? avgScore;
  int? totalcount;
  List<Scores>? scores;

  Data(
      {this.practiceCount,
        this.avgPracticeTime,
        this.avgPracticeScore,
        this.totalTime,
        this.exams,
        this.score,
        this.teacherScore,
        this.avgScore,
        this.totalcount,
        this.scores});

  Data.fromJson(Map<String, dynamic> json) {
    practiceCount = json['practiceCount'];
    avgPracticeTime = json['avgPracticeTime'];
    avgPracticeScore = json['avgPracticeScore'];
    totalTime = json['totalTime'];
    if (json['exams'] != null) {
      exams = <Exams>[];
      json['exams'].forEach((v) {
        exams!.add(Exams.fromJson(v));
      });
    }
    score = json['score'];
    teacherScore = json['teacherScore'];
    avgScore = json['avgScore'];
    totalcount = json['totalcount'];
    if (json['scores'] != null) {
      scores = <Scores>[];
      json['scores'].forEach((v) {
        scores!.add(Scores.fromJson(v));
      });
    }
  }


}

class Exams {
  int? iId;
  int? category;
  int? count;
  int? totalTime;
  double? totalScore;
  double? totalAIScore;
  int? teacherScore;

  Exams(
      {this.iId,
        this.category,
        this.count,
        this.totalTime,
        this.totalScore,
        this.totalAIScore,
        this.teacherScore});

  Exams.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    category = json['category'];
    count = json['count'];
    totalTime = json['totalTime'];
    totalScore = json['totalScore'];
    totalAIScore = json['totalAIScore'];
    teacherScore = json['teacherScore'];
  }


}

class Scores {
  //String? sId;
  int? month;
  int? count;
  double? totalAIScore;
  double? totalScore;
  int? totalTeacherScore;
  String? createdAt;

  Scores(
      {//this.sId,
        this.month,
        this.count,
        this.totalAIScore,
        this.totalScore,
        this.totalTeacherScore,
        this.createdAt});

  Scores.fromJson(Map<String, dynamic> json) {
   // sId = json['_id'];
    month = json['month'];
    count = json['count'];
    totalAIScore = json['totalAIScore'];
    totalScore = json['totalScore'];
    totalTeacherScore = json['totalTeacherScore'];
    createdAt = json['createdAt'];
  }


}