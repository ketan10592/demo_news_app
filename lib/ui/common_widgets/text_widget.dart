import 'package:demo_news_app/infrastructure/common/utills/app_color.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String? text;
  final String? fontFamily;
  final double? fontSize;
  final TextAlign? align;
  final FontStyle? fontStyle;
  final Color? fontColor;
  final int? maxLine;
  final bool? softWrap;
  final FontWeight? fontWeight;
  final double? textHeight;

  const TextWidget(
      {Key? key,
        this.text,
        this.fontFamily,
        this.fontSize,
        this.align,
        this.fontStyle,
        this.fontColor,
        this.maxLine,
        this.softWrap, this.fontWeight, this.textHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      maxLines: maxLine ?? 1,
      softWrap: softWrap ?? false,
      style: TextStyle(
          color: fontColor ?? AppColors.black,
          fontFamily: fontFamily,
          fontStyle: fontStyle,
          fontWeight: fontWeight,
          height: textHeight,
          fontSize: fontSize),
      textAlign: align,
      overflow: TextOverflow.ellipsis,
    );
  }
}