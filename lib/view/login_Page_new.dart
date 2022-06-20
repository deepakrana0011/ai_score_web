import 'package:ai_score/constants/color_constants.dart';
import 'package:ai_score/constants/decoration.dart';
import 'package:ai_score/constants/dimensions_constants.dart';
import 'package:ai_score/constants/image_constants.dart';
import 'package:ai_score/constants/route_constants.dart';
import 'package:ai_score/constants/validations.dart';
import 'package:ai_score/enum/view_state.dart';
import 'package:ai_score/extensions/all_extensions.dart';
import 'package:ai_score/helper/dialog_helper.dart';
import 'package:ai_score/helper/shared_pref.dart';
import 'package:ai_score/providers/login_provider.dart';
import 'package:ai_score/view/base_view.dart';
import 'package:ai_score/widgets/custom_shape.dart';
import 'package:ai_score/widgets/image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BaseView<LoginProvider>(
      onModelReady: (provider) {
        provider.passwordVisible = false;
      },
      builder: (context, provider, _) {
        return Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/loginNewImage.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
                left: DimensionsConstants.d1000.w,
                top: DimensionsConstants.d120.h,
                child: Container(
                  height: DimensionsConstants.d770.h,
                  width: DimensionsConstants.d410.w,
                  decoration: BoxDecoration(
                      color: ColorConstants.grayColor,
                      borderRadius:
                          BorderRadius.circular(DimensionsConstants.d8.r)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: DimensionsConstants.d40.w),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: DimensionsConstants.d65.h,
                        ),
                        ImageView(
                          path: ImageConstants.icAeroplane,
                          height: DimensionsConstants.d128.h,
                        ),
                        SizedBox(
                          height: DimensionsConstants.d65.h,
                        ),
                        Text("login_admin".tr()).semiBoldText(
                          ColorConstants.primaryColor
                              .withOpacity(ColorConstants.textOpacity),
                          DimensionsConstants.d30.sp,
                          TextAlign.start,
                        ),
                        SizedBox(
                          height: DimensionsConstants.d65.h,
                        ),
                        Material(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  DimensionsConstants.d8.w)),
                          child: TextFormField(
                            //   enabled: signUpType!=StringConstants.social,
                            controller: emailController,
                            style: ViewDecoration.regular(
                                DimensionsConstants.d20.sp,
                                ColorConstants.colorBlack),
                            decoration: ViewDecoration.inputDecorationWithCurve(
                                "email".tr()),
                            onFieldSubmitted: (data) {
                              // FocusScope.of(context).requestFocus(nodes[1]);
                            },
                            onChanged: (v) {},
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.emailAddress,

                          ),
                        ),
                        SizedBox(
                          height: DimensionsConstants.d20.h,
                        ),
                        Material(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  DimensionsConstants.d8.h)),
                          child: SizedBox(
                            //  height: DimensionsConstants.d63.h,
                            child: TextFormField(
                                obscureText: !provider.passwordVisible,
                                controller: passwordController,
                                style: ViewDecoration.regular(
                                    DimensionsConstants.d20.sp,
                                    ColorConstants.colorBlack),
                                decoration:
                                    ViewDecoration.inputDecorationWithCurve(
                                  "password".tr(),
                                  icon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      provider.passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      provider.passwordVisible =
                                          !provider.passwordVisible;
                                      provider.updateData(true);
                                    },
                                  ),
                                ),
                                onFieldSubmitted: (data) {
                                  // FocusScope.of(context).requestFocus(nodes[1]);
                                },
                                onChanged: (v) {},
                                validator: (value) {

                                },
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.emailAddress),
                          ),
                        ),
                        SizedBox(
                          height: DimensionsConstants.d30.h,
                        ),
                        provider.state == ViewState.Busy
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : GestureDetector(
                                onTap: () {
                                  provider.login(context, emailController.text,
                                      passwordController.text);
                                },
                                child: CustomShape(
                                  gradientColor1: ColorConstants.primaryColor,
                                  gradientColor2: ColorConstants.primaryColor,
                                  radius: BorderRadius.all(Radius.circular(
                                      DimensionsConstants.d8.h)),
                                  width: DimensionsConstants.mockupWidth.w,
                                  height: DimensionsConstants.d63.h,
                                  child: Text("login".tr()).boldText(
                                      ColorConstants.colorWhite,
                                      DimensionsConstants.d20.sp,
                                      TextAlign.center),
                                ),
                              )
                      ],
                    ),
                  ),
                ))
          ],
        );
      },
    ));
  }
}
