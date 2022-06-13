import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomShape extends StatelessWidget {
  Widget? child;
  Color? strokeColor;
  Color? gradientColor1;
  Color? gradientColor2;
  bool isLinearGradient;
  double? width;
  double? height;
  BorderRadiusGeometry? radius;
  bool isChildCenter;

  CustomShape(
      {@required this.child,
      @required this.radius,
      @required this.gradientColor1,
      @required this.gradientColor2,
      this.isLinearGradient=true,
      this.isChildCenter=true,
      this.width,
      this.height,
      this.strokeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: isChildCenter?Center(child: child):child,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: isLinearGradient?Alignment.topCenter:Alignment.topLeft,
            end: isLinearGradient?Alignment.bottomCenter:Alignment.topRight,
            colors: <Color>[gradientColor1!, gradientColor2!],
          ),
          border: strokeColor!=null?Border.all(color: strokeColor!):null,
          borderRadius: radius!),
    );
  }
}
