import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marine_media_enterprises/core/database/app_preferences.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/add_to_training/add_training_api.dart';
import 'package:marine_media_enterprises/screens/add_to_training/common_model.dart';
import 'package:marine_media_enterprises/screens/home/home_screen.dart';
import 'package:marine_media_enterprises/service/api_service/api_paramater.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';
import 'package:marine_media_enterprises/service/api_service/api_url.dart';
import 'package:marine_media_enterprises/utils/common_methods/common_methods.dart';


class AddTrainingApiViewModel with ChangeNotifier {
  BuildContext? context;

  AddTrainingApi? api;

  bool loading = false;

  AppPreferences appPreferences = AppPreferences();

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void init(BuildContext context) {
    this.context = context;
    api = AddTrainingApi(apiClient: ApiService());
  }

  Future<bool> onAddTrainingTap(int categoryId, int videoId) async {
    setLoading(true);
    try {
      final body = {
        ApiParameters.categoryId: categoryId,
        ApiParameters.videoId: videoId,
      };
      CommonModel response = await api!.addTraining(ApiUrl.addTraining, body);

      if (response.status == true) {
        Navigation.removeAllPreviousAndPush(context!, HomeScreen());
        CommonMethods.showCustomSnackBar(
          context: context!,
          text: response.message ?? "video added successfully",
        );
        return true;
      } else {
        CommonMethods.showCustomSnackBar(
          context: context!,
          text: response.message  ?? "Failed to add video",
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
        text: "Connection timed out. Try again later.",
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
