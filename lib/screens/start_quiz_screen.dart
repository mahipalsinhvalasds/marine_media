import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/quiz_question/quiz_question_screen.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:marine_media_enterprises/widget/custom_button.dart';

class StartQuizScreen extends StatefulWidget {
  final String videoTitle;
  final int videoId;
  const StartQuizScreen({
    super.key,
    required this.videoTitle,
    required this.videoId,
  });

  @override
  State<StartQuizScreen> createState() => _StartQuizScreenState();
}

class _StartQuizScreenState extends State<StartQuizScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            LocalImages.backgroundImageBlue,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 36),
                  GestureDetector(
                    onTap: () {
                      Navigation.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Center(child: Image.asset(LocalImages.logo, scale: 4)),
                  SizedBox(height: 30),
                  Text(
                    widget.videoTitle ?? "",
                    style: CommonStyle.getRalewayFont(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        "Quiz",
                        style: CommonStyle.getRalewayFont(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Total Questions: 5",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomButton(text: "Start Quiz", onTap: () {
                    Navigation.push(context, QuizQuestionScreen(videoId: widget.videoId,));
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
