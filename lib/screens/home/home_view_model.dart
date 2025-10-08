import 'package:flutter/cupertino.dart';
import 'package:marine_media_enterprises/core/database/app_preferences.dart';
import 'package:marine_media_enterprises/screens/home/home_api.dart';
import 'package:marine_media_enterprises/screens/home/training_model.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';
import 'package:marine_media_enterprises/service/api_service/api_url.dart';

class HomeViewModel with ChangeNotifier {
  BuildContext? context;

  HomeApi? api;

  bool loading = false;

  AppPreferences appPreferences = AppPreferences();

  List<Video>? video;

  Future<void> init(BuildContext context) async {
    this.context = context;
    api = HomeApi(apiClient: ApiService());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getTrainingDetails();
    });

  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<void> getTrainingDetails() async {
    setLoading(true);
    try {
      TrainingModel response = await api!.getTraining(ApiUrl.getTraining);

      if (response.status == true) {
        video = response.video;
      } else {}
    } catch (e) {
      print('Error fetching user details: $e');
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }
}
