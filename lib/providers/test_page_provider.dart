import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:ai_score/models/add_score_pose30_request.dart';
import 'package:ai_score/models/pose_compare_id9.1_response.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:universal_io/io.dart';

import 'package:ai_score/enum/view_state.dart';
import 'package:ai_score/fetch_data_exception.dart';
import 'package:ai_score/helper/dialog_helper.dart';
import 'package:ai_score/helper/shared_pref.dart';
import 'package:ai_score/json/category_json.dart';
import 'package:ai_score/models/add_edit_student_response.dart' as studentData;
import 'package:ai_score/models/add_score_request.dart';
import 'package:ai_score/models/category_list_model.dart';
import 'package:ai_score/providers/base_provider.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../models/get_last_score.dart';

class TestPageProvider extends BaseProvider {
  List<ScoresList> totalScores = [];
  int? round;

  final token = SharedPref.prefs?.getString(SharedPref.token) ?? '';

  List<studentData.Data> studentsDataList1 = [];
  List<studentData.Data> studentsDataList2 = [];
  List<studentData.Data> studentsDataList3 = [];
  List<studentData.Data> studentsDataList4 = [];
  List<studentData.Data> studentsDataList5 = [];
  String? studentId1;
  String? studentId2;
  String? studentId3;
  String? studentId4;
  String? studentId5;
  String studentDropDown1 = "";
  String studentDropDown2 = "";
  String studentDropDown3 = "";
  String studentDropDown4 = "";
  String studentDropDown5 = "";

  List<CategoryList> categoryList = [];
  String categoryDropDownValue = "";
  String? categoryDropDownValueId;
  List<dynamic> aiScoreList = [];
  List<dynamic> aiScoreListPose = [];
  List<dynamic> aiScoreListPose1 = [];

  List<dynamic> aiScoreListPose2 = [];

  bool isSwitched = false;
  int selectedCameraIndex = 0;

  /// declare a cound variable with initial value
  int secondsCount = 0;

  int minuteCount = 0;

  /// declare a timer
  Timer? timer;

  bool data = false;
  bool buttonActivity = false;
  updateButtonActivity(){

    buttonActivity = true;
    notifyListeners();


  }
  updateButtonActivityToFalse(){

    buttonActivity = false;
    notifyListeners();


  }


