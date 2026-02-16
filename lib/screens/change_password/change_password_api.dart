import 'dart:convert';

import 'package:marine_media_enterprises/screens/add_to_training/common_model.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';

class ChangePasswordApi{
  final ApiService? apiClient;

  ChangePasswordApi({required this.apiClient});

  Future<CommonModel> changePassword(url , Map<String , dynamic> body)async{
    var response = await apiClient?.post(url, body);
    return CommonModel.fromJson(jsonDecode(response!.body));
  }
}