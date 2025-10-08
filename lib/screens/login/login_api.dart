import 'dart:convert';

import 'package:marine_media_enterprises/screens/login/user_model.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';



class LoginApi{
  final ApiService? apiClient;

  LoginApi({required this.apiClient});

  Future<UserModel> login(url , Map<String , dynamic> body)async{
    var response = await apiClient?.post(url, body);
    return UserModel.fromJson(jsonDecode(response!.body));
  }
}