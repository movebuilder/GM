import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget imageUtils(String imageName,
    {double? width, double? height, BoxFit fit = BoxFit.fill, Color? color}) {
  assert(imageName.contains('.'), 'imageName must be end with .png or .svg');
  if (imageName.contains('.svg')) {
    String name = 'assets/svgs/$imageName';
    return SvgPicture.asset(
      name,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }
  String name = 'assets/images/$imageName';
  return Image.asset(
    name,
    width: width,
    height: height,
    fit: fit,
    color: color,
  );
}

Widget imageNetworkUtils(String? imageUrl,
    {Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    String placeholder = 'placeholder.png',
    Color? color,
    ImageWidgetBuilder? imageBuilder,
    Duration? fadeOutDuration,
    Duration? fadeInDuration}) {
  Widget placeholderWidget =
      imageUtils(placeholder, width: width, height: height, fit: fit);

  if (imageUrl == null || imageUrl.isEmpty) {
    return placeholderWidget;
  }

  if (Uri.parse(imageUrl).host.isEmpty) {
    return placeholderWidget;
  }

  if (imageUrl.toLowerCase().contains('.svg')) {
    return SvgPicture.network(imageUrl,
        key: key,
        width: width,
        height: height,
        fit: fit,
        color: color,
        placeholderBuilder: (context) => placeholderWidget);
  }

  return CachedNetworkImage(
    imageUrl: imageUrl,
    key: key,
    placeholder: (context, url) => placeholderWidget,
    width: width,
    height: height,
    fadeInDuration: fadeInDuration ?? Duration(milliseconds: 250),
    fadeOutDuration: fadeOutDuration ?? Duration(milliseconds: 1000),
    fit: fit,
    color: color,
    imageBuilder: imageBuilder,
    errorWidget: (
      context,
      url,
      error,
    ) {
      return placeholderWidget;
    },
  );
}
