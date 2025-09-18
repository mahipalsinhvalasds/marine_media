import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/home_screen.dart';
import 'package:marine_media_enterprises/screens/reset_password_screen.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:marine_media_enterprises/widget/custom_button.dart';
import 'package:marine_media_enterprises/widget/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
                      onTap: (){
                        Navigation.pop(context);
                      },
                      child: Icon(Icons.clear, size: 30, color: Colors.white),
                    ),
                  ),
                  Image.asset(LocalImages.logo),
                  SizedBox(height: 70),
                  Center(
                    child: Text(
                      "FORGOT PASSWORD",
                      style: CommonStyle.getRalewayFont(
                        fontSize: size.width * 0.06,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextfield(hintText: "Enter your email"),
                  SizedBox(height: 32),
                  CustomButton(
                    text: "Forgot Password",
                    onTap: () {
                      Navigation.push(context, ResetPasswordScreen());
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Didn’t get it? ",
                        style: CommonStyle.getRalewayFont(fontSize: 16),
                        children: [
                          TextSpan(
                            text: "Resend email",
                            style: CommonStyle.getRalewayFont(fontWeight: FontWeight.w700,fontSize: 16),
                          ),
                        ],
                      ),
                    ),
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
