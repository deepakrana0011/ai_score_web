import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:ai_score/constants/dimensions_constants.dart';
import 'package:ai_score/constants/image_constants.dart';
import 'package:ai_score/enum/view_state.dart';
import 'package:ai_score/fetch_data_exception.dart';
import 'package:ai_score/helper/dialog_helper.dart';
import 'package:ai_score/helper/shared_pref.dart';
import 'package:ai_score/json/category_json.dart';
import 'package:ai_score/models/category_list_model.dart';
import 'package:ai_score/models/get_scores_response.dart';
import 'package:ai_score/providers/base_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiver/iterables.dart' as iterable;
import 'package:ai_score/models/get_score_student_side_response.dart';

class ScoreManagementProvider extends BaseProvider {
  final token = SharedPref.prefs?.getString(SharedPref.token) ?? '';

  DateTime? selectedDate;
  List<CategoryList> categoryList = [];
  String categoryDropDownValue = "";
  String? categoryDropDownValueId;
  String? nameOfDropDown;

  List<Data> getScoresList = [];
  List<GetScoreData> getScoresListStudent = [];
  List<Data> getScoreListPaging = [];
  List<List<GetScoreData>> getScoreListPagingStudent = [];
  bool selectedCategoryParam = false;
  bool selectedDateParam = false;
  int numberOfPages = 1;
  int currentPage = 0;
  int numberOfItemsPerPage = 10;

  bool data = false;
  bool identification = false;
  bool getDataIdentification = true;

  String? getTotalSum;
  String? valueAfterUpdate;

  updateData(bool val) {
    data = val;
    notifyListeners();
  }

  void updateCurrentPage(int index) {
    currentPage = index;
    notifyListeners();
  }

  Timer? searchOnStoppedTyping;

