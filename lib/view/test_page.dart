import 'dart:async';
import 'dart:io';

import 'package:ai_score/constants/color_constants.dart';
import 'package:ai_score/constants/dimensions_constants.dart';
import 'package:ai_score/constants/image_constants.dart';
import 'package:ai_score/enum/view_state.dart';
import 'package:ai_score/extensions/all_extensions.dart';
import 'package:ai_score/helper/dialog_helper.dart';
import 'package:ai_score/helper/shared_pref.dart';
import 'package:ai_score/json/category_json.dart';
import 'package:ai_score/main.dart';
import 'package:ai_score/models/add_edit_student_response.dart';
import 'package:ai_score/models/add_score_request.dart';
import 'package:ai_score/models/category_list_model.dart';
import 'package:ai_score/providers/test_page_provider.dart';
import 'package:ai_score/view/base_view.dart';
import 'package:ai_score/widgets/camera.dart';
import 'package:ai_score/widgets/image_view.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import 'package:flutter_switch/flutter_switch.dart';

List<CameraDescription>? cameras;

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // var dropDownItems =  ["${"student".tr()} 1","${"student".tr()} 2","${"student".tr()} 3","${"student".tr()} 4","${"student".tr()} 5"];
  //
  // String categoryValue = "category".tr();
  // var categoryDropDownItems = ["category".tr(), "smile".tr(), "bow_15".tr(), "bow_30".tr(), "bow_45".tr(), "welcome".tr(), "to_put".tr(), "slip".tr(), "fasten".tr(),
  //   "inflation".tr(),  "pull".tr(), "blow".tr(), "located".tr(), "drop".tr(), "over".tr(), "seat_belt".tr(),
  //    "insert".tr(), "tightly".tr(), "to_unfasten".tr(), "lift".tr(), "front".tr(), "middle".tr(), "rear".tr(), "light".tr(), "for".tr(), "thank_you".tr()];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TestPageProvider? provider;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BaseView<TestPageProvider>(
      onModelReady: (provider) async {
        provider.startPlayer();
        this.provider = provider;
        //   provider.isSwitched = SharedPref.prefs?.getBool(SharedPref.selectedCameraIndex) ?? false;
        SharedPref.prefs!.getString(SharedPref.userType) == "Teacher"
            ? provider.getStudentsData(context)
            : null;
        provider.getCategoryData();
        cameras = await availableCameras();

        controller = CameraController(cameras![0], ResolutionPreset.low);
        controller!.initialize().then((_) {
          if (!mounted) {
            return;
          }
          provider.updateData(true);
        });
      },
      builder: (context, provider, _) {
        return SingleChildScrollView(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: DimensionsConstants.d20.w),
                    height: DimensionsConstants.d750.h,
                    width: DimensionsConstants.d1174.w,
                    child: Container(
                      child: _cameraPreviewWidget(),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: controller != null &&
                                  controller!.value.isRecordingVideo
                              ? Colors.redAccent
                              : Colors.grey,
                          width: 3.0,
                        ),
                      ),
                    ),
                  ),
                  SharedPref.prefs!.getString(SharedPref.userType) == "Teacher"
                      ? Container(
                          height: DimensionsConstants.d168.h,
                          width: DimensionsConstants.d1174.w,
                          padding: EdgeInsets.fromLTRB(
                              0.0, DimensionsConstants.d25.h, 0.0, 0.0),
                          color: ColorConstants.colorBluishWhite,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: DimensionsConstants.d230.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: DimensionsConstants.d157.w,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                            isExpanded: true,
                                            menuMaxHeight:
                                                DimensionsConstants.d450.h,
                                            focusColor:
                                                ColorConstants.colorBluishWhite,
                                            value: provider.studentDropDown1,
                                            hint: Text("select_student1".tr())
                                                .semiBoldText(
                                                    ColorConstants.colorBlack,
                                                    DimensionsConstants.d15.sp,
                                                    TextAlign.left),
                                            icon: Row(
                                              children: [
                                                SizedBox(
                                                    width: DimensionsConstants
                                                        .d20.w),
                                                const ImageView(
                                                    path: ImageConstants
                                                        .arrowDown),
                                              ],
                                            ),
                                            items: provider.studentsDataList1
                                                .map((Data items) {
                                              return DropdownMenuItem(
                                                onTap: () {
                                                  provider.studentId1 = (items.id == "select_student1".tr() ? null : items.id);
                                                },
                                                value: items.id.toString(),
                                                child: Text(items.studentName ==
                                                            null
                                                        ? items.id.toString()
                                                        : items.studentName
                                                            .toString())
                                                    .semiBoldText(
                                                        ColorConstants
                                                            .colorBlack,
                                                        DimensionsConstants
                                                            .d15.sp,
                                                        TextAlign.left,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              provider.studentDropDown1 = newValue!;
                                              provider.updateData(true);
                                            }),
                                      ),
                                    ),
                                    //   SizedBox(width: DimensionsConstants.d75.w),
                                    SizedBox(
                                      width: DimensionsConstants.d157.w,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                            isExpanded: true,
                                            menuMaxHeight:
                                                DimensionsConstants.d450.h,
                                            focusColor:
                                                ColorConstants.colorBluishWhite,
                                            value: provider.studentDropDown2,
                                            hint: Text("select_student2".tr())
                                                .semiBoldText(
                                                    ColorConstants.colorBlack,
                                                    DimensionsConstants.d15.sp,
                                                    TextAlign.left),
                                            icon: Row(
                                              children: [
                                                SizedBox(
                                                    width: DimensionsConstants
                                                        .d20.w),
                                                const ImageView(
                                                    path: ImageConstants
                                                        .arrowDown),
                                              ],
                                            ),
                                            items: provider.studentsDataList2
                                                .map((Data items) {
                                              return DropdownMenuItem(
                                                onTap: () {
                                                  provider.studentId2 = (items
                                                              .id ==
                                                          "select_student2".tr()
                                                      ? null
                                                      : items.id);
                                                },
                                                value: items.id.toString(),
                                                child: Text(items.studentName ==
                                                            null
                                                        ? items.id.toString()
                                                        : items.studentName
                                                            .toString())
                                                    .semiBoldText(
                                                        ColorConstants
                                                            .colorBlack,
                                                        DimensionsConstants
                                                            .d15.sp,
                                                        TextAlign.left,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              provider.studentDropDown2 =
                                                  newValue!;
                                              provider.updateData(true);
                                            }),
                                      ),
                                    ),
                                    //  SizedBox(width: DimensionsConstants.d75.w),
                                    SizedBox(
                                      width: DimensionsConstants.d157.w,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                            isExpanded: true,
                                            menuMaxHeight:
                                                DimensionsConstants.d450.h,
                                            focusColor:
                                                ColorConstants.colorBluishWhite,
                                            value: provider.studentDropDown3,
                                            hint: Text("select_student3".tr())
                                                .semiBoldText(
                                                    ColorConstants.colorBlack,
                                                    DimensionsConstants.d15.sp,
                                                    TextAlign.left),
                                            icon: Row(
                                              children: [
                                                SizedBox(
                                                    width: DimensionsConstants
                                                        .d20.w),
                                                const ImageView(
                                                    path: ImageConstants
                                                        .arrowDown),
                                              ],
                                            ),
                                            items: provider.studentsDataList3
                                                .map((Data items) {
                                              return DropdownMenuItem(
                                                onTap: () {
                                                  provider.studentId3 = (items
                                                              .id ==
                                                          "select_student3".tr()
                                                      ? null
                                                      : items.id);
                                                },
                                                value: items.id.toString(),
                                                child: Text(items.studentName ==
                                                            null
                                                        ? items.id.toString()
                                                        : items.studentName
                                                            .toString())
                                                    .semiBoldText(
                                                        ColorConstants
                                                            .colorBlack,
                                                        DimensionsConstants
                                                            .d15.sp,
                                                        TextAlign.left,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              provider.studentDropDown3 =
                                                  newValue!;
                                              provider.updateData(true);
                                            }),
                                      ),
                                    ),
                                    //   SizedBox(width: DimensionsConstants.d75.w),
                                    SizedBox(
                                      width: DimensionsConstants.d157.w,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                            isExpanded: true,
                                            menuMaxHeight:
                                                DimensionsConstants.d450.h,
                                            focusColor:
                                                ColorConstants.colorBluishWhite,
                                            value: provider.studentDropDown4,
                                            hint: Text("select_student4".tr())
                                                .semiBoldText(
                                                    ColorConstants.colorBlack,
                                                    DimensionsConstants.d15.sp,
                                                    TextAlign.left),
                                            icon: Row(
                                              children: [
                                                SizedBox(
                                                    width: DimensionsConstants
                                                        .d20.w),
                                                const ImageView(
                                                    path: ImageConstants
                                                        .arrowDown),
                                              ],
                                            ),
                                            items: provider.studentsDataList4
                                                .map((Data items) {
                                              return DropdownMenuItem(
                                                onTap: () {
                                                  provider.studentId4 = (items
                                                              .id ==
                                                          "select_student4".tr()
                                                      ? null
                                                      : items.id);
                                                },
                                                value: items.id.toString(),
                                                child: Text(items.studentName ==
                                                            null
                                                        ? items.id.toString()
                                                        : items.studentName
                                                            .toString())
                                                    .semiBoldText(
                                                        ColorConstants
                                                            .colorBlack,
                                                        DimensionsConstants
                                                            .d15.sp,
                                                        TextAlign.left,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              provider.studentDropDown4 =
                                                  newValue!;
                                              provider.updateData(true);
                                            }),
                                      ),
                                    ),
                                    //   SizedBox(width: DimensionsConstants.d75.w),
                                    SizedBox(
                                      width: DimensionsConstants.d157.w,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                            isExpanded: true,
                                            menuMaxHeight:
                                                DimensionsConstants.d450.h,
                                            focusColor:
                                                ColorConstants.colorBluishWhite,
                                            value: provider.studentDropDown5,
                                            hint: Text("select_student5".tr())
                                                .semiBoldText(
                                                    ColorConstants.colorBlack,
                                                    DimensionsConstants.d15.sp,
                                                    TextAlign.left),
                                            icon: Row(
                                              children: [
                                                SizedBox(
                                                    width: DimensionsConstants
                                                        .d20.w),
                                                const ImageView(
                                                    path: ImageConstants
                                                        .arrowDown),
                                              ],
                                            ),
                                            items: provider.studentsDataList5
                                                .map((Data items) {
                                              return DropdownMenuItem(
                                                onTap: () {
                                                  provider.studentId5 = (items
                                                              .id ==
                                                          "select_student5".tr()
                                                      ? null
                                                      : items.id);
                                                },
                                                value: items.id.toString(),
                                                child: Text(items.studentName ==
                                                            null
                                                        ? items.id.toString()
                                                        : items.studentName
                                                            .toString())
                                                    .semiBoldText(
                                                        ColorConstants
                                                            .colorBlack,
                                                        DimensionsConstants
                                                            .d15.sp,
                                                        TextAlign.left,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              provider.studentDropDown5 =
                                                  newValue!;
                                              provider.updateData(true);
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    DimensionsConstants.d66.w,
                                    DimensionsConstants.d10.h,
                                    0.0,
                                    0.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("ai_score".tr()).semiBoldText(
                                        ColorConstants.colorBlack,
                                        DimensionsConstants.d18.sp,
                                        TextAlign.left),
                                    SizedBox(width: DimensionsConstants.d5.w),
                                    provider.aiScoreList.isEmpty
                                        ? scoreContainer("")
                                        : scoreContainer(
                                            provider.aiScoreList[0].toString()),
                                    provider.aiScoreList.length != 2
                                        ? scoreContainer("")
                                        : scoreContainer(
                                            provider.aiScoreList[1].toString()),
                                    provider.aiScoreList.length != 3
                                        ? scoreContainer("")
                                        : scoreContainer(
                                            provider.aiScoreList[2].toString()),
                                    provider.aiScoreList.length != 4
                                        ? scoreContainer("")
                                        : scoreContainer(
                                            provider.aiScoreList[3].toString()),
                                    provider.aiScoreList.length != 5
                                        ? scoreContainer("")
                                        : scoreContainer(
                                            provider.aiScoreList[4].toString())
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: DimensionsConstants.d119.h,
                          width: DimensionsConstants.d526.w,
                          child: provider.state == ViewState.Busy
                              ? Center(
                                  heightFactor: DimensionsConstants.d20.h,
                                  widthFactor: DimensionsConstants.d20.w,
                                  child: CircularProgressIndicator())
                              : SharedPref.prefs!
                                          .getString(SharedPref.userType) ==
                                      "Teacher"
                                  ? Container()
                                  : roundForStudent(provider),
                        ),
                ],
              ),
              Container(
                height: DimensionsConstants.d918.h,
                width: DimensionsConstants.d266.w,
                color: ColorConstants.colorBluishWhite,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(DimensionsConstants.d28.w,
                          0.0, DimensionsConstants.d28.w, 0.0),
                      child: Column(
                        children: [
                          cameraSwitch(),
                          SizedBox(height: DimensionsConstants.d10.h),
                          categoryDropdown(),
                        ],
                      ),
                    ),
                    SizedBox(height: DimensionsConstants.d500.h),
                    Text("time".tr()).regularText(ColorConstants.colorBlack,
                        DimensionsConstants.d18.sp, TextAlign.left),
                    SizedBox(height: DimensionsConstants.d10.h),
                    Text("0${provider.minuteCount.toString()} : ${(provider.secondsCount <= 9) ? "0${provider.secondsCount.toString()}" : provider.secondsCount.toString()}")
                        .boldText(ColorConstants.colorBlack,
                            DimensionsConstants.d22.sp, TextAlign.left),
                    provider.updateVideo
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            children: [
                              GestureDetector(
                                  onTap: controller != null &&
                                          controller!.value.isInitialized &&
                                          !controller!.value.isRecordingVideo &&
                                          SharedPref.prefs!.getString(SharedPref.userType) == "Teacher"
                                      ? onVideoRecordButtonPressed
                                      : onVideoRecordButtonPressedStudent,
                                  child: startFinishBtn("start".tr())),
                              SizedBox(height: DimensionsConstants.d10.h),
                              GestureDetector(
                                  onTap:
                                      //                   (){
                                      //                 provider.addScores(context, provider.categoryDropDownValueId!, "45", [Students(studentId: provider.studentId1), Students(studentId: provider.studentId2), Students(studentId: provider.studentId3),
                                      //                   Students(studentId: provider.studentId4), Students(studentId: provider.studentId5)]);
                                      // },
                                      controller != null &&
                                              controller!.value.isInitialized &&
                                              controller!.value.isRecordingVideo
                                          ? onStopButtonPressed
                                          : null,
                                  child: startFinishBtn("finish".tr())),
                              SizedBox(height: DimensionsConstants.d10.h),
                            ],
                          ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    ));
  }

  Widget studentText(int no) {
    return Row(
      children: [
        Text("${"student".tr()} $no").semiBoldText(ColorConstants.colorBlack,
            DimensionsConstants.d18.sp, TextAlign.left),
        SizedBox(width: DimensionsConstants.d24.w),
        const ImageView(path: ImageConstants.arrowDown),
        no == 5
            ? const SizedBox(width: 0.0)
            : SizedBox(width: DimensionsConstants.d75.w)
      ],
    );
  }

  Widget scoreContainer(String score) {
    return Row(
      children: [
        Container(
          width: DimensionsConstants.d160.w,
          padding: EdgeInsets.fromLTRB(
              DimensionsConstants.d5.w, 0.0, DimensionsConstants.d5.w, 0.0),
          decoration: BoxDecoration(
            color: ColorConstants.colorBluishWhite,
            border: Border.all(width: 1, color: ColorConstants.colorA1A1A1),
            borderRadius:
                BorderRadius.all(Radius.circular(DimensionsConstants.d10.r)),
          ),
          child: Text(score).regularText(ColorConstants.colorBlack,
              DimensionsConstants.d16.sp, TextAlign.left,
              maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        //  SizedBox(width: DimensionsConstants.d35.w),
      ],
    );
  }

  // Widget featuresContainer(){
  //   return Container(
  //     width: DimensionsConstants.d210.w,
  //     height: DimensionsConstants.d475.h,
  //     color: ColorConstants.colorWhite,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(height: DimensionsConstants.d13.h),
  //         featureText("smile".tr()),
  //         Divider(color: ColorConstants.colorA1A1A1),
  //         featureText("bow".tr()),
  //         Divider(color: ColorConstants.colorA1A1A1),
  //         featureText("greet".tr()),
  //         Divider(color: ColorConstants.colorA1A1A1),
  //         featureText("life_vest".tr()),
  //         Divider(color: ColorConstants.colorA1A1A1),
  //         featureText("oxygen_mask".tr()),
  //         Divider(color: ColorConstants.colorA1A1A1),
  //         featureText("seat_belt".tr()),
  //         Divider(color: ColorConstants.colorA1A1A1),
  //         featureText("em_exit".tr()),
  //         Divider(color: ColorConstants.colorA1A1A1),
  //         featureText("safety_note".tr()),
  //         SizedBox(height: DimensionsConstants.d20.h),
  //       ],
  //     ),
  //   );
  // }

  Widget categoryDropdown() {
    return DropdownButtonHideUnderline(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensionsConstants.d10.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              DimensionsConstants.d10.w,
              DimensionsConstants.d2.h,
              DimensionsConstants.d10.w,
              DimensionsConstants.d2.h),
          child: SizedBox(
            height: DimensionsConstants.d50.h,
            width: DimensionsConstants.d201.w,
            child: DropdownButton(
                focusColor: ColorConstants.colorWhite,
                menuMaxHeight: DimensionsConstants.d526.h,
                value: provider?.categoryDropDownValue,
                hint: Text("category".tr()).semiBoldText(
                    ColorConstants.primaryColor,
                    DimensionsConstants.d20.sp,
                    TextAlign.left),
                icon: Row(
                  children: const [
                    //SizedBox(width: DimensionsConstants.d24.w),
                    ImageView(path: ImageConstants.arrowDown),
                  ],
                ),
                items: provider?.categoryList.toSet().map((CategoryList items) {
                  return DropdownMenuItem(
                    onTap: () {
                      provider?.categoryDropDownValueId = items.categoryNumber.toString();
                    SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ? null: provider!.getLastScoreData(context, items.categoryNumber.toString());
                    },
                    value: items.categoryName,
                    child: Text(items.categoryName.toString()).semiBoldText(
                        ColorConstants.primaryColor,
                        DimensionsConstants.d20.sp,
                        TextAlign.left),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  provider?.categoryDropDownValue = newValue!;
                  provider?.updateData(true);
                }),
          ),
        ),
      ),
    );
  }

  Widget featureText(String text) {
    return Row(
      children: [
        SizedBox(width: DimensionsConstants.d39.w),
        Text(text).regularText(ColorConstants.colorBlack,
            DimensionsConstants.d16.sp, TextAlign.left),
      ],
    );
  }

  Widget startFinishBtn(String text) {
    return Container(
      alignment: Alignment.center,
      height: DimensionsConstants.d50.h,
      width: DimensionsConstants.d201.w,
      decoration: BoxDecoration(
        color: ColorConstants.primaryColor,
        borderRadius:
            BorderRadius.all(Radius.circular(DimensionsConstants.d3.r)),
      ),
      child: Text(text).regularText(ColorConstants.colorWhite,
          DimensionsConstants.d22.sp, TextAlign.left),
    );
  }

  Widget cameraSwitch() {
    return FlutterSwitch(
      activeText: "Back Camera",
      inactiveText: "Front Camera",
      activeColor: ColorConstants.primaryColor,
      value: provider!.isSwitched,
      valueFontSize: DimensionsConstants.d10.sp,
      width: DimensionsConstants.d100.w,
      borderRadius: DimensionsConstants.d30.w,
      showOnOff: true,
      onToggle: (val) {
        provider!.isSwitched = val;
        if (val == true) {
          provider!.selectedCameraIndex = 1;
        } else {
          provider!.selectedCameraIndex = 0;
        }
        //   SharedPref.prefs?.setBool(SharedPref.selectedCameraIndex, val);
        provider!.updateData(true);
      },
    );
  }

  twoMinTimer() {
    /// Initialize a periodic timer with 1 second duration
    provider?.timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        /// callback will be executed every 1 second, increment a count value
        /// on each callback
        provider?.secondsCount++;
        if (provider?.secondsCount == 60 && provider?.minuteCount == 1) {
          provider?.minuteCount = 2;
          provider?.secondsCount = 0;
        } else if (provider?.secondsCount == 60 && provider?.minuteCount == 0) {
          provider?.secondsCount = 0;
          provider?.minuteCount = 1;
        } else if (provider?.secondsCount == 38 && provider?.minuteCount == 2) {
          DialogHelper.showMessage(
              context, "Sorry, Video record cannot be more than 2 minutes.");
          stopVideoRecording().then((XFile? file) async {
            if (mounted) {
              provider?.updateData(true);
            }
            if (file != null) {
              provider?.secondsCount = 0;
              provider?.minuteCount = 0;
              provider?.timer?.cancel();
              SharedPref.prefs!.getString(SharedPref.userType) == "Teacher"
                  ? await provider?.uploadVideo(context, file)
                  : await provider!.uploadVideoStudent(context, file);
            }
          });
          timer.cancel();
        }
        provider?.updateData(true);
      },
    );
  }

// this code is for web camera
  CameraController? controller;
  XFile? imageFile;
  XFile? videoFile;
  //VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  late AnimationController _exposureModeControlRowAnimationController;
  late Animation<double> _exposureModeControlRowAnimation;
  late AnimationController _focusModeControlRowAnimationController;
  late Animation<double> _focusModeControlRowAnimation;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: Transform(
          alignment: Alignment.center, //Default is left
          transform: provider!.selectedCameraIndex == 0
              ? Matrix4.rotationY(0)
              : Matrix4.rotationY(math.pi), //Mirror Widget
          child: CameraPreview(
            controller!,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onScaleStart: _handleScaleStart,
                onScaleUpdate: _handleScaleUpdate,
                onTapDown: (TapDownDetails details) =>
                    onViewFinderTap(details, constraints),
              );
            }),
          ),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    final CameraController? cameraController = controller;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  !cameraController.value.isRecordingVideo &&
                  SharedPref.prefs!.getString(SharedPref.userType) == "Teacher"
              ? onVideoRecordButtonPressed
              : onVideoRecordButtonPressedStudent,
        ),
        IconButton(
          icon: cameraController != null &&
                  cameraController.value.isRecordingPaused
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.pause),
          color: Colors.blue,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  cameraController.value.isRecordingVideo
              ? (cameraController.value.isRecordingPaused)
                  ? onResumeButtonPressed
                  : onPauseButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  cameraController.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.pause_presentation),
          color:
              cameraController != null && cameraController.value.isPreviewPaused
                  ? Colors.red
                  : Colors.blue,
          onPressed:
              cameraController == null ? null : onPausePreviewButtonPressed,
        ),
      ],
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        // The exposure mode is currently not supported on the web.
        ...!kIsWeb
            ? <Future<Object?>>[
                cameraController.getMinExposureOffset().then(
                    (double value) => _minAvailableExposureOffset = value),
                cameraController
                    .getMaxExposureOffset()
                    .then((double value) => _maxAvailableExposureOffset = value)
              ]
            : <Future<Object?>>[],
        cameraController
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onExposureModeButtonPressed() {
    if (_exposureModeControlRowAnimationController.value == 1) {
      _exposureModeControlRowAnimationController.reverse();
    } else {
      _exposureModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onFocusModeButtonPressed() {
    if (_focusModeControlRowAnimationController.value == 1) {
      _focusModeControlRowAnimationController.reverse();
    } else {
      _focusModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _exposureModeControlRowAnimationController.reverse();
    }
  }

  void onAudioModeButtonPressed() {
    enableAudio = !enableAudio;
    if (controller != null) {
      onNewCameraSelected(controller!.description);
    }
  }

  Future<void> onCaptureOrientationLockButtonPressed() async {
    try {
      if (controller != null) {
        final CameraController cameraController = controller!;
        if (cameraController.value.isCaptureOrientationLocked) {
          await cameraController.unlockCaptureOrientation();
          showInSnackBar('Capture orientation unlocked');
        } else {
          await cameraController.lockCaptureOrientation();
          showInSnackBar(
              'Capture orientation locked to ${cameraController.value.lockedCaptureOrientation.toString().split('.').last}');
        }
      }
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  void onVideoRecordButtonPressed() {

    if (provider?.categoryDropDownValueId == null ||
        provider?.categoryDropDownValueId == "null") {
      DialogHelper.showMessage(context, "choose_category_first".tr());
    } else if (provider?.studentId1 == null &&
        provider?.studentId2 == null &&
        provider?.studentId3 == null &&
        provider?.studentId4 == null &&
        provider?.studentId5 == null) {
      DialogHelper.showMessage(context, "please_select_student".tr());
    } else {
      //  DialogHelper.showMessage(context, "okkkk");
      startVideoRecording().then((_) {
        if (mounted) {
          twoMinTimer();
          provider?.updateData(true);
        }
      });
    }
  }

  void onVideoRecordButtonPressedStudent() {
    if (provider?.categoryDropDownValueId == null ||
        provider?.categoryDropDownValueId == "null") {
      DialogHelper.showMessage(context, "choose_category_first".tr());
    } else {
      //  DialogHelper.showMessage(context, "okkkk");
      startVideoRecording().then((_) {
        if (mounted) {
          twoMinTimer();
          provider?.updateData(true);
        }
      });
    }
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((XFile? file) async {
      if (mounted) {
        provider?.updateData(true);
      }
      if (file != null) {
        provider?.timer?.cancel();
        SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ? await provider?.uploadVideo(context, file) : await provider!.uploadVideoStudent(context, file);

      }

    });
  }

  Future<void> onPausePreviewButtonPressed() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isPreviewPaused) {
      await cameraController.resumePreview();
    } else {
      await cameraController.pausePreview();
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Video recording resumed');
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;
    if(provider!.categoryDropDownValueId == "9.1"){
      provider!.startThePlayer();
    }else{}


    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;
    provider!.stopPlayer();

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setExposureMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureOffset(double offset) async {
    if (controller == null) {
      return;
    }

    setState(() {
      _currentExposureOffset = offset;
    });
    try {
      offset = await controller!.setExposureOffset(offset);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFocusMode(FocusMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFocusMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}

Widget roundForStudent(TestPageProvider provider) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("round".tr()).boldText(ColorConstants.primaryColor,
              DimensionsConstants.d25.h, TextAlign.left),
          SizedBox(
            height: DimensionsConstants.d5.h,
          ),
          Text(provider.round == null
                  ? "0"
                  : provider.round.toString())
              .boldText(ColorConstants.primaryColor, DimensionsConstants.d25.h,
                  TextAlign.left),
        ],
      ),
      SizedBox(
        width: DimensionsConstants.d40.w,
      ),
      Text(provider.totalScores.isEmpty
              ? " "
              : provider.totalScores[0].totalScore.toStringAsFixed(2))
          .boldText(ColorConstants.primaryColor, DimensionsConstants.d25.h,
              TextAlign.left),
      SizedBox(
        width: DimensionsConstants.d40.w,
      ),
    ],
  );
}
