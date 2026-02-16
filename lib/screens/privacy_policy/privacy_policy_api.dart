import 'dart:convert';

import 'package:marine_media_enterprises/screens/privacy_policy/privacy_policy_model.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';


class PrivacyPolicyApi {
  final ApiService apiClient;

  PrivacyPolicyApi({required this.apiClient});

  Future<PrivacyPolicyModel> getPrivacyPolicy(url) async {
    var response = await apiClient.get(url);
    return PrivacyPolicyModel.fromJson(json.decode(response.body));
  }
}
