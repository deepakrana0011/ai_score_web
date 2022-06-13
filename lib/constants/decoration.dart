import 'package:ai_score/constants/dimensions_constants.dart';
import 'package:ai_score/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color_constants.dart';

class ViewDecoration {
  static InputDecoration inputDecorationWithCurve(String fieldName,
      {Widget? icon, Widget? prefixIcon,  double? size, Color? fillColor, contentPadding}) {
    return InputDecoration(
        focusColor: ColorConstants.primaryColor,
        suffixIcon: icon == null ? null : icon,
        prefix: prefixIcon == null ? null : prefixIcon,
        hintText: fieldName,
        hintStyle:
            regular(size ?? DimensionsConstants.d20.sp, ColorConstants.colorBlack),
        filled: true,
        isDense: true,
        errorMaxLines: 3,
        contentPadding: contentPadding ?? EdgeInsets.symmetric(
            horizontal: DimensionsConstants.d10.w, vertical: 15.h),
        fillColor: fillColor ?? ColorConstants.colorWhite,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.transparent, width: DimensionsConstants.d2.h),
            borderRadius:
                BorderRadius.all(Radius.circular(DimensionsConstants.d10.w))),
        disabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(DimensionsConstants.d10.w))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.transparent, width: DimensionsConstants.d2.h),
            borderRadius:
                BorderRadius.all(Radius.circular(DimensionsConstants.d10.w))),
        errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(DimensionsConstants.d10.w))),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(DimensionsConstants.d10.w))));
  }

  static TextStyle regular(double size, Color color, {align}) {
    return TextStyle(
        color: color,
        fontFamily: StringConstants.poppins,
        fontWeight: FontWeight.w400,
        fontSize: size);
  }

  static TextStyle semiBold(double size, Color color) {
    return TextStyle(
        color: color,
        fontFamily: StringConstants.poppins,
        fontWeight: FontWeight.w600,
        fontSize: size);
  }
}
