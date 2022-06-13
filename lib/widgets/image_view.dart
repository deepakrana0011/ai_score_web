import 'dart:io';
import 'package:ai_score/constants/color_constants.dart';
import 'package:ai_score/constants/image_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageView extends StatelessWidget {
  final String? path;
  final double? width;
  final double? height;
  final File? file;
  final bool? circleCrop;
  final BoxFit? fit;
  final Color? color;
  final Color? color2;
  final double? radius;

  const ImageView(
      {Key? key,
      this.path,
      this.width,
      this.height,
      this.file,
      this.circleCrop = false,
      this.fit,
      this.radius = 20.0,
      this.color,
      this.color2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (path == null) {
      imageWidget = Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[color!, color2!],
            ),
          ));
    } else if (path == "") {
      imageWidget = Image.asset(
        ImageConstants.icLoginLogo,
        // TODO: Remove this splash image with error image
        width: width,
        height: height,
        color: ColorConstants.colorBlack,
        fit: BoxFit.contain,
      );
    } else if (path?.startsWith('http') ?? false) {
      imageWidget = CachedNetworkImage(
        fit: fit,
        height: height,
        width: width,
        imageUrl: path!,
        placeholder: (context, url) => Container(
            width: width, height: height, color: ColorConstants.colorBlack),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } else if (path?.startsWith('assets/images/') ?? false) {
      imageWidget = path!.contains(".svg")
          ? SvgPicture.asset(
              path!,
              width: width,
              height: height,
              color: color,
            )
          : Image.asset(
              path!,
              width: width,
              height: height,
              fit: fit,
              color: color,
            );
    } else if (file != null) {
      imageWidget = Image.file(
        file!,
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      imageWidget = Image.file(
        File(path!),
        width: width,
        height: height,
        fit: fit,
      );
    }
    return circleCrop!
        ? CircleAvatar(radius: radius, child: ClipOval(child: imageWidget))
        : imageWidget;
  }
}
