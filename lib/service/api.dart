import 'dart:convert';
import 'dart:typed_data';
import 'package:ai_score/helper/dialog_helper.dart';
import 'package:ai_score/models/add_score_pose30_request.dart';
import 'package:ai_score/models/add_score_response_pose30.dart';
import 'package:ai_score/models/pose_compare_id9.1_response.dart';
import 'package:ai_score/models/pose_compare_response.dart';
import 'package:ai_score/models/studentDataToServer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:universal_io/io.dart';

import 'package:ai_score/constants/api_constants.dart';
import 'package:ai_score/fetch_data_exception.dart';
import 'package:ai_score/locator.dart';
import 'package:ai_score/models/add_edit_student_response.dart';
import 'package:ai_score/models/add_score_request.dart';
import 'package:ai_score/models/chart_data_response.dart';
import 'package:ai_score/models/get_scores_response.dart';
import 'package:ai_score/models/get_student_response.dart';
import 'package:ai_score/models/login_response.dart';
import 'package:ai_score/models/success_response.dart';
import 'package:ai_score/models/update_score_response.dart';
import 'package:ai_score/models/upload_video_response.dart';
import 'package:ai_score/providers/test_page_provider.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../helper/shared_pref.dart';
import '../models/add_score_student.dart';
import '../models/get_last_score.dart';
import '../models/get_score_student_side_response.dart';
import '../models/student_side_charData_Response.dart';

class Api {
  var client = http.Client();
  Dio dio = locator<Dio>();

