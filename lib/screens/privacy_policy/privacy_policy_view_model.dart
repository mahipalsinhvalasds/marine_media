import 'package:flutter/cupertino.dart';
import 'package:marine_media_enterprises/core/database/app_preferences.dart';
import 'package:marine_media_enterprises/screens/privacy_policy/privacy_policy_api.dart';
import 'package:marine_media_enterprises/screens/privacy_policy/privacy_policy_model.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';
import 'package:marine_media_enterprises/service/api_service/api_url.dart';

class PrivacyPolicyViewModel with ChangeNotifier {
  BuildContext? context;

  PrivacyPolicyApi? api;

  bool loading = false;

  AppPreferences appPreferences = AppPreferences();

  PrivacyPolicyModel? privacyPolicyModel;

  Future<void> init(BuildContext context) async {
    this.context = context;
    api = PrivacyPolicyApi(apiClient: ApiService());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getPrivacyPolicy();
    });

  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<void> getPrivacyPolicy() async {
    setLoading(true);
    try {
      PrivacyPolicyModel response = await api!.getPrivacyPolicy(ApiUrl.privacyPolicy);

      if (response.status == true) {
        privacyPolicyModel = response;
        notifyListeners();
      } else {}
    } catch (e) {
      print('Error fetching details: $e');
    } finally {
      setLoading(false);
    }
  }
}
