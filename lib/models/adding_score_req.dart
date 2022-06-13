// class AddingScoreRequest {
//   int? time;
//   List<Data>? data;
//
//   AddingScoreRequest({this.time, this.data});
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['time'] = this.time;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   int? category;
//   String? image;
//   List<List<StudentAdd>>? student;
//
//   Data({this.category, this.image, this.student});
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['category'] = this.category;
//     data['image'] = this.image;
//     if (this.student != null) {
//       data['student'] = this.student!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class StudentAdd {
//   String? studentId;
//   double? score;
//
//   StudentAdd({this.studentId, this.score});
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['studentId'] = this.studentId;
//     data['score'] = this.score;
//     return data;
//   }
// }