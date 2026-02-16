import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';

class CommonMethods{

  static void showCustomSnackBar({
    required BuildContext context,
    String? text,
    bool isError = false,
  }) {
    Flushbar(
      margin: EdgeInsets.symmetric(horizontal: 10),
      titleColor: Colors.red,
      message: text,
      messageSize: 16,
      flushbarPosition: FlushbarPosition.TOP,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.fastLinearToSlowEaseIn,
      boxShadows: [
        BoxShadow(
            color: Colors.blue.shade400,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0)
      ],
      backgroundGradient:
      LinearGradient(colors: [AppColors.green, AppColors.green]),
      duration: Duration(seconds: 4),
      // icon: Icon(
      //   isError
      //       ? Icons.report_rounded
      //       : Icons.done,
      //   color: isError ? Colors.red : Colors.green,
      // ),
    )..show(context);
  }
}