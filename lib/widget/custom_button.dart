import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';

import '../utils/app_colors/app_colors.dart' show AppColors;

class CustomButton extends StatelessWidget {
  final String? text;
  final Color? backgroundColor;
  final double width;
  final double height;
  final Border? border;
  final GestureTapCallback? onTap;
  final Color? colour;
  final EdgeInsets? margin;
  final bool? loading;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;

  final Widget? icon;
  final double? iconSize;

  const CustomButton({
    super.key,
    required this.text,
    this.backgroundColor,
    this.width = double.infinity,
    this.height = 50,
    this.border,
    this.onTap,
    this.colour,
    this.margin,
    this.loading,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,

    this.icon,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null && loading != true) {
          onTap!();
        }
      },
      child: Container(
        margin: margin,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 25),
          color: backgroundColor ?? Colors.transparent,
          border: border ?? Border.all(color: Colors.white),
        ),
        child: loading == true
            ? const Center(
                child: SizedBox(
                  width: 26,
                  height: 26,
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              )
            : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      SizedBox(
                        width: iconSize ?? 24,
                        height: iconSize ?? 24,
                        child: icon,
                      ),
                      const SizedBox(width: 7),
                    ],
                    Text(
                      text ?? '',
                      style: CommonStyle.getRalewayFont(
                        fontSize: fontSize ?? 18,
                        fontWeight: fontWeight ?? FontWeight.w500,
                        color: colour ?? Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
