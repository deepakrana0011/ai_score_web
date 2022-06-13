class AddScoreRequest {
  String? category;
  String? time;
  List<Students>? students;
  List<int> scores = [];

  AddScoreRequest({this.category, this.time, this.students});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['category'] = category;
    data['time'] = time;
    if (students != null) {
      data['students'] = students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Students {
  String? studentId;
  String? score;

  Students({this.studentId, this.score});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['studentId'] = studentId;
    data['score'] = score;
    return data;
  }
}