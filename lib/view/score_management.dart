import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:ai_score/constants/color_constants.dart';
import 'package:ai_score/constants/decoration.dart';
import 'package:ai_score/constants/dimensions_constants.dart';
import 'package:ai_score/constants/image_constants.dart';
import 'package:ai_score/enum/view_state.dart';
import 'package:ai_score/extensions/all_extensions.dart';
import 'package:ai_score/helper/shared_pref.dart';
import 'package:ai_score/models/category_list_model.dart';
import 'package:ai_score/models/get_score_student_side_response.dart';
import 'package:ai_score/models/get_scores_response.dart' as score;
import 'package:ai_score/providers/score_management_provider.dart';
import 'package:ai_score/view/base_view.dart';
import 'package:ai_score/widgets/image_view.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:number_paginator/number_paginator.dart';

class ScoreManagement extends StatefulWidget {
  const ScoreManagement({Key? key}) : super(key: key);

  @override
  _ScoreManagementState createState() => _ScoreManagementState();
}

class _ScoreManagementState extends State<ScoreManagement> {
  List<TextEditingController> angleScoreController = [];
  List<TextEditingController> teacherScoreController = [];
  final teacherController = TextEditingController();

  void forControllerInitialize(ScoreManagementProvider provider) {
    for (int i = 0; i < provider.getScoresList.length; i++) {
      teacherScoreController.add(TextEditingController());
      teacherScoreController[i].text =
          provider.getScoresList[i].teacherScore.toString();
    }
    for (int i = 0; i < provider.getScoresList.length; i++) {
      angleScoreController.add(TextEditingController());
      angleScoreController[i].text =
          provider.getScoresList[i].angleScore.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BaseView<ScoreManagementProvider>(
      onModelReady: (provider) async {
        provider.getScoresList.clear();
        SharedPref.prefs!.getString(SharedPref.userType) == "Teacher"
            ? await provider.getAllScores(context,pageCount: 0)
            : await provider.getScoreDataStudentSide(context, "", "");
        provider.getCategoryData();
      },
      builder: (context, provider, _) {
        forControllerInitialize(provider);
        return Column(
          children: [
            Expanded(
              flex: 9,
              child: Container(
                margin: EdgeInsets.fromLTRB(DimensionsConstants.d10.w, 0.0,
                    DimensionsConstants.d15.w, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: DimensionsConstants.d30.h),
                    SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ?
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: DimensionsConstants.d50.w),
                      height: DimensionsConstants.d80.h,
                      width: DimensionsConstants.d1410.w,
                      color: ColorConstants.colorBluishWhite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("name".tr()).semiBoldText(
                              ColorConstants.primaryColor,
                              DimensionsConstants.d20.sp,
                              TextAlign.left),
                          Text("student_number".tr()).semiBoldText(
                              ColorConstants.primaryColor,
                              DimensionsConstants.d20.sp,
                              TextAlign.left),
                          Text("category".tr()).semiBoldText(
                              ColorConstants.primaryColor,
                              DimensionsConstants.d20.sp,
                              TextAlign.left),
                          Text("examination_date".tr()).semiBoldText(
                              ColorConstants.primaryColor,
                              DimensionsConstants.d20.sp,
                              TextAlign.left),
                          Text("bad_Pose".tr()).semiBoldText(
                              ColorConstants.primaryColor,
                              DimensionsConstants.d20.sp,
                              TextAlign.left),
                          Text("ai_score".tr()).semiBoldText(
                              ColorConstants.primaryColor,
                              DimensionsConstants.d20.sp,
                              TextAlign.left),
                          Text("teacher_score".tr()).semiBoldText(
                              ColorConstants.primaryColor,
                              DimensionsConstants.d20.sp,
                              TextAlign.left),
                          Text("total_score".tr()).semiBoldText(
                              ColorConstants.primaryColor,
                              DimensionsConstants.d20.sp,
                              TextAlign.left),
                        ],
                      ),
                    ) : Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: DimensionsConstants.d50.w),
                      height: DimensionsConstants.d80.h,
                      width: DimensionsConstants.d1410.w,
                      color: ColorConstants.colorBluishWhite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("round".tr()).semiBoldText(
                              ColorConstants.primaryColor,
                              DimensionsConstants.d20.sp,
                              TextAlign.left),
                          /*Text("student_number".tr()).semiBoldText(
                              ColorConstants.primaryColor,
                              DimensionsConstants.d20.sp,
                              TextAlign.left),*/
                          Text("category".tr()).semiBoldText(
                              ColorConstants.primaryColor,
                              DimensionsConstants.d20.sp,
                              TextAlign.left),
                          Text("time".tr()).semiBoldText(
                              ColorConstants.primaryColor,
                              DimensionsConstants.d20.sp,
                              TextAlign.left),
                          Text("bad_Pose".tr()).semiBoldText(
                              ColorConstants.primaryColor,
                              DimensionsConstants.d20.sp,
                              TextAlign.left),
                          /*Text("ai_score".tr()).semiBoldText(
                              ColorConstants.primaryColor,
                              DimensionsConstants.d20.sp,
                              TextAlign.left),*/
                          Text("ai_Score".tr()).semiBoldText(
                              ColorConstants.primaryColor,
                              DimensionsConstants.d20.sp,
                              TextAlign.left),
                          /*Text("total_score".tr()).semiBoldText(
                              ColorConstants.primaryColor,
                              DimensionsConstants.d20.sp,
                              TextAlign.left),*/
                        ],
                      ),
                    ),
                    SizedBox(height: DimensionsConstants.d40.h),
                    SharedPref.prefs!.getString(SharedPref.userType) ==
                            "Teacher"
                        ? (provider.state == ViewState.Busy ||
                                provider.updateS == true)
                            ? Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: DimensionsConstants.d100.h),
                                    const CircularProgressIndicator(),
                                    Text("getting_scores_data".tr())
                                        .semiBoldText(
                                            ColorConstants.primaryColor,
                                            DimensionsConstants.d18.sp,
                                            TextAlign.left),
                                    SizedBox(
                                        height: DimensionsConstants.d100.h),
                                  ],
                                ),
                              )
                            : provider.getScoreListPaging.isEmpty
                                ? Container()
                                : Expanded(
                                    child: SingleChildScrollView(
                                        child: getScoresDataList(provider)))
                        : (provider.state == ViewState.Busy ||
                                provider.updateS == true)
                            ? Center(
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: DimensionsConstants.d100.h),
                                    const CircularProgressIndicator(),
                                    Text("getting_scores_data".tr())
                                        .semiBoldText(
                                            ColorConstants.primaryColor,
                                            DimensionsConstants.d18.sp,
                                            TextAlign.left),
                                    SizedBox(
                                        height: DimensionsConstants.d100.h),
                                  ],
                                ),
                              )
                            : provider.getScoreListPagingStudent[provider.currentPage].isEmpty
                                ? Container()
                                : Expanded(
                                    child: SingleChildScrollView(
                                        child:
                                            getScoresDataListStudent(provider)))
                  ],
                ),
              ),
            ),
            Divider(color: ColorConstants.colorBlack),
            SizedBox(height: DimensionsConstants.d10.h),
            (provider.state == ViewState.Busy ||
                provider.updateS == true)
                ? Container():SizedBox(
              height: DimensionsConstants.d50.h,
              width: DimensionsConstants.d210.w,
              child: NumberPaginator(
                numberPages: provider.numberOfPages,
                initialPage: provider.currentPage,
                onPageChange: (int index) {
                  if(SharedPref.prefs!.getString(SharedPref.userType) == "Teacher"){
                    provider.getAllScores(context,category: provider.categoryDropDownValueId,
                        pageCount: index,
                        date: provider.selectedDate == null
                            ? " "
                            : provider.selectedDate.toString().substring(0, 10));
                  }else{
                    provider.updateCurrentPage(index);
                  }
                },
              ),
            ),
            SizedBox(height: DimensionsConstants.d10.h),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:  SharedPref.prefs!.getString(SharedPref.userType)== "Teacher" ? EdgeInsets.only() :  EdgeInsets.only(left: DimensionsConstants.d50.w),
                    child: categoryBtn(provider),
                  ),
                  SizedBox(width: DimensionsConstants.d44.w),
                  SharedPref.prefs!.getString(SharedPref.userType)== "Teacher" ? dateBtn(context, provider):Container(),
                ],
              ),
            ),

          ],
        );
      },
    ));
  }

  Widget getScoresDataList(ScoreManagementProvider provider) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: provider.getScoreListPaging.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            (provider.getScoreListPaging[index].student == null || provider.getScoreListPaging[index].studentId == null)
                ? Container()
                : studentScoreData(
                    provider.getScoreListPaging[index],
                    index,
                    provider),
            (provider.getScoreListPaging[index].student == null || provider.getScoreListPaging[index].studentId == null)
                ? const SizedBox(height: 0.0)
                : SizedBox(height: DimensionsConstants.d20.h),
          ],
        );
      },
    );
  }

  Widget getScoresDataListStudent(ScoreManagementProvider provider) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: provider.getScoreListPagingStudent[provider.currentPage].length,
      itemBuilder: (context, index) {
        print(provider.getScoreListPagingStudent[provider.currentPage]);
        // angleScoreController.text = provider.getScoresList[index].angleScore.toString();
        return Column(
          children: [
            (provider.getScoreListPagingStudent[provider.currentPage][index].round == null)
                ? Container()
                : studentScoreDataStudent(
                    provider.getScoreListPagingStudent[provider.currentPage]
                        [index],
                    index,
                    provider),
            (provider.getScoreListPagingStudent[provider.currentPage][index].round == null)
                ? const SizedBox(height: 0.0)
                : SizedBox(height: DimensionsConstants.d20.h),
          ],
        );
      },
    );
  }

  Widget studentScoreDataStudent(
      GetScoreData getScores, int index, ScoreManagementProvider provider) {
    Uint8List bytes = const Base64Codec().decode(getScores.wrongImage);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          DimensionsConstants.d50.w, 0.0, DimensionsConstants.d50.w, 0.0),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
           //  color: Colors.limeAccent,
            width: DimensionsConstants.d128.w,
            child: Text(getScores.round.toString() ?? "")
                .regularText(ColorConstants.colorBlack,
                    DimensionsConstants.d18.sp, TextAlign.left),
          ),
          SizedBox(width: DimensionsConstants.d157.w,),
          Container(
             // color: Colors.limeAccent,
            width: DimensionsConstants.d140.w,
            child: Text(getCategoryName(getScores.category.toString()) ?? " ").regularText(
                ColorConstants.colorBlack,
                DimensionsConstants.d18.sp,
                TextAlign.left),
          ),
          SizedBox(width: DimensionsConstants.d185.w,),

          Container(

            width: DimensionsConstants.d50.w,
           // color: ColorConstants.colorBlack,
            child: Text(getScores.time.toString() ?? " ").regularText(
                ColorConstants.colorBlack,
                DimensionsConstants.d18.sp,
                TextAlign.center),
          ),
          SizedBox(width: DimensionsConstants.d157.w,),

          GestureDetector(
            onTap: (){
              provider.showImageDialog(context, bytes);
            },
            child: Padding(
              padding:  EdgeInsets.only(left: DimensionsConstants.d88.w),
              child: Image.memory(
                bytes,
                height: 49,
                width: 49.w,
                fit: BoxFit.fill,


              ),
            ),
          ),

          SizedBox(
            width: DimensionsConstants.d238.w,
          ),
          // angleAndTeacherScore(getScores.angleScore.toString()),


          Container(
            //  color: Colors.limeAccent,
            width: DimensionsConstants.d119.w,
            child: Text(getScores.teacherScore.toStringAsFixed(2) ?? "").regularText(
                ColorConstants.colorBlack,
                DimensionsConstants.d18.sp,
                TextAlign.center),
          ),


          //  angleAndTeacherScore(getScores.teacherScore.toString()),

        ],
      ),
    );
  }

  Widget studentScoreData(
      score.Data getScores, int index, ScoreManagementProvider provider) {
    Uint8List bytes = const Base64Codec().decode(getScores.wrongImage!);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          DimensionsConstants.d50.w, 0.0, DimensionsConstants.d50.w, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // color: Colors.limeAccent,
            width: DimensionsConstants.d140.w,
            child: Text(getScores.student?.studentName.toString() ?? "")
                .regularText(ColorConstants.colorBlack,
                    DimensionsConstants.d18.sp, TextAlign.left),
          ),
          Container(
            //   color: Colors.limeAccent,
            width: DimensionsConstants.d140.w,
            child: Text(getScores.student?.studentNo.toString() ?? "")
                .regularText(ColorConstants.colorBlack,
                    DimensionsConstants.d18.sp, TextAlign.left),
          ),
          Container(
            //  color: Colors.limeAccent,
            width: DimensionsConstants.d128.w,
            child: Text(getCategoryName(getScores.category.toString()))
                .regularText(ColorConstants.colorBlack,
                    DimensionsConstants.d18.sp, TextAlign.left),
          ),
          Container(
            //  color: Colors.limeAccent,
            width: DimensionsConstants.d140.w,
            child: Text(getScores.examDate.toString()).regularText(
                ColorConstants.colorBlack,
                DimensionsConstants.d18.sp,
                TextAlign.left),
          ),
          SizedBox(
            width: DimensionsConstants.d35.w,
          ),
          GestureDetector(
            onTap: (){
              provider.showImageDialog(context, bytes);
            },
            child: Image.memory(
              bytes,
              height: 49,
              width: 49.w,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            width: DimensionsConstants.d10.w,
          ),
          // angleAndTeacherScore(getScores.angleScore.toString()),
          angleScoreTextField(
            index,
            provider,
            getScores.id.toString(),
            getScores.angleScore.toString(),
            getScores.teacherScore.toString(),
            getScores,
          ),

          teacherScoreTextField(
            index,
            provider,
            getScores.id.toString(),
            getScores.angleScore.toString(),
            getScores.teacherScore.toString(),
            getScores,
          ),
          //  angleAndTeacherScore(getScores.teacherScore.toString()),
          Container(
            //  color: Colors.limeAccent,
            width: DimensionsConstants.d140.w,
            child: Text(getScores.totalScore!.toStringAsFixed(2)).regularText(
                ColorConstants.colorBlack,
                DimensionsConstants.d18.sp,
                TextAlign.center),
          ),
        ],
      ),
    );
  }

  getCategoryName(String category) {
    switch (category) {
      case "1.1":
        return "Smile-1.1".tr();
      case "2.1":
        return "Bow-15".tr();
      case "2.2":
        return "Bow-30".tr();
      case "2.3":
        return "Bow-45".tr();
      case "3.1":
        return "Welcome-3.1".tr();
      case "4.1":
        return "To Put-4.1".tr();
      case "4.2":
        return "Slip-4.2".tr();
      case "4.3":
        return "Fasten-4.3".tr();
      case "4.4":
        return "Fasten-4.4".tr();
      case "4.5":
        return "Pull-4.5".tr();
      case "4.6":
        return "Inflation-4.6".tr();
      case "4.7":
        return "Pull-4.7".tr();
      case "4.8":
        return "Blow-4.8".tr();
      case "5.1":
        return "Located-5.1".tr();
      case "5.2":
        return "Drop-5.2".tr();
      case "5.3":
        return "Pull-5.3".tr();
      case "5.4":
        return "Over-5.4".tr();
      case "5.5":
        return "Slip-5.5".tr();
      case "6.1":
        return "Seatbelt-6.1".tr();
      case "6.2":
        return "Insert-6.2".tr();
      case "6.3":
        return "Tightly-6.3".tr();
      case "6.4":
        return "To unfasten-6.4".tr();
      case "6.5":
        return "Lift-6.5".tr();
      case "7.1":
        return "Front-7.1".tr();
      case "7.2":
        return "Middle-7.2".tr();
      case "7.3":
        return "Rear-7.3".tr();
      case "7.4":
        return "Light-7.4".tr();
      case "7.5":
        return "For-7.5".tr();
      case "8.1":
        return "Thank you-8.1".tr();
      case "9.1":
        return "total test -30".tr();

      default:
        {
          return category;
        }
    }
  }
  // Widget angleAndTeacherScore(score){
  //   return  Container(
  //     width: DimensionsConstants.d140.w,
  //     padding: EdgeInsets.fromLTRB(DimensionsConstants.d15.w, 0.0,DimensionsConstants.d15.w, 0.0),
  //     decoration: BoxDecoration(
  //      // color: Colors.limeAccent,
  //       color: ColorConstants.colorWhite,
  //       border: Border.all(
  //           width: 1,
  //           color: ColorConstants.colorA1A1A1
  //       ),
  //       borderRadius: BorderRadius.all(Radius.circular(DimensionsConstants.d10.r)),
  //     ),
  //     child: Text(score).regularText(ColorConstants.colorBlack, DimensionsConstants.d16.sp, TextAlign.center),
  //   );
  // }

  Widget angleScoreTextField(
      int index,
      ScoreManagementProvider provider,
      String scoreId,
      String angleScore,
      String teacherScore,
      score.Data getScores) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.limeAccent,
        color: ColorConstants.colorWhite,
        border: Border.all(width: 1, color: ColorConstants.colorA1A1A1),
        borderRadius:
            BorderRadius.all(Radius.circular(DimensionsConstants.d10.r)),
      ),
      width: DimensionsConstants.d140.w,
      child: TextFormField(
        onChanged: (value) {
          Future.delayed(Duration(seconds: 2), () {
            if (value == angleScoreController[index].text) {
              provider.updateScores(context, scoreId, value, teacherScore);
              provider.getTotalScore(
                  getScores,
                  double.tryParse(value)!.toDouble(),
                  double.tryParse(teacherScoreController[index].text)!
                      .toDouble());
            }
          });
        },
        textAlign: TextAlign.center,
        controller: angleScoreController[index],
        style: ViewDecoration.regular(
          DimensionsConstants.d16.sp,
          ColorConstants.colorBlack,
        ),
        decoration: ViewDecoration.inputDecorationWithCurve(
          "",
          size: DimensionsConstants.d16.sp,
          fillColor: ColorConstants.colorWhite,
          contentPadding: EdgeInsets.fromLTRB(
              DimensionsConstants.d15.w,
              DimensionsConstants.d5.h,
              DimensionsConstants.d15.w,
              DimensionsConstants.d5.h),
        ),
        // onFieldSubmitted: (data) {
        //   provider.updateScores(context, scoreId, angleScoreController[index].text, teacherScore);
        // },
        keyboardType: TextInputType.number,
        // inputFormatters: <TextInputFormatter>[
        //   FilteringTextInputFormatter.digitsOnly
        // ], // Only numbers can be entered
      ),
    );
  }

  Widget teacherScoreTextField(
      int index,
      ScoreManagementProvider provider,
      String scoreId,
      String angleScore,
      String teacherScore,
      score.Data getScores) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.limeAccent,
        color: ColorConstants.colorWhite,
        border: Border.all(width: 1, color: ColorConstants.colorA1A1A1),
        borderRadius:
            BorderRadius.all(Radius.circular(DimensionsConstants.d10.r)),
      ),
      width: DimensionsConstants.d140.w,
      child: TextFormField(
        onChanged: (value) {
          Future.delayed(const Duration(seconds: 2), () {
            if (value == teacherScoreController[index].text) {
              provider.updateScores(context, scoreId, angleScore, value);
              provider.getTotalScore(
                  getScores,
                  double.tryParse(angleScoreController[index].text)!.toDouble(),
                  double.tryParse(value)!.toDouble());
            }
          });
        },
        textAlign: TextAlign.center,
        controller: teacherScoreController[index],

        style: ViewDecoration.regular(
            DimensionsConstants.d16.sp, ColorConstants.colorBlack),
        decoration: ViewDecoration.inputDecorationWithCurve(
          "",
          size: DimensionsConstants.d16.sp,
          fillColor: ColorConstants.colorWhite,
          contentPadding: EdgeInsets.fromLTRB(
              DimensionsConstants.d15.w,
              DimensionsConstants.d5.h,
              DimensionsConstants.d15.w,
              DimensionsConstants.d5.h),
        ),
        // onFieldSubmitted: (data) {
        //   provider.updateScores(context, scoreId, angleScore, teacherScoreController[index].text);
        // },
        keyboardType: TextInputType.number,
        // inputFormatters: <TextInputFormatter>[
        //   FilteringTextInputFormatter.digitsOnly
        // ], // Only numbers can be entered
      ),
    );
  }

  Widget categoryBtn(ScoreManagementProvider provider) {
    return Container(
      alignment: Alignment.center,
      height: DimensionsConstants.d36.h,
      padding: EdgeInsets.fromLTRB(
          DimensionsConstants.d15.w, 0.0, DimensionsConstants.d15.w, 0.0),
      decoration: BoxDecoration(
        color: ColorConstants.colorWhite,
        border: Border.all(width: 1, color: ColorConstants.colorA1A1A1),
        borderRadius:
            BorderRadius.all(Radius.circular(DimensionsConstants.d10.r)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            hint: Text("all".tr()).regularText(ColorConstants.colorBlack,
                DimensionsConstants.d12.sp, TextAlign.left),
            focusColor: ColorConstants.colorWhite,
            menuMaxHeight: DimensionsConstants.d300.h,
            value: provider.categoryDropDownValue,
            //   hint: Text("category".tr()).semiBoldText(ColorConstants.primaryColor, DimensionsConstants.d20.sp, TextAlign.left),
            icon: Row(
              children: [
                // Text("category".tr()).regularText(ColorConstants.colorBlack, DimensionsConstants.d12.sp, TextAlign.left),
                SizedBox(width: DimensionsConstants.d30.w),
                const ImageView(path: ImageConstants.smallArrowDown)
              ],
            ),
            items: provider.categoryList.toSet().map((CategoryList items) {
              return DropdownMenuItem(
                onTap: () {
                  provider.identification = false;
                  provider.getScoresList.clear();
                  provider.categoryDropDownValueId =
                      items.categoryNumber.toString();
                  provider.selectedCategoryParam = true;
                  SharedPref.prefs!.getString(SharedPref.userType) == "Teacher"?
                  provider.getAllScores(
                      context,
                      category: items.categoryNumber.toString(),
                      date: provider.selectedDate == null
                          ? " "
                          : provider.selectedDate.toString().substring(0, 10)): provider.getScoreDataStudentSide(context, items.categoryNumber.toString(), "");
                },
                value: items.categoryName,
                child: Text(items.categoryName.toString()).regularText(
                    ColorConstants.colorBlack,
                    DimensionsConstants.d12.sp,
                    TextAlign.left),
              );
            }).toList(),
            onChanged: (String? newValue) {
              provider.categoryDropDownValue = newValue!;
              provider.updateData(true);
            }),
      ),
    );
  }

  Widget dateBtn(BuildContext context, ScoreManagementProvider provider) {
    return GestureDetector(
      onTap: () {
        provider.selectedDateParam = true;

        provider.pickDateDialog(context);
      },
      onTapCancel: () {
        print("ontap cancle");
        provider.pickDateDialog(context);
        provider.selectedDate = null;
        provider.selectedDateParam = false;
      },
      child: Container(
          height: DimensionsConstants.d36.h,
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(
              DimensionsConstants.d15.w, 0.0, DimensionsConstants.d15.w, 0.0),
          decoration: BoxDecoration(
            color: ColorConstants.colorWhite,
            border: Border.all(width: 1, color: ColorConstants.colorA1A1A1),
            borderRadius:
                BorderRadius.all(Radius.circular(DimensionsConstants.d10.r)),
          ),
          child: Row(
            children: [
              Text("date".tr()).regularText(ColorConstants.colorBlack,
                  DimensionsConstants.d12.sp, TextAlign.left),
              SizedBox(width: DimensionsConstants.d88.w),
              const ImageView(path: ImageConstants.datePickerIcon)
            ],
          )),
    );
  }
}
