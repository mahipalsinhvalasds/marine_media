import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marine_media_enterprises/core/database/app_preferences.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/home/home_screen.dart';
import 'package:marine_media_enterprises/screens/login/login_api.dart';
import 'package:marine_media_enterprises/screens/login/user_model.dart';
import 'package:marine_media_enterprises/service/api_service/api_paramater.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';
import 'package:marine_media_enterprises/service/api_service/api_url.dart';


class LoginViewModel with ChangeNotifier {
  BuildContext? context;

  LoginApi? api;

  bool loading = false;

  AppPreferences appPreferences = AppPreferences();

  User? user;

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void init(BuildContext context) {
    this.context = context;
    api = LoginApi(apiClient: ApiService());
  }

  Future<bool> onLoginTap(String email, String password, String? keptLogin) async {
    setLoading(true);
    try {
      final body = {
        ApiParameters.email: email,
        ApiParameters.password: password,
      };
      UserModel response = await api!.login(ApiUrl.login, body);

      if (response.status == "success" && response.user?.first.email != null) {
        await appPreferences
            .setUserDetails(jsonEncode(response.user?.first.toJson()));
        await appPreferences
            .setUserLogin(keptLogin ?? "false");
        await appPreferences.getUserDetails();
        if (response.token != null) {
          await appPreferences.setAccessToken(response.token!);
        }
        user = await appPreferences.getUserDetails();
        String? accessToken = await appPreferences.getAccessToken();
        print("Access Token: $accessToken");
        Navigation.removeAllPreviousAndPush(context!, HomeScreen());

        Fluttertoast.showToast(msg: response.message ?? "Login Successful");
        return true;
      } else {
        Fluttertoast.showToast(msg: response.message  ??  response.errors?.email?.first ?? "Login Failed");
        return false;
      }
    } on SocketException {
      Fluttertoast.showToast(
          msg:
          "No Internet connection. Please check your Wi-Fi or mobile data.");
      return false;
    } on TimeoutException {
      Fluttertoast.showToast(msg: "Connection timed out. Try again later.");
      return false;
    } on FormatException {
      Fluttertoast.showToast(msg: "Bad response format from server.");
      return false;
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "error : ${e.toString()}");
      return false;
    } finally {
      setLoading(false);
    }
  }
}
