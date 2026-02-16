import 'dart:convert';

import 'package:marine_media_enterprises/screens/add_to_training/common_model.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';

class ForgotPasswordApi {
  final ApiService? apiClient;

  ForgotPasswordApi({required this.apiClient});

  Future<CommonModel> forgotPassword(url, Map<String, dynamic> body) async {
    var response = await apiClient?.post(url, body);
    return CommonModel.fromJson(jsonDecode(response!.body));
  }

  Future<CommonModel> resendEmail(url, Map<String, dynamic> body) async {
    var response = await apiClient?.post(url, body);
    return CommonModel.fromJson(jsonDecode(response!.body));
  }

  Future<CommonModel> otpVerification(url, Map<String, dynamic> body) async {
    var response = await apiClient?.post(url, body);
    return CommonModel.fromJson(jsonDecode(response!.body));
  }

  Future<CommonModel> resetPassword(url, Map<String, dynamic> body) async {
    var response = await apiClient?.post(url, body);
    return CommonModel.fromJson(jsonDecode(response!.body));
  }
}
