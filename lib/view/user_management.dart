import 'package:ai_score/constants/color_constants.dart';
import 'package:ai_score/constants/decoration.dart';
import 'package:ai_score/constants/dimensions_constants.dart';
import 'package:ai_score/constants/image_constants.dart';
import 'package:ai_score/extensions/all_extensions.dart';
import 'package:ai_score/helper/dialog_helper.dart';
import 'package:ai_score/models/add_edit_student_response.dart';
import 'package:ai_score/models/student_data.dart';
import 'package:ai_score/providers/user_management_provider.dart';
import 'package:ai_score/view/base_view.dart';
import 'package:ai_score/widgets/image_view.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:number_paginator/number_paginator.dart';


class UserManagement extends StatefulWidget {
  const UserManagement({Key? key}) : super(key: key);

  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final nameController = TextEditingController();
  final studentNumberController = TextEditingController();
  final passwordController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  UserManagementProvider provider = UserManagementProvider();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BaseView<UserManagementProvider>(
      onModelReady: (provider) async {
        this.provider = provider;
        await provider.getStudentsData(context);
      },
      builder: (context, provider, _) {
        return Container(
          margin: EdgeInsets.fromLTRB(
              DimensionsConstants.d15.w, 0.0, DimensionsConstants.d15.w, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: DimensionsConstants.d30.h),
              Container(
                padding: EdgeInsets.fromLTRB(DimensionsConstants.d81.w, 0.0,
                    DimensionsConstants.d81.w, 0.0),
                height: DimensionsConstants.d80.h,
                width: DimensionsConstants.d1410.w,
                color: ColorConstants.colorBluishWhite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("name".tr()).semiBoldText(ColorConstants.primaryColor,
                        DimensionsConstants.d20.sp, TextAlign.left),
                    Text("student_number".tr()).semiBoldText(
                        ColorConstants.primaryColor,
                        DimensionsConstants.d20.sp,
                        TextAlign.left),
                    Text("password".tr()).semiBoldText(
                        ColorConstants.primaryColor,
                        DimensionsConstants.d20.sp,
                        TextAlign.left),
                    Text("joining_date".tr()).semiBoldText(
                        ColorConstants.primaryColor,
                        DimensionsConstants.d20.sp,
                        TextAlign.left),
                    Text("update_date".tr()).semiBoldText(
                        ColorConstants.primaryColor,
                        DimensionsConstants.d20.sp,
                        TextAlign.left),
                    Text("action".tr()).semiBoldText(
                        ColorConstants.primaryColor,
                        DimensionsConstants.d20.sp,
                        TextAlign.left),
                  ],
                ),
              ),
              SizedBox(height: DimensionsConstants.d15.h),
              provider.addData == true
                  ? Container(
                      height: DimensionsConstants.d685.h,
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(height: DimensionsConstants.d100.h),
                            const CircularProgressIndicator(),
                            Text("getting_students_data".tr()).semiBoldText(
                                ColorConstants.primaryColor,
                                DimensionsConstants.d18.sp,
                                TextAlign.left),
                          ],
                        ),
                      ),
                    )
                  : provider.studentsDataList.isEmpty
                      ? Container()
                      : Expanded(
                          child: SingleChildScrollView(
                              child: studentDataListView(provider))),
              SizedBox(height: DimensionsConstants.d30.h),
              Divider(color: ColorConstants.colorBlack),
              SizedBox(width: DimensionsConstants.d10.w),
              if(provider.addData != true)addFieldText()
            ],
          ),
        );
      },
    ));
  }

  Widget studentData(Data data) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          DimensionsConstants.d30.w, 0.0, DimensionsConstants.d5.w, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // color: Colors.limeAccent,
            width: DimensionsConstants.d170.w,
            child: Text(data.studentName!).regularText(
                ColorConstants.colorBlack,
                DimensionsConstants.d20.sp,
                TextAlign.center),
          ),
          Container(
            //  color: Colors.limeAccent,
            width: DimensionsConstants.d170.w,
            child: Text(data.studentNo!).regularText(ColorConstants.colorBlack,
                DimensionsConstants.d20.sp, TextAlign.center),
          ),
          Container(
            //  color: Colors.limeAccent,
            width: DimensionsConstants.d170.w,
            child: Text(data.password!).regularText(ColorConstants.colorBlack,
                DimensionsConstants.d20.sp, TextAlign.center),
          ),
          Container(
            //    color: Colors.limeAccent,
            width: DimensionsConstants.d160.w,
            child: Text(data.createdDate.toString().substring(0, 10))
                .regularText(ColorConstants.colorBlack,
                    DimensionsConstants.d20.sp, TextAlign.center),
          ),
          Container(
            //  color: Colors.limeAccent,
            width: DimensionsConstants.d160.w,
            child: Text(data.updatedDate.toString().substring(0, 10))
                .regularText(ColorConstants.colorBlack,
                    DimensionsConstants.d20.sp, TextAlign.center),
          ),
          Container(width: DimensionsConstants.d168.w, child: actionIcon(data))
        ],
      ),
    );
  }

  /* Widget studentDataListView(UserManagementProvider provider) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.studentsDataList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              studentData(provider.studentsDataList[index]),
              SizedBox(height: DimensionsConstants.d20.h),
            ],
          );
        });
  }
*/
  Widget studentDataListView(UserManagementProvider provider) {

    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.studentList[provider.currentPage].length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              studentData(provider.studentList[provider.currentPage][index]),
              SizedBox(height: DimensionsConstants.d20.h),
            ],
          );
        });
  }

  Widget actionIcon(Data data) {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              deleteStudentAlertDialog(data.id.toString());
            },
            child: const ImageView(path: ImageConstants.deleteIcon)),
        SizedBox(width: DimensionsConstants.d20.w),
        GestureDetector(
            onTap: () {
              provider.edit = true;
              provider.studentId = data.id;
              nameController.text = data.studentName!;
              studentNumberController.text = data.studentNo!;
              addUpdateStudentFieldAlertDialog("Update Student");
            },
            child: const ImageView(path: ImageConstants.editIcon)),
        SizedBox(width: DimensionsConstants.d16.w),
        GestureDetector(
            onTap: () {
              provider.studentId = data.id;
              passwordController.text = data.password!;
              changePasswordAlertDialog();
            },
            child: const ImageView(path: ImageConstants.reloadIcon)),
        data.status == 0
            ? SizedBox(width: DimensionsConstants.d16.w)
            : SizedBox(width: 0),
        data.status == 0
            ? GestureDetector(
                onTap: () {
                  approveOrRejectStudentAlertDialog(
                      data.studentName!, data.studentNo!, data.id!);
                },
                child: const Icon(Icons.check))
            : Container(),
      ],
    );
  }

  Widget addFieldText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: DimensionsConstants.d140.w,
        ),
        SizedBox(
          height: DimensionsConstants.d50.h,
          width: DimensionsConstants.d210.w,
          child: NumberPaginator(
            numberPages: provider.numberOfPages,
            initialPage: provider.currentPage,
            onPageChange: (int index) {
              provider.updateCurrentPage(index);
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            provider.edit = false;
            nameController.clear();
            studentNumberController.clear();
            passwordController.clear();
            addUpdateStudentFieldAlertDialog("Add Student");
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("add".tr()).regularText(ColorConstants.color1A0DAB,
                  DimensionsConstants.d20.sp, TextAlign.left),
              SizedBox(width: DimensionsConstants.d10.w),
              const ImageView(path: ImageConstants.addFieldIcon),
              SizedBox(width: DimensionsConstants.d75.w),
            ],
          ),
        ),
      ],
    );
  }

  addUpdateStudentFieldAlertDialog(String btnText) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(DimensionsConstants.d15.r))),
          content: Builder(
            builder: (context) {
              return SizedBox(
                height: provider.edit == true
                    ? DimensionsConstants.d450.h
                    : DimensionsConstants.d600.h,
                width: DimensionsConstants.d350.w,
                child: Column(
                  children: [
                    Text(provider.edit == true
                            ? "Edit Student Data"
                            : "Enter Student Data")
                        .boldText(ColorConstants.colorBlack,
                            DimensionsConstants.d18.sp, TextAlign.left),
                    SizedBox(height: DimensionsConstants.d30.h),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Enter Name").semiBoldText(
                              ColorConstants.colorBlack,
                              DimensionsConstants.d16.sp,
                              TextAlign.left),
                          SizedBox(height: DimensionsConstants.d3.h),
                          nameTextField(),
                          SizedBox(height: DimensionsConstants.d20.h),
                          const Text("Enter Student Number").semiBoldText(
                              ColorConstants.colorBlack,
                              DimensionsConstants.d16.sp,
                              TextAlign.left),
                          SizedBox(height: DimensionsConstants.d3.h),
                          studentNumberTextField(),
                          SizedBox(height: DimensionsConstants.d20.h),
                          provider.edit == true
                              ? Container()
                              : const Text("Enter Password").semiBoldText(
                                  ColorConstants.colorBlack,
                                  DimensionsConstants.d16.sp,
                                  TextAlign.left),
                          provider.edit == true
                              ? Container()
                              : SizedBox(height: DimensionsConstants.d3.h),
                          provider.edit == true
                              ? Container()
                              : passwordTextField(),
                        ],
                      ),
                    ),
                    SizedBox(height: DimensionsConstants.d50.h),
                    provider.addData == true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : addUpdateBtn(btnText)
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  changePasswordAlertDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(DimensionsConstants.d15.r))),
          content: Builder(
            builder: (context) {
              return SizedBox(
                height: DimensionsConstants.d300.h,
                width: DimensionsConstants.d350.w,
                child: Column(
                  children: [
                    const Text("Change Password").boldText(
                        ColorConstants.colorBlack,
                        DimensionsConstants.d18.sp,
                        TextAlign.left),
                    SizedBox(height: DimensionsConstants.d30.h),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Enter Password").semiBoldText(
                              ColorConstants.colorBlack,
                              DimensionsConstants.d16.sp,
                              TextAlign.left),
                          SizedBox(height: DimensionsConstants.d3.h),
                          passwordTextField(),
                        ],
                      ),
                    ),
                    SizedBox(height: DimensionsConstants.d50.h),
                    provider.addData == true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : changePasswordBtn()
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget nameTextField() {
    return TextFormField(
      autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      controller: nameController,
      focusNode: nameFocusNode,
      style: ViewDecoration.regular(
          DimensionsConstants.d15.sp, ColorConstants.colorBlack),
      decoration: ViewDecoration.inputDecorationWithCurve("Name",
          size: DimensionsConstants.d15.sp,
          fillColor: ColorConstants.colorBluishWhite),
      onFieldSubmitted: (data) {
        // FocusScope.of(context).requestFocus(nodes[1]);
      },
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "name_required".tr();
        }
        {
          return null;
        }
      },
    );
  }

  Widget studentNumberTextField() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: studentNumberController,
      style: ViewDecoration.regular(
          DimensionsConstants.d15.sp, ColorConstants.colorBlack),
      decoration: ViewDecoration.inputDecorationWithCurve("Student Number",
          size: DimensionsConstants.d15.sp,
          fillColor: ColorConstants.colorBluishWhite),
      onFieldSubmitted: (data) {
        // FocusScope.of(context).requestFocus(nodes[1]);
      },
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "student_no_required".tr();
        }
        {
          return null;
        }
      },
    );
  }

  Widget passwordTextField() {
    return TextFormField(
      readOnly: provider.edit,
      textCapitalization: TextCapitalization.sentences,
      controller: passwordController,
      style: ViewDecoration.regular(
          DimensionsConstants.d16.sp, ColorConstants.colorBlack),
      decoration: ViewDecoration.inputDecorationWithCurve("Password",
          size: DimensionsConstants.d16.sp,
          fillColor: ColorConstants.colorBluishWhite),
      onFieldSubmitted: (data) {
        // FocusScope.of(context).requestFocus(nodes[1]);
      },
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "password_required".tr();
        }
        {
          return null;
        }
      },
    );
  }

  Widget addUpdateBtn(String text) {
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          // provider.studentDataList.add(StudentData(name: nameController.text, studentNumber: studentNumberController.text, password: passwordController.text));
          //  Navigator.of(context).pop();
          // provider.updateAddData(false);
          if (provider.edit == false) {
            provider
                .addStudent(context, nameController.text,
                    studentNumberController.text, passwordController.text)
                .then((value) {
              provider.getStudentsData(context);
            });
          } else {
            provider
                .editStudent(context, nameController.text,
                    studentNumberController.text, provider.studentId!, "1")
                .then((value) {
              provider.getStudentsData(context);
            });
          }
        }
      },
      child: Container(
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
      ),
    );
  }

  Widget changePasswordBtn() {
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          provider
              .changePassword(
                  context, provider.studentId!, passwordController.text)
              .then((value) {
            provider.getStudentsData(context);
          });
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: DimensionsConstants.d50.h,
        width: DimensionsConstants.d201.w,
        decoration: BoxDecoration(
          color: ColorConstants.primaryColor,
          borderRadius:
              BorderRadius.all(Radius.circular(DimensionsConstants.d3.r)),
        ),
        child: const Text("Update Password").regularText(
            ColorConstants.colorWhite,
            DimensionsConstants.d22.sp,
            TextAlign.left),
      ),
    );
  }

  deleteStudentAlertDialog(String id) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(DimensionsConstants.d15.r))),
          content: Builder(
            builder: (context) {
              return SizedBox(
                height: DimensionsConstants.d230.h,
                width: DimensionsConstants.d300.w,
                child: Column(
                  children: [
                    Text("delete_student".tr()).boldText(
                        ColorConstants.colorBlack,
                        DimensionsConstants.d18.sp,
                        TextAlign.left),
                    SizedBox(height: DimensionsConstants.d20.h),
                    Text("sure_to_delete_student".tr()).mediumText(
                        ColorConstants.colorBlack,
                        DimensionsConstants.d16.sp,
                        TextAlign.center),
                    SizedBox(height: DimensionsConstants.d35.h),
                    deleteStudentBtn(id)
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget deleteStudentBtn(String id) {
    return GestureDetector(
      onTap: () {
        provider.deleteStudent(context, id).then((value) {
          provider.getStudentsData(context);
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: DimensionsConstants.d50.h,
        width: DimensionsConstants.d201.w,
        decoration: BoxDecoration(
          color: ColorConstants.primaryColor,
          borderRadius:
              BorderRadius.all(Radius.circular(DimensionsConstants.d3.r)),
        ),
        child: Text("delete_student".tr()).regularText(
            ColorConstants.colorWhite,
            DimensionsConstants.d22.sp,
            TextAlign.left),
      ),
    );
  }

  approveOrRejectStudentAlertDialog(String name, String studentNo, String id) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(DimensionsConstants.d15.r))),
          content: Builder(
            builder: (context) {
              return SizedBox(
                height: DimensionsConstants.d230.h,
                width: DimensionsConstants.d300.w,
                child: Column(
                  children: [
                    Text("approve_student".tr()).boldText(
                        ColorConstants.colorBlack,
                        DimensionsConstants.d18.sp,
                        TextAlign.left),
                    SizedBox(height: DimensionsConstants.d20.h),
                    Text("approve_or_reject".tr()).mediumText(
                        ColorConstants.colorBlack,
                        DimensionsConstants.d16.sp,
                        TextAlign.center),
                    SizedBox(height: DimensionsConstants.d35.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        approveStudentBtn(name, studentNo, id, "1"),
                        rejectStudentBtn(name, studentNo, id, "2")
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget approveStudentBtn(
      String name, String studentNo, String id, String status) {
    return GestureDetector(
      onTap: () {
        provider
            .editStudent(context, name, studentNo, id, status)
            .then((value) {
          provider.getStudentsData(context);
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: DimensionsConstants.d50.h,
        width: DimensionsConstants.d100.w,
        decoration: BoxDecoration(
          color: ColorConstants.primaryColor,
          borderRadius:
              BorderRadius.all(Radius.circular(DimensionsConstants.d3.r)),
        ),
        child: Text("approve".tr()).regularText(ColorConstants.colorWhite,
            DimensionsConstants.d20.sp, TextAlign.left),
      ),
    );
  }

  Widget rejectStudentBtn(
      String name, String studentNo, String id, String status) {
    return GestureDetector(
      onTap: () {
        provider
            .editStudent(context, name, studentNo, id, status)
            .then((value) {
          provider.getStudentsData(context);
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: DimensionsConstants.d50.h,
        width: DimensionsConstants.d100.w,
        decoration: BoxDecoration(
          color: ColorConstants.primaryColor,
          borderRadius:
              BorderRadius.all(Radius.circular(DimensionsConstants.d3.r)),
        ),
        child: Text("reject".tr()).regularText(ColorConstants.colorWhite,
            DimensionsConstants.d20.sp, TextAlign.left),
      ),
    );
  }

}

/*class CustomSliverChildBuilderDelegate extends SliverChildBuilderDelegate
    with DataPagerDelegate, ChangeNotifier {
  CustomSliverChildBuilderDelegate(builder) : super(builder);

  @override
  int get childCount => _paginatedProductData.length;

  @override
  int get rowCount => _products.length;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex,
      int startRowIndex, int rowsPerPage) async {
    int endIndex = startRowIndex + rowsPerPage;

    if (endIndex > _products.length) {
      endIndex = _products.length - 1;
    }

    await Future.delayed(Duration(milliseconds: 2000));
    _paginatedProductData = _products
        .getRange(startRowIndex, endIndex)
        .toList(growable: false);

    notifyListeners();
    return true;
  }

  @override
  bool shouldRebuild(covariant CustomSliverChildBuilderDelegate oldDelegate) {
    return true;
  }
}*/

