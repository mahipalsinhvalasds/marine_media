import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/database/app_preferences.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/home/home_screen.dart';
import 'package:marine_media_enterprises/screens/signup_screen.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/app_strings/app_strings.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? userLogin = "false";
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await getUser();
    nextScreen();
  }

  Future<void> getUser() async {
    AppPreferences appPreferences = AppPreferences();
    userLogin = await appPreferences.getUserLogin();
    final token = appPreferences.getAccessToken();
    // print("Access Token: $token");
  }

  void nextScreen() async {
    await Future.delayed(const Duration(seconds: 1));
    if (userLogin == "true") {
      Navigation.removeAllPreviousAndPush(context, HomeScreen());
    } else {
      Navigation.removeAllPreviousAndPush(context, SignupScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Image.asset(
            LocalImages.splash,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
