import 'package:ai_score/constants/color_constants.dart';
import 'package:ai_score/constants/decoration.dart';
import 'package:ai_score/constants/dimensions_constants.dart';
import 'package:ai_score/constants/image_constants.dart';
import 'package:ai_score/constants/route_constants.dart';
import 'package:ai_score/extensions/all_extensions.dart';
import 'package:ai_score/helper/shared_pref.dart';
import 'package:ai_score/providers/home_provider.dart';
import 'package:ai_score/view/base_view.dart';
import 'package:ai_score/view/score_analysis.dart';
import 'package:ai_score/view/score_management.dart';
import 'package:ai_score/view/test_page.dart';
import 'package:ai_score/view/user_management.dart';
import 'package:ai_score/widgets/image_view.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    controller = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView<HomeProvider>(
        onModelReady: (provider) {},
        builder: (context, provider, _) {
          Widget selectedWidget = const TestPage();
          switch (provider.selectedTabPosition) {
            case 0:
              selectedWidget = const TestPage();
              break;
            case 1:
              SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ?
              selectedWidget = const UserManagement() : Container();
              break;
            case 2:
              selectedWidget = const ScoreManagement();
              break;
            case 3:
              selectedWidget = const ScoreAnalysis();
              break;
          }
          return Column(
            children: [
              Container(
                height: DimensionsConstants.d106.h,
                width: MediaQuery.of(context).size.width,
                color: ColorConstants.colorBluishWhite,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: DimensionsConstants.d8.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ImageView(
                          width: DimensionsConstants.d65.w,
                          height: DimensionsConstants.d59.h,
                          path: ImageConstants.icAppLogo,
                        ),
                        TabBar(
                          controller: controller,
                          labelColor: ColorConstants.colorWhite,
                          indicator: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          DimensionsConstants.d3.h))),
                              color: ColorConstants.primaryColor),
                          labelStyle: ViewDecoration.semiBold(
                              DimensionsConstants.d20.sp,
                              ColorConstants.colorWhite),
                          unselectedLabelColor: ColorConstants.color6F6C99,
                          unselectedLabelStyle: ViewDecoration.semiBold(
                              DimensionsConstants.d20.sp,
                              ColorConstants.color6F6C99),
                          onTap: (position) {
                            provider.updateSelectedTabPosition(position);
                          },
                          tabs: [
                            Text("Test".tr()),
                           SharedPref.prefs!.getString(SharedPref.userType) == "Teacher" ? Text("User Management") : Text(""),
                            Text("Score Management"),
                            Text("Score Analysis")
                          ],
                          isScrollable: true,
                          indicatorWeight: 2.5,
                          indicatorColor: ColorConstants.colorBlack,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                SharedPref.clearSharePref();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    RoutesConstants.login, (route) => false);
                              },
                              child: Text("log_out".tr()).semiBoldText(
                                ColorConstants.primaryColor
                                    .withOpacity(ColorConstants.textOpacity),
                                DimensionsConstants.d18.sp,
                                TextAlign.start,
                              ),
                            ),
                            SizedBox(
                              width: DimensionsConstants.d5.w,
                            ),
                            ImageView(
                              path: ImageConstants.icLogout,
                              width: DimensionsConstants.d24.w,
                              height: DimensionsConstants.d24.h,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(child: selectedWidget)
            ],
          );
        },
      ),
    );
  }
}
