import 'dart:convert';

import 'package:marine_media_enterprises/screens/home/training_model.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';


class HomeApi {
  final ApiService apiClient;

  HomeApi({required this.apiClient});

  Future<TrainingModel> getTraining(url) async {
    var response = await apiClient.get(url);
    return TrainingModel.fromJson(json.decode(response.body));
  }
}
