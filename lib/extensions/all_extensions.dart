// ignore: file_names
import 'package:ai_score/constants/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension ExtendText on Text {
  regularText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow}) {
    return Text(
      data!,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignment,
      style: TextStyle(
          height: 1.4,
          color: color,
          wordSpacing: -1,
          fontFamily: StringConstants.poppins,
          fontWeight: FontWeight.w400,
          fontSize: textSize),
    );
  }

  lightText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow, letterSpacing}) {
    return Text(
      data!,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignment,
      style: TextStyle(
          letterSpacing: letterSpacing,
          color: color,
          fontFamily: StringConstants.poppins,
          fontWeight: FontWeight.w300,
          fontSize: textSize),
    );
  }

  mediumText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow}) {
    return Text(
      data!,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignment,
      style: TextStyle(
          color: color,
          fontFamily: StringConstants.poppins,
          fontWeight: FontWeight.w500,
          fontSize: textSize),
    );
  }

  semiBoldText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow}) {
    return Text(
      data!,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignment,
      style: TextStyle(
          color: color,
          fontFamily: StringConstants.poppins,
          fontWeight: FontWeight.w600,
          fontSize: textSize),
    );
  }
  boldText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow}) {
    return Text(
      data!,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignment,
      style: TextStyle(
          color: color,
          fontFamily: StringConstants.poppins,
          fontWeight: FontWeight.w700,
          fontSize: textSize),
    );
  }

}
