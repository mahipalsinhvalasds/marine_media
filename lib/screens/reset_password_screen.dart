import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/login/login_screen.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:marine_media_enterprises/widget/custom_button.dart';
import 'package:marine_media_enterprises/widget/custom_textfield.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Image.asset(
            LocalImages.backgroundImage,
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
                  SizedBox(height: 50),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigation.pop(context);
                      },
                      child: Icon(Icons.clear, size: 30, color: Colors.white),
                    ),
                  ),
                  Image.asset(LocalImages.logo),
                  SizedBox(height: 70),
                  Text(
                    "RESET",
                    style: CommonStyle.getRalewayFont(
                      fontSize: size.width * 0.07,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Your Password",
                    style: CommonStyle.getRalewayFont(
                      fontSize: size.width * 0.07,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextfield(hintText: "Enter new password"),
                  CustomTextfield(hintText: "Confirm new password"),
                  SizedBox(height: 30),
                  CustomButton(
                    text: "Reset Password",
                    onTap: () {
                      Navigation.push(context, LoginScreen());
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
