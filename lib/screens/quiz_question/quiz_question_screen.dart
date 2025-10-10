import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/complete_quiz_screen.dart';
import 'package:marine_media_enterprises/screens/quiz_question/quiz_question_view_model.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:marine_media_enterprises/widget/custom_button.dart';
import 'package:provider/provider.dart';

class QuizQuestionScreen extends StatefulWidget {
  final int videoId;
  const QuizQuestionScreen({super.key, required this.videoId});

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  PageController _pageController = PageController();
  int currentPage = 0;
  Map<int, int> selectedAnswers = {};

  final List<Map<String, dynamic>> quizData = [
    {
      "question": "Q1. How many parts make up this programme series?",
      "answers": ["Two.", "Three.", "Four."],
    },
    {
      "question": "Q2. What is the main focus of marine conservation?",
      "answers": [
        "Ocean pollution",
        "Marine biodiversity",
        "Both A and B",
        "None of the above",
      ],
    },
    {
      "question": "Q3. Which marine animal is known as the largest mammal?",
      "answers": ["Dolphin", "Blue whale", "Shark", "Octopus"],
    },
    {
      "question":
          "Q4. What percentage of Earth's surface is covered by oceans?",
      "answers": ["50%", "60%", "71%", "80%"],
    },
    {
      "question": "Q5. Which zone of the ocean receives no sunlight?",
      "answers": [
        "Sunlight zone",
        "Twilight zone",
        "Midnight zone",
        "Abyssal zone",
      ],
    },
  ];

  void _nextPage() {
    if (!selectedAnswers.containsKey(currentPage)) {
      return;
    }

    if (currentPage < quizData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showResults();
    }
  }

  QuizQuestionViewModel? mViewModel;

  @override
  void initState() {
    super.initState();
    mViewModel = Provider.of<QuizQuestionViewModel>(context, listen: false);
    mViewModel?.init(context, widget.videoId);
    print("video data: ${mViewModel?.video}");
  }

  void _showResults() async {
    bool success = await mViewModel!.onSubmit(widget.videoId, selectedAnswers);

    if (success) {
      Navigation.pushReplacement(
        context,
        CompleteQuizScreen(
          quiz: mViewModel?.quizQuestionModel?.quiz ?? "",
          result: mViewModel?.quizQuestionModel?.result ?? "",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<QuizQuestionViewModel>(context);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 54),
                Center(child: Image.asset(LocalImages.logo, scale: 4)),
                SizedBox(height: 24),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemCount: quizData.length,
                    itemBuilder: (context, pageIndex) {
                      final videoItem = mViewModel?.video?[pageIndex];
                      if (videoItem == null) return SizedBox.shrink();

                      final question = videoItem.question ?? '';
                      final answers = videoItem.options;
                      final selectedAnswerIndex = selectedAnswers[pageIndex];
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Q${pageIndex + 1}. $question",
                              style: CommonStyle.getRalewayFont(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            ...List.generate(answers.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedAnswers[pageIndex] = index;
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color:
                                                  selectedAnswerIndex == index
                                                  ? AppColors.primaryColor
                                                  : Colors.grey.shade400,
                                              width: 2,
                                            ),
                                            color: selectedAnswerIndex == index
                                                ? AppColors.primaryColor
                                                : Colors.grey.shade400,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Text(
                                            answers[index],
                                            style: CommonStyle.getRalewayFont(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8),
                Opacity(
                  opacity: selectedAnswers.containsKey(currentPage) ? 1.0 : 0.5,
                  child: CustomButton(
                    text: "Next",
                    loading: mViewModel?.loading ?? false,
                    border: Border.all(
                      color: selectedAnswers.containsKey(currentPage)
                          ? Colors.white
                          : Colors.white.withOpacity(0.8),
                    ),
                    colour: selectedAnswers.containsKey(currentPage)
                        ? Colors.white
                        : Colors.white.withOpacity(0.8),
                    onTap: () {
                      _nextPage();
                    },
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
