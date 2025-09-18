import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/forgot_password_screen.dart';
import 'package:marine_media_enterprises/screens/home_screen.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:marine_media_enterprises/widget/custom_button.dart';
import 'package:marine_media_enterprises/widget/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = false;
  bool isRemember = false;
  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: 40),
                  Image.asset(LocalImages.logo),
                  SizedBox(height: 70),
                  Center(
                    child: Text(
                      "SIGN IN",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextfield(hintText: "Enter your email"),
                  CustomTextfield(
                    hintText: "Password",
                    suffixWidget: GestureDetector(
                      onTap: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      child: showPassword
                          ? Icon(
                              Icons.visibility_off_outlined,
                              color: Colors.grey,
                            )
                          : Icon(Icons.visibility_outlined, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigation.push(context, ForgotPasswordScreen());
                    },
                    child: Text(
                      "Forgot Your Password?",
                      style: CommonStyle.getRalewayFont(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: isRemember,
                          onChanged: (value) {
                            setState(() {
                              isRemember = !isRemember;
                            });
                          },
                          checkColor: Colors.white,
                          activeColor: Colors.blue,
                          fillColor: WidgetStatePropertyAll(
                            isRemember ? Colors.blue : Colors.white,
                          ),
                          side: BorderSide(color: Colors.black45, width: 2),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Remember Me",
                        style: CommonStyle.getRalewayFont(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                  CustomButton(
                    text: "Login",
                    onTap: () {
                      Navigation.push(context, HomeScreen());
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
