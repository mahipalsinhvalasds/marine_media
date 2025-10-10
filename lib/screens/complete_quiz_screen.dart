import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/home/home_screen.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:marine_media_enterprises/widget/custom_button.dart';

class CompleteQuizScreen extends StatefulWidget {
  final String? quiz;
  final String? result;
  const CompleteQuizScreen({super.key,required this.quiz, required this.result});

  @override
  State<CompleteQuizScreen> createState() => _CompleteQuizScreenState();
}

class _CompleteQuizScreenState extends State<CompleteQuizScreen> {
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
                  SizedBox(height: 150),
                  Center(
                    child: Text(
                      widget.quiz ?? "",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      widget.result ?? "",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 120),
                  CustomButton(
                    text: "Complete Training",
                    onTap: () {
                      Navigation.removeAllPreviousAndPush(
                        context,
                        HomeScreen(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
