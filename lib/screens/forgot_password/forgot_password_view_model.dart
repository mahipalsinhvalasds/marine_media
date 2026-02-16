import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/add_to_training/common_model.dart';
import 'package:marine_media_enterprises/screens/forgot_password/forgot_password_api.dart';
import 'package:marine_media_enterprises/screens/forgot_password/otp_verification_screen.dart';
import 'package:marine_media_enterprises/screens/forgot_password/reset_password_screen.dart';
import 'package:marine_media_enterprises/screens/login/login_screen.dart';
import 'package:marine_media_enterprises/service/api_service/api_paramater.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';
import 'package:marine_media_enterprises/service/api_service/api_url.dart';
import 'package:marine_media_enterprises/utils/common_methods/common_methods.dart';

class ForgotPasswordViewModel with ChangeNotifier {
  BuildContext? context;

  ForgotPasswordApi? api;

  bool loading = false;

  CommonModel? commonModel;

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void init(BuildContext context) {
    this.context = context;
    api = ForgotPasswordApi(apiClient: ApiService());
  }

  Future<bool> onForgotPassword(String email) async {
    setLoading(true);
    try {
      final body = {ApiParameters.email: email};
      CommonModel response = await api!.forgotPassword(
        ApiUrl.forgotPassword,
        body,
      );

      if (response.status == true) {
        Navigation.pushReplacement(context!, OtpVerificationScreen(email: email));
        CommonMethods.showCustomSnackBar(
          context: context!,
          text: response.message ?? "Otp Send Successful",
        );
        return true;
      } else {
        CommonMethods.showCustomSnackBar(
          context: context!,
          text: response.message ?? "Failed to send otp",
        );
        return false;
      }
    } on SocketException {
      CommonMethods.showCustomSnackBar(
        context: context!,
        text: "No Internet connection. Please check your Wi-Fi or mobile data.",
      );
      return false;
    } on TimeoutException {
      CommonMethods.showCustomSnackBar(
          context: context!,
          text:  "Connection timed out. Try again later."
      );
      return false;
    } on FormatException {
      CommonMethods.showCustomSnackBar(
        context: context!,
        text: "Bad response format from server.",
      );
      return false;
    } catch (e) {
      print(e);
      CommonMethods.showCustomSnackBar(
        context: context!,
        text: "error : ${e.toString()}",
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> onResendEmail(String email) async {
    setLoading(true);
    try {
      final body = {ApiParameters.email: email};
      CommonModel response = await api!.forgotPassword(
        ApiUrl.resendEmail,
        body,
      );

      if (response.status == true) {
        CommonMethods.showCustomSnackBar(
          context: context!,
          text: response.message ?? "Otp Send Successful",
        );
        return true;
      } else {
        CommonMethods.showCustomSnackBar(
          context: context!,
          text: response.message ?? "Failed to send otp",
        );
        return false;
      }
    } on SocketException {
      CommonMethods.showCustomSnackBar(
        context: context!,
        text: "No Internet connection. Please check your Wi-Fi or mobile data.",
      );
      return false;
    } on TimeoutException {
      CommonMethods.showCustomSnackBar(
          context: context!,
          text:  "Connection timed out. Try again later."
      );
      return false;
    } on FormatException {
      CommonMethods.showCustomSnackBar(
        context: context!,
        text: "Bad response format from server.",
      );
      return false;
    } catch (e) {
      print(e);
      CommonMethods.showCustomSnackBar(
        context: context!,
        text: "error : ${e.toString()}",
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> onOtpVerification(String email, String otp) async {
    setLoading(true);
    try {
      final body = {ApiParameters.email: email, ApiParameters.otp: otp};
      CommonModel response = await api!.forgotPassword(
        ApiUrl.forgotPasswordOtp,
        body,
      );

      if (response.status == true) {
        commonModel = response;
        Navigation.pushReplacement(context!, ResetPasswordScreen());
        CommonMethods.showCustomSnackBar(
          context: context!,
          text: response.message ?? "Otp Verify Successful",
        );
        notifyListeners();
        return true;
      } else {
        CommonMethods.showCustomSnackBar(
          context: context!,
          text: response.message ?? "Failed to Verify otp",
        );
        return false;
      }
    } on SocketException {
      CommonMethods.showCustomSnackBar(
        context: context!,
        text: "No Internet connection. Please check your Wi-Fi or mobile data.",
      );
      return false;
    } on TimeoutException {
      CommonMethods.showCustomSnackBar(
          context: context!,
          text:  "Connection timed out. Try again later."
      );
      return false;
    } on FormatException {
      CommonMethods.showCustomSnackBar(
        context: context!,
        text: "Bad response format from server.",
      );
      return false;
    } catch (e) {
      print(e);
      CommonMethods.showCustomSnackBar(
        context: context!,
        text: "error : ${e.toString()}",
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> onResetPassword(
    String token,
    String password,
    String confirmPassword,
  ) async {
    setLoading(true);
    try {
      final body = {
        ApiParameters.verifyToken: token,
        ApiParameters.password: password,
        ApiParameters.confirmNewPassword: confirmPassword,
      };
      CommonModel response = await api!.forgotPassword(
        ApiUrl.createNewPassword,
        body,
      );

      if (response.status == true) {
        Navigation.removeAllPreviousAndPush(context!, LoginScreen());
        CommonMethods.showCustomSnackBar(
          context: context!,
          text: response.message ?? "Reset Password Successful",
        );
        return true;
      } else {
        CommonMethods.showCustomSnackBar(
          context: context!,
          text: response.message ?? "Failed to Reset Password",
        );
        return false;
      }
    } on SocketException {
      CommonMethods.showCustomSnackBar(
        context: context!,
        text: "No Internet connection. Please check your Wi-Fi or mobile data.",
      );
      return false;
    } on TimeoutException {
      CommonMethods.showCustomSnackBar(
          context: context!,
          text:  "Connection timed out. Try again later."
      );
      return false;
    } on FormatException {
      CommonMethods.showCustomSnackBar(
        context: context!,
        text: "Bad response format from server.",
      );
      return false;
    } catch (e) {
      print(e);
      CommonMethods.showCustomSnackBar(
        context: context!,
        text: "error : ${e.toString()}",
      );
      return false;
    } finally {
      setLoading(false);
    }
  }
}
