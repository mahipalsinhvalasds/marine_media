class QuizQuestionModel {
  bool? status;
  String? quiz;
  String? result;
  List<Video>? video;

  QuizQuestionModel({this.status, this.quiz, this.result, this.video});

  QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    quiz = json['Quiz'];
    result = json['result'];
    if (json['video'] != null) {
      video = <Video>[];
      json['video'].forEach((v) {
        video!.add(new Video.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
   data['Quiz'] = this.quiz;
   data['result'] = this.result;
    if (this.video != null) {
      data['video'] = this.video!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Video {
  int? id;
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? option5;
  String? answer;

  Video(
      {this.id,
        this.question,
        this.option1,
        this.option2,
        this.option3,
        this.option4,
        this.option5,
        this.answer});

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    option1 = json['option_1'];
    option2 = json['option_2'];
    option3 = json['option_3'];
    option4 = json['option_4'];
    option5 = json['option_5'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['option_1'] = this.option1;
    data['option_2'] = this.option2;
    data['option_3'] = this.option3;
    data['option_4'] = this.option4;
    data['option_5'] = this.option5;
    data['answer'] = this.answer;
    return data;
  }

  List<String> get options {
    List<String> optionsList = [];
    if (option1 != null && option1!.isNotEmpty) optionsList.add(option1!);
    if (option2 != null && option2!.isNotEmpty) optionsList.add(option2!);
    if (option3 != null && option3!.isNotEmpty) optionsList.add(option3!);
    if (option4 != null && option4!.isNotEmpty) optionsList.add(option4!);
    if (option5 != null && option5!.isNotEmpty) optionsList.add(option5!);
    return optionsList;
  }

  int get correctAnswerIndex {
    int answerNumber = int.tryParse(answer ?? '1') ?? 1;
    return answerNumber - 1;
  }
}