  onChangeHandler(value) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      const duration = Duration(
          milliseconds:
              800); // set the duration that you want call search() after that.
      if (searchOnStoppedTyping != null) {
        searchOnStoppedTyping?.cancel();
        notifyListeners();
        // clear timer
      }
      searchOnStoppedTyping = Timer(duration, () {
        search(value);
      });
      notifyListeners();
    });
  }

  search(value) {
    print('hello world from search . the value is $value');
  }

  // List<String> sumOfTotalScore = [];
  getTotalScore(Data getScores, double angleScore, double teacherScore) {
    getScores.totalScore = 0;
    getScores.angleScore = angleScore;
    getScores.teacherScore = teacherScore;
    getScores.totalScore = (angleScore + teacherScore);
    notifyListeners();
  }

  //Method for showing the date picker
  pickDateDialog(BuildContext context) {
    var initialDate = selectedDate;
    DateTime todayDate;
    if (initialDate == null) {
      todayDate = DateTime.now();
    } else {
      todayDate = initialDate;
    }
    showDatePicker(
            context: context,
            initialDate: todayDate,
            //which date will display when user open the picker
            firstDate: DateTime(2000),
            //what will be the previous supported year in picker
            lastDate: DateTime
                .now()) //what will be the up to supported date in picker
        .then((pickedDate) async {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      //for rebuilding the ui
      selectedDate = pickedDate;
      selectedDateParam = true;
      await getAllScores(context,
          category: categoryDropDownValueId,
          pageCount: 0,
          date: selectedDate == null
              ? " "
              : selectedDate.toString().substring(0, 10));
    });
  }

  Future<bool> getScoreDataStudentSide(
      BuildContext context, String category, String score) async {
    setState(ViewState.Busy);
    try {
      var model = await api.getScoreStudentSide(context, category, score);

      if (model.success) {
        getScoresListStudent.clear();
        getScoresListStudent.addAll(model.data);
        if (getScoresListStudent.length % numberOfItemsPerPage == 0) {
          numberOfPages = getScoresListStudent.length ~/ numberOfItemsPerPage;
        } else if (getScoresListStudent.length / numberOfItemsPerPage > 0) {
          numberOfPages =
              getScoresListStudent.length ~/ numberOfItemsPerPage + 1;
        } else if (getScoresListStudent.length / numberOfItemsPerPage < 0) {
          numberOfPages =
              getScoresListStudent.length ~/ numberOfItemsPerPage + 1;
        } else {
          numberOfPages = getScoresListStudent.length ~/ numberOfItemsPerPage;
        }
        getScoreListPagingStudent = iterable
            .partition(getScoresListStudent, numberOfItemsPerPage)
            .toList();
      }
      setState(ViewState.Idle);
      return false;
    } on FetchDataException catch (e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.toString());
      return false;
    } on SocketException catch (e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.toString());

      return false;
    }
  }

  Future<bool> getAllScores(BuildContext context,
      {String? category,
      String? date,
      bool showLoader = false,
      int pageCount = 0}) async {
    showLoader == true ? updateSData(true) : setState(ViewState.Busy);
    try {
      var model = await api.getScores(category ?? "", date ?? "",
          selectedCategoryParam, selectedDateParam, token, pageCount);
      if (model.success == true) {
        getScoresList.clear();
        getScoresList.addAll(model.getScores);
        numberOfPages = model.totalCount!;
        currentPage = pageCount;
        getScoreListPaging = getScoresList;
        getDataIdentification = true;
      } else {
        DialogHelper.showMessage(context, "something_went_wrong".tr());
      }
      showLoader == true ? updateSData(false) : setState(ViewState.Idle);
      return true;
    } on FetchDataException catch (c) {
      showLoader == true ? updateSData(false) : setState(ViewState.Idle);
      DialogHelper.showMessage(context, c.toString());
      return false;
    } on SocketException catch (c) {
      showLoader == true ? updateSData(false) : setState(ViewState.Idle);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  getCategoryData() {
    var response = CategoryListModel.fromJson(
        SharedPref.prefs!.getString(SharedPref.userType) == "Teacher"
            ? categoryDataTeacher
            : categoryData);
    categoryList.insert(
        0, CategoryList(categoryName: "all".tr(), categoryNumber: ""));
    categoryList.addAll(response.categoryList);
    categoryDropDownValue = categoryList[0].categoryName!;
  }

  bool updateS = false;

  updateSData(bool val) {
    updateS = val;
    notifyListeners();
  }

  Future<bool> updateScores(BuildContext context, String scoreId,
      String angleScore, String teacherScore) async {
    updateSData(true);
    try {
      var model =
          await api.updateScores(scoreId, angleScore, teacherScore, token);
      if (model.success == true) {
        getDataIdentification = false;

        DialogHelper.showMessage(context, "score_updated".tr());
        /* if (identification = false) {
          await getAllScores(context, true, true, true,
              category: categoryDropDownValueId, showLoader: true);
        } else {
          await getAllScores(context, true, true, true,
              category: categoryDropDownValueId,
              date: selectedDate.toString().substring(0, 10),
              showLoader: true);
        }*/
      } else {
        DialogHelper.showMessage(context, "something_went_wrong".tr());
      }

      updateSData(false);
      return true;
    } on FetchDataException catch (c) {
      updateSData(false);
      DialogHelper.showMessage(context, c.toString());
      return false;
    } on SocketException catch (c) {
      updateSData(false);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  showImageDialog(BuildContext context, Uint8List bytes) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(DimensionsConstants.d15.r))),
          content: Builder(
            builder: (context) {
              return SizedBox(
                height: DimensionsConstants.d750.h,
                width: DimensionsConstants.d400.w,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(
                          Radius.circular(DimensionsConstants.d15.r)),
                      child: Image.memory(
                        bytes,
                        height: DimensionsConstants.d750.h,
                        width: DimensionsConstants.d400.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                        right: 10,
                        top: 10,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 40,
                            )))
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
