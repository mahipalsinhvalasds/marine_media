import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/forgot_password/forgot_password_view_model.dart';
import 'package:marine_media_enterprises/screens/forgot_password/otp_verification_screen.dart';
import 'package:marine_media_enterprises/screens/forgot_password/reset_password_screen.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/common_methods/common_methods.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:marine_media_enterprises/utils/validation.dart';
import 'package:marine_media_enterprises/widget/custom_button.dart';
import 'package:marine_media_enterprises/widget/custom_textfield.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isValidationActivated = false;

  ForgotPasswordViewModel? mViewModel;

  @override
  void initState() {
    super.initState();
    mViewModel = Provider.of<ForgotPasswordViewModel>(context, listen: false);
    mViewModel?.init(context);
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<ForgotPasswordViewModel>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Image.asset(
            LocalImages.splashBackgroundGif,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: AppColors.backgroundColor.withOpacity(0.65),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration:  BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundColor.withOpacity(0.0),
                    AppColors.backgroundColor,
                    AppColors.backgroundColor,
                  ],
                ),
              ),
            ),
          ),
          Form(
            key: formKey,
            child: Padding(
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
                    Center(
                      child: Text(
                        "Forgot Password",
                        style: CommonStyle.getRalewayFont(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextfield(
                      textController: emailController,
                      hintText: "Enter your email",
                      validation: (value) =>
                          CustomValidations.emailValidator(value),
                      onChanged: (value) {
                        if (isValidationActivated) {
                          formKey.currentState!.validate();
                        }
                      },
                    ),
                    SizedBox(height: 32),
                    CustomButton(
                      text: "Forgot Password",
                      loading: mViewModel?.loading ?? false,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          mViewModel?.onForgotPassword(
                            emailController.text.trim(),
                          );
                        } else {
                          // Navigation.push(
                          //   context,
                          //   OtpVerificationScreen(
                          //     email: emailController.text.trim(),
                          //   ),
                          // );
                          setState(() {
                            isValidationActivated = true;
                          });
                        }
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
                              style: CommonStyle.getRalewayFont(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  if (emailController.text.isEmpty) {
                                    CommonMethods.showCustomSnackBar(
                                      context: context,
                                      text: "Please enter your email",
                                    );
                                  } else if (CustomValidations.emailValidator(
                                        emailController.text,
                                      ) !=
                                      null) {
                                    CommonMethods.showCustomSnackBar(
                                      context: context,
                                      text: "Please enter valid email",
                                    );
                                  } else {
                                    mViewModel?.onResendEmail(
                                      emailController.text.trim(),
                                    );
                                  }
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
