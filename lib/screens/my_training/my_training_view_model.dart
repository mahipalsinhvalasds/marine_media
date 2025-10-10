import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marine_media_enterprises/screens/add_to_training/common_model.dart';
import 'package:marine_media_enterprises/screens/my_training/my_training_api.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';
import 'package:marine_media_enterprises/service/api_service/api_url.dart';

import 'my_training_model.dart';

class MyTrainingViewModel with ChangeNotifier {
  BuildContext? context;

  MyTrainingApi? api;

  bool loading = false;

  List<Video>? video;

  Future<void> init(BuildContext context) async {
    this.context = context;
    api = MyTrainingApi(apiClient: ApiService());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getTrainingDetails(0);
    });
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<void> getTrainingDetails(int status) async {
    setLoading(true);
    try {
      MyTrainingModel response = await api!.getMyTraining(
        "${ApiUrl.getMyTraining}?status=$status",
      );

      if (response.status == true) {
        video = response.video;
      } else {
        print("No data found");
      }
    } catch (e) {
      print('Error fetching user details: $e');
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> deleteMyTraining(int id) async {
    setLoading(true);
    try {
      CommonModel response = await api!.deleteMyTraining(
        "${ApiUrl.deleteMyTraining}?id=$id",
      );

      if (response.status == true) {
        getTrainingDetails(0);
        Fluttertoast.showToast(msg: response.message ?? "Deleted Successfully");
      } else {
        print("No data found");
        Fluttertoast.showToast(msg: response.message ?? "error on delete training");
      }
    } catch (e) {
      print('Error deleting training: $e');
      Fluttertoast.showToast(msg: "error: ${e.toString()}");
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }
}
