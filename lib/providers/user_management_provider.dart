import 'dart:io';

import 'package:ai_score/enum/view_state.dart';
import 'package:ai_score/fetch_data_exception.dart';
import 'package:ai_score/helper/dialog_helper.dart';
import 'package:ai_score/helper/shared_pref.dart';
import 'package:ai_score/models/add_edit_student_response.dart' as studentData;
import 'package:ai_score/models/student_data.dart';
import 'package:ai_score/providers/base_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart' as iterable;

class UserManagementProvider extends BaseProvider {
  final token = SharedPref.prefs?.getString(SharedPref.token) ?? '';

//  List<StudentData> studentDataList = [];

  List<studentData.Data> studentsDataList = [];
  List<studentData.Data> paginatedOrders = [];

  bool edit = false;
  String? studentId;
  List<int> lengthOfList = [];

  bool addData = false;

  int numberOfPages = 0;
  int currentPage = 0;
  int numberOfItemsPerPage = 10;
  List<List<studentData.Data>> studentList = [];

  updateAddData(bool val) {
    addData = val;
    notifyListeners();
  }

  Future<bool> getStudentsData(BuildContext context) async {
    updateAddData(true);
    try {
      var model = await api.getStudents(token);
      if (model.success == true) {
        studentsDataList.clear();
        studentsDataList.addAll(model.studentDataList);
        if (studentsDataList.length % numberOfItemsPerPage == 0) {
          numberOfPages = studentsDataList.length ~/ numberOfItemsPerPage;
        } else if (studentsDataList.length / numberOfItemsPerPage > 0) {
          numberOfPages = studentsDataList.length ~/ numberOfItemsPerPage + 1;
        } else if (studentsDataList.length / numberOfItemsPerPage < 0) {
          numberOfPages = studentsDataList.length ~/ numberOfItemsPerPage + 1;
        } else {
          numberOfPages = studentsDataList.length ~/ numberOfItemsPerPage;
        }

        studentList = iterable.partition(studentsDataList, numberOfItemsPerPage).toList();
      } else {
        DialogHelper.showMessage(context, model.message);
      }
      updateAddData(false);
      return true;
    } on FetchDataException catch (c) {
      updateAddData(false);
      DialogHelper.showMessage(context, c.toString());
      return false;
    } on SocketException catch (c) {
      updateAddData(false);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startIndex = newPageIndex * 10;
    int endIndex = startIndex + 10;
    if (startIndex < studentsDataList.length &&
        endIndex <= studentsDataList.length) {
      paginatedOrders = studentsDataList
          .getRange(startIndex, endIndex)
          .toList(growable: false);

      notifyListeners();
    } else {
      paginatedOrders = [];
    }

    return true;
  }

  Future<bool> addStudent(BuildContext context, String studentName,
      String studentNo, String password) async {
    updateAddData(true);
    try {
      var model = await api.addStudent(studentName, studentNo, password, token);
      if (model.success == true) {
        Navigator.of(context).pop();
        //  DialogHelper.showMessage(context, "student_added_successfully".tr());
      } else {
        DialogHelper.showMessage(context, model.message);
      }
      updateAddData(false);
      return true;
    } on FetchDataException catch (c) {
      updateAddData(false);
      DialogHelper.showMessage(context, c.toString());
      return false;
    } on SocketException catch (c) {
      updateAddData(false);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  Future<bool> editStudent(BuildContext context, String studentName,
      String studentNo, String studentId, String status) async {
    updateAddData(true);
    try {
      var model = await api.editStudent(
          studentName, studentNo, studentId, status, token);
      if (model.success == true) {
        Navigator.of(context).pop();
      } else {
        DialogHelper.showMessage(context, model.message);
      }
      updateAddData(false);
      return true;
    } on FetchDataException catch (c) {
      updateAddData(false);
      DialogHelper.showMessage(context, c.toString());
      return false;
    } on SocketException catch (c) {
      updateAddData(false);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  Future<bool> changePassword(
      BuildContext context, String studentId, String password) async {
    updateAddData(true);
    try {
      var model = await api.changePassword(studentId, password, token);
      if (model.success == true) {
        Navigator.of(context).pop();
      } else {
        DialogHelper.showMessage(context, model.message);
      }
      updateAddData(false);
      return true;
    } on FetchDataException catch (c) {
      updateAddData(false);
      DialogHelper.showMessage(context, c.toString());
      return false;
    } on SocketException catch (c) {
      updateAddData(false);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  Future<bool> deleteStudent(BuildContext context, String id) async {
    updateAddData(true);
    try {
      var model = await api.deleteStudent(id, token);
      if (model.success == true) {
        Navigator.of(context).pop();
        //  DialogHelper.showMessage(context, "student_added_successfully".tr());
      } else {
        DialogHelper.showMessage(context, model.message);
      }
      updateAddData(false);
      return true;
    } on FetchDataException catch (c) {
      updateAddData(false);
      DialogHelper.showMessage(context, c.toString());
      return false;
    } on SocketException catch (c) {
      updateAddData(false);
      DialogHelper.showMessage(context, 'internet_connection'.tr());
      return false;
    }
  }

  void updateCurrentPage(int index) {
    currentPage = index;
    notifyListeners();
  }
}