  Future<LoginResponse> login(String email, String password) async {
    try {
      var map = {"email": email, "password": password};
      var response =
          await dio.post(ApiConstants.baseUrl + ApiConstants.login, data: map);
      return LoginResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["message"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<AddEditStudentResponse> addStudent(String studentName,
      String studentNo, String password, String token) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      var map = {
        "studentName": studentName,
        "studentNo": studentNo,
        "password": password
      };

      var response = await dio
          .post(ApiConstants.baseUrl + ApiConstants.addStudent, data: map);
      return AddEditStudentResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["message"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<AddEditStudentResponse> editStudent(String studentName,
      String studentNo, String studentId, String status, String token) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      var map = {
        "studentName": studentName,
        "studentNo": studentNo,
        "studentId": studentId,
        "status": status
      };

      var response = await dio
          .put(ApiConstants.baseUrl + ApiConstants.editStudent, data: map);
      return AddEditStudentResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["message"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<GetStudentsResponse> getStudents(String token) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      var response =
          await dio.get(ApiConstants.baseUrl + ApiConstants.getStudentsData);
      return GetStudentsResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["message"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<SuccessResponse> changePassword(
      String studentId, String password, String token) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      var map = {"studentId": studentId, "password": password};

      var response = await dio
          .put(ApiConstants.baseUrl + ApiConstants.changePassword, data: map);
      return SuccessResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["message"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<SuccessResponse> addScores(String category, String time,
      List<Students> students, String image, String token) async {
    var list = jsonEncode(students.map((e) => e.toJson()).toList());
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      var map = {
        "category": category,
        "time": time,
        "student": list,
        "image": image
      };
      var response = await dio
          .post(ApiConstants.baseUrl + ApiConstants.addScores, data: map);
      return SuccessResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["message"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<AddScorePose30Response> addScoresPose30(
      BuildContext context,
      String token,
      var time,
      List<CategoryDetail> modelDataList,
      List<String?> studentIdList) async {
    print("yaay inside add score pose 30");
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      var map1 = <String, dynamic>{"time": time};
      List<CategoryDetailServer> categoryData = [];
      for (int i = 0; i < modelDataList.length; i++) {
        var studentData = CategoryDetailServer();
        studentData.category = modelDataList[i].category;
        studentData.image = modelDataList[i].image;
        List<StudentDetail> studentList = [];
        if (modelDataList[i].scores.isEmpty) {
          for (var element in studentIdList) {
            var student = StudentDetail();
            student.score = 0;
            student.studentId = element;
            studentList.add(student);
          }
          studentData.student = studentList;
          categoryData.add(studentData);
        } else {
          for (int k = 0; k < modelDataList[i].scores.length; k++) {
            var student = StudentDetail();
            student.score = modelDataList[i].scores[k];
            student.studentId = studentIdList[k];
            studentList.add(student);
          }
          studentData.student = studentList;
          categoryData.add(studentData);
        }
      }
      var jsonEncoded =
          jsonEncode(categoryData.map((e) => e.toJson()).toList());
      var map2 = {"data": jsonEncoded};
      map1.addAll(map2);
      print("data is hitting $map1");
      var response = await dio
          .post(ApiConstants.baseUrl + ApiConstants.addScorePose30, data: map1);
      // DialogHelper.showMessage(context, "After hit the AddScoreApi");
      print("api hit successfully");
      return AddScorePose30Response.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["message"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<GetScoreResponse> getScores(String category, String date,
      bool categoryParam, bool dateParam, String token, int pageCount) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      var map = {"category": category, "date": date, "page": pageCount};
      if (dateParam && categoryParam) {
        map = {"category": category, "date": date, "page": pageCount};
      } else if (dateParam) {
        map = {"date": date, "page": pageCount};
      } else if (dateParam) {
        map = {"category": category, "page": pageCount};
      } else {
        map = {"page": pageCount};
      }
      var response = await dio.get(
          ApiConstants.baseUrl + ApiConstants.getScores,
          queryParameters: map);
      return GetScoreResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["message"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<UpdateScoreResponse> updateScores(String scoreId, String angleScore,
      String teacherScore, String token) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      var map = {
        "scoreId": scoreId,
        "angleScore": angleScore,
        "teacherScore": teacherScore
      };

      var response = await dio
          .put(ApiConstants.baseUrl + ApiConstants.updateScores, data: map);
      return UpdateScoreResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["message"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<ChartDataResponse> chartData(String token) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      var response =
          await dio.get(ApiConstants.baseUrl + ApiConstants.chartData);
      return ChartDataResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["message"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<UploadVideoResponse> uploadVideo(String token, XFile video) async {
    try {
      Uint8List bytes = await video.readAsBytes();
      dio.options.headers["Authorization"] = "Bearer $token";
      var videoDocument =
          MultipartFile.fromBytes(bytes, filename: "aiVideo.mp4");
      var videoMap = {"video": videoDocument};
      var response = await dio.post(
          ApiConstants.baseUrl + ApiConstants.uploadVideo,
          data: FormData.fromMap(videoMap));
      return UploadVideoResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["message"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<SuccessResponse> deleteStudent(String id, String token) async {
    try {
      dio.options.headers["Authorization"] = "Bearer $token";
      var response = await dio
          .delete(ApiConstants.baseUrl + ApiConstants.deleteStudent + id);
      return SuccessResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["message"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<PoseCompareResponse> poseCompare(
      String scoreId, String videoUrl) async {
    try {
      var map = <String, dynamic>{
        "actionId": scoreId,
        "videoUrl": "https://m.vanasy.cn:8080/" + videoUrl
      };
      var response =
          await dio.get(ApiConstants.aiPoseCompare, queryParameters: map);
      return PoseCompareResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        // var errorData = jsonDecode(e.response.toString());
        // var errorMessage = errorData["message"];
        throw FetchDataException("Did not get score, please try again");
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<PoseCompareResponse30> poseCompareTotalScore(String videoUrl) async {
    try {
      var map = <String, dynamic>{"videoUrl": "https://m.vanasy.cn:8080/" +videoUrl};
      //var map = <String, dynamic>{"videoUrl": videoUrl};
      var response =
          await dio.get(ApiConstants.aiPoseCompareId30, queryParameters: map);
      print("jit pose compare successfully");
      return PoseCompareResponse30.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        //  print("!!!!!!!!getting exception 500");
        //    var errorData = jsonDecode(e.response.toString());
        //    var errorMessage = errorData["message"];
        //   print(errorMessage);
        throw FetchDataException("Did not get score, please try again");
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<GetScoreStudentSideResponse> getScoreStudentSide(
      BuildContext context, String category, String score) async {
    try {
      dio.options.headers["Authorization"] =
          "Bearer " + SharedPref.prefs!.getString(SharedPref.token).toString();

      var map = {"category": category, "score": score};
      var id = SharedPref.prefs?.getString(SharedPref.userId);

      var response = await dio.get(
        ApiConstantsStudentSide.baseUrlStudentSide +
            ApiConstantsStudentSide.getStudentScore +
            id!,
        queryParameters: map,
      );
      return GetScoreStudentSideResponse.fromJson(
          json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = json.decode(e.response.toString());
        var errorMessage = errorData["message"];
        throw FetchDataException(errorMessage);
      } else {
        throw SocketException("did not get score try again");
      }
    }
  }

  Future<UploadVideoResponse> uploadVideoStudent(XFile video) async {
    try {
      Uint8List bytes = await video.readAsBytes();
      print("${bytes.length}" "+++++++++++++++++++++++++++++++++++++++");
      dio.options.headers["Authorization"] =
          "Bearer " + SharedPref.prefs!.getString(SharedPref.token).toString();
      var videoDocument =
          MultipartFile.fromBytes(bytes, filename: "aiVideo.mp4");
      var videoMap = {"video": videoDocument};
      var response = await dio.post(
          ApiConstantsStudentSide.baseUrlStudentSide +
              ApiConstantsStudentSide.uploadVideoStudent,
          data: FormData.fromMap(videoMap));
      // var responseString = response.toString();
      return UploadVideoResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["error"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("did not get score try again");
      }
    }
  }

  Future<PoseCompareResponse> poseCompareStudent(
      String scoreId, String videoUrl) async {
    try {
      var map = <String, dynamic>{
        "actionId": scoreId,
        "videoUrl": ApiConstantsStudentSide.baseUrlStudentSide + videoUrl
      };
      var response = await dio.get(ApiConstantsStudentSide.aiPoseCompare,
          queryParameters: map);
      return PoseCompareResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        /*var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["message"];*/
        throw FetchDataException("Didn't get the score. Please try again");
      } else {
        throw const SocketException("did not get score try again");
      }
    }
  }

  Future<AddScoreResponse> addScoreVideoStudent(BuildContext context,
      String category, int time, String pose, String score) async {
    try {
      dio.options.headers["Authorization"] =
          "Bearer " + SharedPref.prefs!.getString(SharedPref.token).toString();
      var map = {
        "studentId": SharedPref.prefs!.getString(SharedPref.userId),
        "category": category,
        "time": time,
        "image": pose,
        "score": score
      };
      var response = await dio.post(
          ApiConstantsStudentSide.baseUrlStudentSide +
              ApiConstantsStudentSide.addScore,
          data: map);
      return AddScoreResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["message"];
        throw FetchDataException(errorMessage);
      } else {
        throw SocketException("did not get score try again");
      }
    }
  }

  Future<GetStudentChartData> getStudentChartData(
    BuildContext context,
  ) async {
    try {
      dio.options.headers["Authorization"] =
          "Bearer " + SharedPref.prefs!.getString(SharedPref.token).toString();
      var response = await dio.get(ApiConstantsStudentSide.baseUrlStudentSide +
          ApiConstantsStudentSide.chartData);

      return GetStudentChartData.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["message"];
        throw FetchDataException(errorMessage);
      } else {
        throw SocketException("did not get score try again");
      }
    }
  }

  Future<GetLastScoreResponse> getLastScores(
      BuildContext context, String category) async {
    try {
      dio.options.headers["Authorization"] =
          "Bearer " + SharedPref.prefs!.getString(SharedPref.token).toString();

      var map = {"category": category};
      var id = SharedPref.prefs?.getString(SharedPref.userId);

      var response = await dio.get(
          ApiConstantsStudentSide.baseUrlStudentSide +
              ApiConstantsStudentSide.lastScore +
              id!,
          queryParameters: map);
      return GetLastScoreResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = json.decode(e.response.toString());
        var errorMessage = errorData["message"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("did not get score try again");
      }
    }
  }
}
