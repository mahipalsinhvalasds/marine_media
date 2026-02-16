import 'dart:convert';

import 'package:marine_media_enterprises/screens/term_condition/term_condition_model.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';


class TermConditionApi {
  final ApiService apiClient;

  TermConditionApi({required this.apiClient});

  Future<TermConditionModel> getTermCondition(url) async {
    var response = await apiClient.get(url);
    return TermConditionModel.fromJson(json.decode(response.body));
  }
}
