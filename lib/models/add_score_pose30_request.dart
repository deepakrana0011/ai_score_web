class AddScoreTotal30Request {
  AddScoreTotal30Request({this.time, this.data});
  int? time;
  List<List<StudentPose30>>? data = [];
}

class StudentPose30 {
  dynamic category;
  String? image;
  List<List<Student1>> student = [];

}

class Student1 {
  String? studentId;
  String? score;

  Student1({this.studentId, this.score});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['studentId'] = studentId;
    data['score'] = score;
    return data;
  }
}
