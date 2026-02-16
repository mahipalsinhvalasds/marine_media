import 'package:flutter/cupertino.dart';
import 'package:marine_media_enterprises/core/database/app_preferences.dart';
import 'package:marine_media_enterprises/screens/term_condition/term_condition_api.dart';
import 'package:marine_media_enterprises/screens/term_condition/term_condition_model.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';
import 'package:marine_media_enterprises/service/api_service/api_url.dart';

class TermConditionViewModel with ChangeNotifier {
  BuildContext? context;

  TermConditionApi? api;

  bool loading = false;

  AppPreferences appPreferences = AppPreferences();

  TermConditionModel? termConditionModel;

  Future<void> init(BuildContext context) async {
    this.context = context;
    api = TermConditionApi(apiClient: ApiService());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await geTermCondition();
    });

  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<void> geTermCondition() async {
    setLoading(true);
    try {
      TermConditionModel response = await api!.getTermCondition(ApiUrl.termConditions);

      if (response.status == true) {
        termConditionModel = response;
        notifyListeners();
      } else {}
    } catch (e) {
      print('Error fetching details: $e');
    } finally {
      setLoading(false);
    }
  }
}
