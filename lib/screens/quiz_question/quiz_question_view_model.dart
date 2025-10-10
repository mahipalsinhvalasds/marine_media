import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marine_media_enterprises/screens/quiz_question/quiz_question_api.dart';
import 'package:marine_media_enterprises/screens/quiz_question/quiz_question_model.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';
import 'package:marine_media_enterprises/service/api_service/api_url.dart';

class QuizQuestionViewModel with ChangeNotifier {
  BuildContext? context;

  QuizQuestionApi? api;

  bool loading = false;

  List<Video>? video;

  QuizQuestionModel? quizQuestionModel;

  Future<void> init(BuildContext context, int videoId) async {
    this.context = context;
    api = QuizQuestionApi(apiClient: ApiService());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getQuizQuestionList(videoId);
    });
  }

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Future<void> getQuizQuestionList(int videoId) async {
    setLoading(true);
    try {
      QuizQuestionModel response = await api!.getQuizQuestion(
        "${ApiUrl.questionList}?id=$videoId",
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

  Future<bool> onSubmit(int videoId, Map<int, int> selectedAnswers) async {
    setLoading(true);
    try {
      List<Map<String, dynamic>> ansArray = [];
      
      selectedAnswers.forEach((questionIndex, selectedAnswerIndex) {
        if (video != null && questionIndex < video!.length) {
          final question = video![questionIndex];
          ansArray.add({
            "id": question.id,
            "selected_answer": (selectedAnswerIndex + 1).toString(),
            "answer": question.answer ?? "",
          });
        }
      });
      final body = [
        {
          "video_id": videoId,
          "ans": ansArray,
        }
      ];
      QuizQuestionModel response = await api!.submitQuiz(ApiUrl.submitQuiz, body);

      if (response.status == true) {
        Fluttertoast.showToast(msg: "Quiz submitted successfully!");
        quizQuestionModel = response;
        notifyListeners();
        return true;
      } else {
        Fluttertoast.showToast(msg: "Failed to submit quiz");
        return false;
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
      return false;
    } finally {
      setLoading(false);
    }
  }
}
