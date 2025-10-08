import 'dart:convert';

import 'package:marine_media_enterprises/screens/my_training/my_training_model.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';


class MyTrainingApi{
  final ApiService apiClient;

  MyTrainingApi({required this.apiClient});

  Future<MyTrainingModel> getMyTraining(url) async {
    var response = await apiClient.get(url);
    return MyTrainingModel.fromJson(json.decode(response.body));
  }
}