  updateData(bool val) {
    data = val;
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool getStudentData = false;

  updateGetStudentData(bool val) {
    getStudentData = val;
    notifyListeners();
  }

  Future<bool> getStudentsData(BuildContext context) async {
    updateGetStudentData(true);
    try {
      var model = await api.getStudents(token);
      if (model.success == true) {
        studentsDataList1.clear();
        studentsDataList2.clear();
        studentsDataList3.clear();
        studentsDataList4.clear();
        studentsDataList5.clear();
        studentsDataList1.insert(
            0, studentData.Data(id: "select_student1".tr()));
        studentsDataList2.insert(
            0, studentData.Data(id: "select_student2".tr()));
        studentsDataList3.insert(
            0, studentData.Data(id: "select_student3".tr()));
        studentsDataList4.insert(
            0, studentData.Data(id: "select_student4".tr()));
        studentsDataList5.insert(
            0, studentData.Data(id: "select_student5".tr()));

        studentsDataList1.addAll(model.studentDataList);
        studentsDataList2.addAll(model.studentDataList);
        studentsDataList3.addAll(model.studentDataList);
        studentsDataList4.addAll(model.studentDataList);
        studentsDataList5.addAll(model.studentDataList);

        // for(int i = 0 ; i < studentsDataList.length ; i++){
        //   studentNames.add(studentsDataList[i].studentName.toString());
        // }
        studentDropDown1 = studentsDataList1[0].id!;
        studentDropDown2 = studentsDataList2[0].id!;
        studentDropDown3 = studentsDataList3[0].id!;
        studentDropDown4 = studentsDataList4[0].id!;
        studentDropDown5 = studentsDataList5[0].id!;
        //  print(studentNames);
      } else {
        DialogHelper.showMessage(context, model.message);
      }
      updateGetStudentData(false);
      return true;
    } on FetchDataException catch (c) {
      updateGetStudentData(false);
      DialogHelper.showMessage(context, c.toString());
      return false;
    } on SocketException catch (c) {
      updateGetStudentData(false);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  getCategoryData() {
    var response = CategoryListModel.fromJson(
        SharedPref.prefs!.getString(SharedPref.userType) == "Teacher"
            ? categoryDataTeacher
            : categoryData);
    categoryList.insert(0, CategoryList(categoryName: "category".tr()));
    categoryList.addAll(response.categoryList);
    categoryDropDownValue = categoryList[0].categoryName!;
  }

  Future<bool> addScores(BuildContext context, String category, String time,
      List<Students> students, String image) async {
    //updateUploadVideo(true);
    try {
      var model = await api.addScores(category, time, students, image, token);
      if (model.success == true) {
        updateUploadVideo(false);

      } else {

        updateUploadVideo(false);
      }
      updateUploadVideo(false);
      return true;
    } on FetchDataException catch (c) {
      updateUploadVideo(false);
      DialogHelper.showMessage(context, c.toString());
      return false;
    } on SocketException catch (c) {
      updateUploadVideo(false);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  Future<bool> addScoresPose30(BuildContext context, var time,
      List<CategoryDetail> modelDataList) async {
    List<String?> studentIdList = [
      studentId1,
      studentId2,
      studentId3,
      studentId4,
      studentId5
    ];
    try {
      print("Inside AddScorePose30 Api");
      print("${time}""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      var model = await api.addScoresPose30(context, token, time, modelDataList, studentIdList);
      if (model.success == true) {
        DialogHelper.showMessage(context, "Api hit Successfully AddScorePose 30");
        updateUploadVideo(false);
      } else {
        DialogHelper.showMessage(context, model.message);
        updateUploadVideo(false);
      }
      updateUploadVideo(false);
      return true;
    } on FetchDataException catch (c) {
      updateUploadVideo(false);
      DialogHelper.showMessage(context, c.toString());
      return false;
    } on SocketException catch (c) {
      print("SocketException++++++++++++++++++++++++++++++++++++++++++++++++");
      updateUploadVideo(false);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  bool updateVideo = false;

  updateUploadVideo(bool val) {
    updateVideo = val;
    notifyListeners();
  }

  Future<bool> uploadVideo(BuildContext context, XFile videoFile) async {
    updateUploadVideo(true);
    try {
    /*  var bytes=await videoFile.length();
      if (bytes <= 0)  print("0 B") ;
      const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
      var i = (log(bytes) / log(1024)).floor();
      var value= ((bytes / pow(1024, i)).toStringAsFixed(1)) + ' ' + suffixes[i];
      print("size of file is ${value}");*/
      var model = await api.uploadVideo(token, videoFile);
      print("upload video url ${model.data}");
      if (model.success == true) {await poseCompare(context, categoryDropDownValueId!, model.data!);
        minuteCount = 0;
        secondsCount =0;
        updateUploadVideo(false);
        //    DialogHelper.showMessage(context, "video_uploaded_successfully".tr());
      } else {
        DialogHelper.showMessage(context, "something_went_wrong".tr());
      }
      updateUploadVideo(false);
      return true;
    } on FetchDataException catch (c) {
      updateUploadVideo(false);
      DialogHelper.showMessage(context, c.toString());
      return false;
    } on SocketException catch (c) {
      updateUploadVideo(false);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  // bool comparePose = false;
  //
  // updateComparePose(bool val){
  //   comparePose = val;
  //   notifyListeners();
  // }

  Future<bool> poseCompare(
      BuildContext context, String scoreId, String videoUrl) async {
    updateUploadVideo(true);
    try {
      if (scoreId == "9.1") {
        var model = await api.poseCompareTotalScore(videoUrl);
        if (model.status == true) {
          await addScoresPose30(context, int.parse(minuteCount == 1 ? (secondsCount + 60).toString() : (minuteCount == 2 ? (secondsCount + 120).toString() : secondsCount.toString())), model.data);
          secondsCount = 0;
          minuteCount = 0;
          updateUploadVideo(false);
        } else {

          updateUploadVideo(false);

        }
        updateUploadVideo(false);
      } else {
        var model = await api.poseCompare(scoreId, videoUrl);
        if (model.status == true) {
          aiScoreList = model.data!.scores!;

          await addScores(
              context,
              categoryDropDownValueId!,
              minuteCount == 1
                  ? (secondsCount + 60).toString()
                  : (minuteCount == 2
                      ? (120).toString()
                      : secondsCount.toString()),
              [
                Students(
                    studentId: studentId1, score: aiScoreList[0].toString()),
                Students(
                    studentId: studentId2,
                    score: aiScoreList.length > 1
                        ? aiScoreList[1].toString()
                        : null),
                Students(
                    studentId: studentId3,
                    score: aiScoreList.length > 2
                        ? aiScoreList[2].toString()
                        : null),
                Students(
                    studentId: studentId4,
                    score: aiScoreList.length > 3
                        ? aiScoreList[3].toString()
                        : null),
                Students(
                    studentId: studentId5,
                    score: aiScoreList.length > 4
                        ? aiScoreList[4].toString()
                        : null)
              ],
              model.data!.badPoses.toString());
          secondsCount = 0;
          minuteCount = 0;
          updateUploadVideo(false);
          // DialogHelper.showMessage(context, models.message.toString());
        } else {
          DialogHelper.showMessage(context, "something_went_wrong_try".tr());
          updateUploadVideo(false);
        }
      }

      updateUploadVideo(false);
      return true;
    } on FetchDataException catch (c) {
      print(c.toString());
      print("Exception------------------------------------------------------");
      updateUploadVideo(false);
      return false;
    } on SocketException catch (c) {
      print("SocketException------------------------------------------------------");
      updateUploadVideo(false);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  Future<void> uploadVideoStudent(BuildContext context, XFile videoFile) async {
    setState(ViewState.Busy);
    try {
      var model = await api.uploadVideoStudent(videoFile);
      if (model.success == true) {
        poseCompareStudent(context, model.data!, categoryDropDownValueId!,
            minuteCount + secondsCount);
      } else {
        DialogHelper.showMessage(context, model.message);
      }
    } on FetchDataException catch (c) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, c.toString());
    } on SocketException catch (c) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
    }
  }

  Future<void> poseCompareStudent(
      BuildContext context, String videoUrl, String scoreId, int time) async {
    try {
      var model = await api.poseCompare(scoreId, videoUrl);
      print(model.toString() +
          "+++++++++++++++++++++++++++++++++++++++++++++++++");
      if (model.status == true) {
        await addScoreVideoStudent(context, scoreId, time,
            model.data!.badPoses!, model.data!.scores![0]);
      } else {
        DialogHelper.showMessage(context, "oops something went wrong");
      }
    } on FetchDataException catch (c) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, c.toString());
    } on SocketException catch (c) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
    }
  }

  Future<void> addScoreVideoStudent(BuildContext context, String category,
      int time, String pose, double score) async {
    setState(ViewState.Busy);
    try {
      var model = await api.addScoreVideoStudent(
          context, category, time, pose, score.toString());
      if (model.success) {
        setState(ViewState.Busy);
        getLastScoreData(context, category);
      } else {
        DialogHelper.showMessage(context, model.message);
      }
    } on FetchDataException catch (e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.toString());
    } on SocketException catch (e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.toString());
    }
  }

  Future<void> getLastScoreData(
    BuildContext context,
    String category,
  ) async {
    setState(ViewState.Busy);
    try {
      var model = await api.getLastScores(
        context,
        category,
      );
      if (model.success) {
        round = model.data!.round;
        totalScores = model.data!.scores;
        setState(ViewState.Idle);
      }

      setState(ViewState.Idle);
    } on FetchDataException catch (e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.toString());
    } on SocketException catch (e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.toString());
    }
  }

  final player = AudioPlayer();

  startPlayer() async {
    await player.setAsset('audios/clientAudio.mp3');
  }

  stopPlayer() async {
    await player.stop();
  }

  startThePlayer() async {
    await player.play();
  }
}
