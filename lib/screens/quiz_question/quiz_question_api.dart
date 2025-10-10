import 'dart:convert';
import 'package:marine_media_enterprises/screens/quiz_question/quiz_question_model.dart';
import 'package:marine_media_enterprises/service/api_service/api_service.dart';


class QuizQuestionApi{
  final ApiService? apiClient;

  QuizQuestionApi({required this.apiClient});

  Future<QuizQuestionModel> getQuizQuestion(url) async {
    var response = await apiClient?.get(url);
    return QuizQuestionModel.fromJson(json.decode(response!.body));
  }

  Future<QuizQuestionModel> submitQuiz(url , List<Map<String , dynamic> >body)async{
    var response = await apiClient?.post(url, body);
    return QuizQuestionModel.fromJson(jsonDecode(response!.body));
  }
}
