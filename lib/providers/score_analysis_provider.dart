import 'package:ai_score/enum/view_state.dart';
import 'package:ai_score/fetch_data_exception.dart';
import 'package:ai_score/helper/dialog_helper.dart';
import 'package:ai_score/helper/shared_pref.dart';
import 'package:ai_score/models/chart_data_response.dart' as chart_data;
import 'package:ai_score/models/student_side_charData_Response.dart' as student_chart_data;
import 'package:ai_score/providers/base_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ScoreAnalysisProvider extends BaseProvider{
  final token = SharedPref.prefs?.getString(SharedPref.token) ?? '';

  chart_data.Data? data;
   double? smile;
  double? bow;
  double? greet;
  double? lifeVest;
  double? oxygenMask;
  double? seatBelt;
  double? emExit;
  double? safetyNote;
  student_chart_data.Data? studentData;


  Future<bool> chartData(BuildContext context) async {
    setState(ViewState.Busy);
    try {
      var model =  await api.chartData(token);
      if(model.success == true){
        data = model.data;
        smile = data!.exams![0].totalScore?.toDouble() ?? 0.0;
        bow = data!.exams![1].totalScore?.toDouble() ?? 0.0;
         greet = data!.exams![2].totalScore?.toDouble() ?? 0.0;
        lifeVest = data!.exams![3].totalScore?.toDouble() ?? 0.0;
        oxygenMask = data!.exams![4].totalScore?.toDouble() ?? 0.0;
        seatBelt = data!.exams![5].totalScore?.toDouble() ?? 0.0;
        emExit = data!.exams![6].totalScore?.toDouble() ?? 0.0;
        safetyNote = data!.exams![7].totalScore?.toDouble() ?? 0.0;
      //  DialogHelper.showMessage(context, "score_updated".tr());
      } else{
        DialogHelper.showMessage(context, "something_went_wrong".tr());
      }
      setState(ViewState.Idle);
      return true;
    } on FetchDataException catch (c) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, c.toString());
      return false;
    } on SocketException catch (c) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  totalTimeFun(int sec){
    if(sec < 60){
      return "${sec.toString()} sec";
    } else if(sec > 60){
      int min = sec ~/ 60;
      int second = sec % 60;
      return "${min.toString()} min ${second.toString()} sec";
    }
  }
  Future<void> getStudentChartData(BuildContext context,) async {
    setState(ViewState.Busy);
    try {
      var model = await api.getStudentChartData(context,);

      if (model.success!) {
        studentData = model.data;
        smile = studentData!.exams![0].totalScore?.toDouble() ?? 0.0;
        bow = studentData!.exams![1].totalScore?.toDouble() ?? 0.0;
        greet = studentData!.exams![2].totalScore?.toDouble() ?? 0.0;
        lifeVest = studentData!.exams![3].totalScore?.toDouble() ?? 0.0;
        oxygenMask = studentData!.exams![4].totalScore?.toDouble() ?? 0.0;
        seatBelt = studentData!.exams![5].totalScore?.toDouble() ?? 0.0;
        emExit = studentData!.exams![6].totalScore?.toDouble() ?? 0.0;
        safetyNote = studentData!.exams![7].totalScore?.toDouble() ?? 0.0;

        setState(ViewState.Idle);
      } else {
        setState(ViewState.Idle);

      }
    } on FetchDataException catch (e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.toString());
    } on SocketException catch (e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.toString());
    }
  }














}