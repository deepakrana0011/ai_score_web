import 'dart:math';

import 'package:ai_score/constants/color_constants.dart';
import 'package:ai_score/constants/dimensions_constants.dart';
import 'package:ai_score/constants/image_constants.dart';
import 'package:ai_score/enum/view_state.dart';
import 'package:ai_score/extensions/all_extensions.dart';
import 'package:ai_score/helper/shared_pref.dart';
import 'package:ai_score/providers/score_analysis_provider.dart';
import 'package:ai_score/view/base_view.dart';
import 'package:ai_score/widgets/horizontal_bar_chart.dart' as horizontalChart;
import 'package:ai_score/widgets/horizontal_bar_chart_student.dart';
import 'package:ai_score/widgets/image_view.dart';
import 'package:ai_score/widgets/vertical_bar_chart.dart';
import 'package:ai_score/widgets/vertical_bar_chart_student.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pie_chart/pie_chart.dart';

class ScoreAnalysis extends StatefulWidget {
  const ScoreAnalysis({Key? key}) : super(key: key);

  @override
  _ScoreAnalysisState createState() => _ScoreAnalysisState();
}

class _ScoreAnalysisState extends State<ScoreAnalysis> {
  ScoreAnalysisProvider provider = ScoreAnalysisProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BaseView<ScoreAnalysisProvider>(
      onModelReady: (provider) async {
        this.provider = provider;
        SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ?

         await provider.chartData(context) : await provider.getStudentChartData(context);
        dataMap();
      },
      builder: (context, provider, _) {
        return provider.state == ViewState.Busy
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    Text("getting_data".tr()).semiBoldText(
                        ColorConstants.primaryColor,
                        DimensionsConstants.d18.sp,
                        TextAlign.left),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      DimensionsConstants.d69.w,
                      DimensionsConstants.d10.h,
                      DimensionsConstants.d69.w,
                      DimensionsConstants.d10.h),
                  child: Row(
                    children: [
                    /* SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ?*/
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child:SharedPref.prefs!.getString(SharedPref.userType)=="Teacher" ? Text("exam".tr()).semiBoldText(
                                ColorConstants.primaryColor,
                                DimensionsConstants.d20.sp,
                                TextAlign.left): Text("practice".tr()).semiBoldText(
                                ColorConstants.primaryColor,
                                DimensionsConstants.d20.sp,
                                TextAlign.left),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: DimensionsConstants.d1.w,
                                    color: ColorConstants.primaryColor)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: DimensionsConstants.d458.w,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: DimensionsConstants.d29.w,top: DimensionsConstants.d10.h),
                                      child: Text("totalCount".tr())
                                          .semiBoldText(
                                              ColorConstants.primaryColor,
                                              DimensionsConstants.d20.sp,
                                              TextAlign.left),

                                    ),
                                  color: ColorConstants.colorBluishWhite,
                                ),
                               featuresTable(),
                                SizedBox(
                                  height: DimensionsConstants.d5.h,
                                ),
                                actionsContainer(),
                              ],
                            ),
                          ),
                        ],
                      )/*: Container(),*/,
                      SizedBox(
                        width: DimensionsConstants.d10.w,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text("practice".tr()).semiBoldText(
                                ColorConstants.primaryColor,
                                DimensionsConstants.d20.sp,
                                TextAlign.left),
                          ),
                          Container(
                            height:DimensionsConstants.d520.h,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: DimensionsConstants.d1.w,
                                    color: ColorConstants.color6F6C99)),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: [
                                    practiceCountContainer(),
                                    SizedBox(height: DimensionsConstants.d10.h),
                                    totalScoreContainer()
                                  ],
                                ),
                                SizedBox(width: DimensionsConstants.d8.w),
                                Column(
                                  children: [
                                    averagePracticeTotalTimeContainer(),
                                    SizedBox(height: DimensionsConstants.d10.h),
                                    totalTimeContainer()
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: DimensionsConstants.d20.h),
                          /*SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ?*/
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: SharedPref.prefs!.getString(SharedPref.userType) =="Teacher"? Text("exam".tr()).semiBoldText(
                                    ColorConstants.primaryColor,
                                    DimensionsConstants.d20.sp,
                                    TextAlign.left):Text("practice".tr()).semiBoldText(
                                    ColorConstants.primaryColor,
                                    DimensionsConstants.d20.sp,
                                    TextAlign.left),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: DimensionsConstants.d1.w,
                                        color: ColorConstants.primaryColor)),
                                child: Row(
                                  children: [
                                    SizedBox(width: DimensionsConstants.d2.w),
                                    aiScoreContainer(),
                                    SharedPref.prefs!.getString(SharedPref.userType) == "Teacher"?
                                    SizedBox(width: DimensionsConstants.d10.w):const SizedBox(),
                                    SharedPref.prefs!.getString(SharedPref.userType) == "Teacher"?
                                    teacherScoreContainer(): Container(),
                                    SharedPref.prefs!.getString(SharedPref.userType) == "Teacher"?
                                    SizedBox(width: DimensionsConstants.d10.w):const SizedBox(),
                                    SharedPref.prefs!.getString(SharedPref.userType) == "Teacher"?
                                    totalScoreChartContainer():Container(),
                                  ],
                                ),
                              ),
                            ],
                          ) //Container(),
                        ],
                      )
                    ],
                  ),
                ),
              );
      },
    ));
  }

  Widget featuresTable() {
    return Container(
      height: DimensionsConstants.d526.h,
      width: DimensionsConstants.d458.w,
      decoration: BoxDecoration(
        color: ColorConstants.colorBluishWhite,
        borderRadius:
            BorderRadius.all(Radius.circular(DimensionsConstants.d10.r)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(DimensionsConstants.d50.w,
                  DimensionsConstants.d45.h, 0.0, DimensionsConstants.d40.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("smile".tr()).regularText(ColorConstants.colorBlack,
                      DimensionsConstants.d20.sp, TextAlign.left),
                  Text("bow".tr()).regularText(ColorConstants.colorBlack,
                      DimensionsConstants.d20.sp, TextAlign.left),
                  Text("greet".tr()).regularText(ColorConstants.colorBlack,
                      DimensionsConstants.d20.sp, TextAlign.left),
                  Text("life_vest".tr()).regularText(ColorConstants.colorBlack,
                      DimensionsConstants.d20.sp, TextAlign.left),
                  Text("oxygen_mask".tr()).regularText(
                      ColorConstants.colorBlack,
                      DimensionsConstants.d20.sp,
                      TextAlign.left),
                  Text("seat_belt".tr()).regularText(ColorConstants.colorBlack,
                      DimensionsConstants.d20.sp, TextAlign.left),
                  Text("em_exit".tr()).regularText(ColorConstants.colorBlack,
                      DimensionsConstants.d20.sp, TextAlign.left),
                  Text("safety_note".tr()).regularText(
                      ColorConstants.colorBlack,
                      DimensionsConstants.d20.sp,
                      TextAlign.left),
                ],
              ),
            ),
          ),

          SizedBox(
              width: DimensionsConstants.d201.w,
              child: SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ? horizontalChart.HorizontalBarChart.withSampleData(
                  provider.data!.exams!): HorizontalBarChartStudent.withSampleData(provider.studentData!.exams!)),
          SizedBox(width: DimensionsConstants.d65.w),
        ],
      ),
    );
  }

  Widget practiceCountContainer() {
    return Container(
      height: DimensionsConstants.d250.h,
      width: DimensionsConstants.d384.w,
      decoration: BoxDecoration(
        color: ColorConstants.colorBluishWhite,
        borderRadius:
            BorderRadius.all(Radius.circular(DimensionsConstants.d10.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: DimensionsConstants.d10.h),
          Text("total_practice_count".tr()).regularText(
              ColorConstants.colorBlack,
              DimensionsConstants.d20.sp,
              TextAlign.left),
          SizedBox(height: DimensionsConstants.d35.h),
          Text( SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ? provider.data!.practiceCount.toString():provider.studentData!.practiceCount.toString()).semiBoldText(
              ColorConstants.primaryColor,
              DimensionsConstants.d30.sp,
              TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget totalScoreContainer() {
    return Container(
      height: DimensionsConstants.d250.h,
      width: DimensionsConstants.d384.w,
      decoration: BoxDecoration(
        color: ColorConstants.colorBluishWhite,
        borderRadius:
            BorderRadius.all(Radius.circular(DimensionsConstants.d10.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: DimensionsConstants.d22.h),
          Text("total_average_score".tr()).regularText(
              ColorConstants.colorBlack,
              DimensionsConstants.d20.sp,
              TextAlign.left),
          SizedBox(height: DimensionsConstants.d35.h),
          Text(SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ? provider.data!.avgPracticeScore!.toStringAsFixed(2):provider.studentData!.avgPracticeScore!.toStringAsFixed(2))
              .semiBoldText(ColorConstants.primaryColor,
                  DimensionsConstants.d30.sp, TextAlign.center,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Map<String, double> data = {};

  dataMap() {
    data = {
      "smile".tr(): provider.smile?.toDouble() ?? 0.0,
      "bow".tr(): provider.bow?.toDouble() ?? 0.0,
      "greet".tr(): provider.greet?.toDouble() ?? 0.0,
      "life_vest".tr(): provider.lifeVest?.toDouble() ?? 0.0,
      "oxygen_mask".tr(): provider.oxygenMask?.toDouble() ?? 0.0,
      "seat_belt".tr(): provider.seatBelt?.toDouble() ?? 0.0,
      "em_exit".tr(): provider.emExit?.toDouble() ?? 0.0,
      "safety_note".tr(): provider.safetyNote?.toDouble() ?? 0.0
    };
  }

  final List<Color> _colors = [
    const Color(0xFF503795),
    const Color(0xFFe289f2),
    const Color(0xFFb085ff),
    const Color(0xFF855cf8),
    ColorConstants.colorBluishWhite,
    ColorConstants.colorA1A1A1,
    ColorConstants.color6F6C99,
    Colors.indigo,
  ];

  Widget totalScorePieChart() {
    return PieChart(
      dataMap: data,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 10.2,
      colorList: _colors,
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      ringStrokeWidth: 32,
      // centerText: "HYBRID",
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: false,
        // legendShape: _BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: false,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
    );
  }

  Widget averagePracticeTotalTimeContainer() {
    return Container(
      height: DimensionsConstants.d250.h,
      width: DimensionsConstants.d384.w,
      decoration: BoxDecoration(
        color: ColorConstants.colorBluishWhite,
        borderRadius:
            BorderRadius.all(Radius.circular(DimensionsConstants.d10.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: DimensionsConstants.d10.h),
          Text("average_practice_total_time".tr()).regularText(
              ColorConstants.colorBlack,
              DimensionsConstants.d20.sp,
              TextAlign.left),
          SizedBox(height: DimensionsConstants.d35.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ImageView(path: ImageConstants.clockIcon),
              SizedBox(width: DimensionsConstants.d18.w),
              Container(
                child: Text(SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ? provider.data!.avgPracticeTime!.toStringAsPrecision(2) + " Sec":provider.studentData!.avgPracticeTime!.toStringAsPrecision(2)+" Sec")
                    .semiBoldText(ColorConstants.primaryColor,
                        DimensionsConstants.d30.sp, TextAlign.center,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget totalTimeContainer() {
    return Container(
      height: DimensionsConstants.d250.h,
      width: DimensionsConstants.d384.w,
      decoration: BoxDecoration(
        color: ColorConstants.colorBluishWhite,
        borderRadius:
            BorderRadius.all(Radius.circular(DimensionsConstants.d10.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: DimensionsConstants.d10.h),
          Text("total_time".tr()).regularText(ColorConstants.colorBlack,
              DimensionsConstants.d20.sp, TextAlign.left),
          SizedBox(height: DimensionsConstants.d35.h),
          Text(SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ?    provider.totalTimeFun(provider.data!.totalTime!.toInt()):provider.totalTimeFun(provider.studentData!.totalTime!.toInt()))
              .semiBoldText(ColorConstants.primaryColor,
                  DimensionsConstants.d30.sp, TextAlign.center,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget actionsContainer() {
    return Container(
        padding: EdgeInsets.fromLTRB(DimensionsConstants.d29.w,
            DimensionsConstants.d21.h, DimensionsConstants.d29.w, 0.0),
        height: DimensionsConstants.d241.h,
        width: DimensionsConstants.d458.w,
        decoration: BoxDecoration(
          color: ColorConstants.colorBluishWhite,
          borderRadius:
              BorderRadius.all(Radius.circular(DimensionsConstants.d10.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("total_score".tr()).semiBoldText(ColorConstants.primaryColor,
                DimensionsConstants.d20.sp, TextAlign.left),
            SizedBox(height: DimensionsConstants.d18.h),
            Row(
              children: [
                Text("ai_score".tr()).semiBoldText(ColorConstants.colorBlack,
                    DimensionsConstants.d20.sp, TextAlign.left),
                SizedBox(width: DimensionsConstants.d5.w),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerRight,
                  child: SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ? Text(provider.data!.score.toStringAsFixed(2))
                      .regularText(ColorConstants.colorBlack,
                          DimensionsConstants.d20.sp, TextAlign.left,
                          maxLines: 1, overflow: TextOverflow.ellipsis): Text(provider.studentData!.score!.toStringAsFixed(2))
                      .regularText(ColorConstants.colorBlack,
                      DimensionsConstants.d20.sp, TextAlign.left,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ))
              ],
            ),


            SharedPref.prefs!.getString(SharedPref.userType)== "Teacher" ?
            Row(
              children: [
                Text("teacher_score".tr()).semiBoldText(ColorConstants.colorBlack,
                    DimensionsConstants.d20.sp, TextAlign.left),
                SizedBox(width: DimensionsConstants.d5.w),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerRight,
                  child:SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ?  Text("${provider.data!.teacherScore}").regularText(
                      ColorConstants.colorBlack,
                      DimensionsConstants.d20.sp,
                      TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis):Text("${provider.studentData!.teacherScore}").regularText(
                      ColorConstants.colorBlack,
                      DimensionsConstants.d20.sp,
                      TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ))
              ],
            ): Container(),
            Row(
              children: [
                Text("average_score".tr()).semiBoldText(ColorConstants.colorBlack,
                    DimensionsConstants.d20.sp, TextAlign.left),
                SizedBox(width: DimensionsConstants.d5.w),
                Expanded(
                    child: Container(
                  alignment: Alignment.centerRight,
                  child:SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ? Text(provider.data!.avgScore.toString()).regularText(
                      ColorConstants.colorBlack,
                      DimensionsConstants.d20.sp,
                      TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis):Text(provider.studentData!.avgScore.toString()).regularText(
                      ColorConstants.colorBlack,
                      DimensionsConstants.d20.sp,
                      TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ))
              ],
            ),
          ],
        ),
      );
    
  }

  Widget aiScoreContainer() {
    return Container(
      //   padding: EdgeInsets.fromLTRB(DimensionsConstants.d29.w, DimensionsConstants.d21.h, DimensionsConstants.d29.w, 0.0),
      height: DimensionsConstants.d241.h,
      width: SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ? DimensionsConstants.d254.w : DimensionsConstants.d770.w,
      decoration: BoxDecoration(
        color: ColorConstants.colorBluishWhite,
        borderRadius:
            BorderRadius.all(Radius.circular(DimensionsConstants.d10.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: DimensionsConstants.d10.w),
            child: Text("ai_average_Score".tr()).semiBoldText(
                ColorConstants.primaryColor,
                DimensionsConstants.d15.sp,
                TextAlign.left),
          ),
          Expanded(
              child: SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ? VerticalBarLabelChart.withSampleData(
                  provider.data!.scores!, true, false, false): VerticalBarLabelChartStudent.withSampleData(provider.studentData!.scores!, true, false, false)  ),
        ],
      ),
    );
  }

  Widget teacherScoreContainer() {
    return Container(
      //   padding: EdgeInsets.fromLTRB(DimensionsConstants.d29.w, DimensionsConstants.d21.h, DimensionsConstants.d29.w, 0.0),
      height: DimensionsConstants.d241.h,
      width: DimensionsConstants.d254.w,
      decoration: BoxDecoration(
        color: ColorConstants.colorBluishWhite,
        borderRadius:
            BorderRadius.all(Radius.circular(DimensionsConstants.d10.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: DimensionsConstants.d10.w),
            child: Text("teacher_average_score".tr()).semiBoldText(
                ColorConstants.primaryColor,
                DimensionsConstants.d15.sp,
                TextAlign.left),
          ),
          Expanded(
              child: SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ? VerticalBarLabelChart.withSampleData(
                  provider.data!.scores!, false, true, false): VerticalBarLabelChartStudent.withSampleData(provider.studentData!.scores!, false, true, false) ),
        ],
      ),
    );
  }

  Widget totalScoreChartContainer() {
    return Container(
      //   padding: EdgeInsets.fromLTRB(DimensionsConstants.d29.w, DimensionsConstants.d21.h, DimensionsConstants.d29.w, 0.0),
      height: DimensionsConstants.d241.h,
      width: DimensionsConstants.d254.w,
      decoration: BoxDecoration(
        color: ColorConstants.colorBluishWhite,
        borderRadius:
            BorderRadius.all(Radius.circular(DimensionsConstants.d10.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: DimensionsConstants.d10.w),
            child: Text("total_average_per_student_score".tr()).semiBoldText(
                ColorConstants.primaryColor,
                DimensionsConstants.d15.sp,
                TextAlign.left),
          ),
          Expanded(
              child: SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ? VerticalBarLabelChart.withSampleData(
                  provider.data!.scores!, false, false, true) : VerticalBarLabelChartStudent.withSampleData(provider.studentData!.scores!, false, false, true) ),
        ],
      ),
    );
  }
}
