import 'dart:convert';

import 'package:marine_media_enterprises/screens/add_to_training/model.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';



class AddTrainingApi{
  final ApiService? apiClient;

  AddTrainingApi({required this.apiClient});

  Future<Model> addTraining(url , Map<String , dynamic> body)async{
    var response = await apiClient?.post(url, body);
    return Model.fromJson(jsonDecode(response!.body));
  }
}