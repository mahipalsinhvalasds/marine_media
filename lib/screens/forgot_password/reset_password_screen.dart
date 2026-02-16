import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/forgot_password/forgot_password_view_model.dart';
import 'package:marine_media_enterprises/screens/login/login_screen.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/common_methods/common_methods.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:marine_media_enterprises/utils/validation.dart';
import 'package:marine_media_enterprises/widget/custom_button.dart';
import 'package:marine_media_enterprises/widget/custom_textfield.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
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
            LocalImages.backgroundImage,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
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
                    Text(
                      "RESET",
                      style: CommonStyle.getRalewayFont(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
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
                    CustomTextfield(
                      textController: passwordController,
                      hintText: "Enter new password",
                      validation: (value) =>
                          CustomValidations.changePasswordValidator(value),
                      onChanged: (value) {
                        if (isValidationActivated) {
                          formKey.currentState!.validate();
                        }
                      },
                    ),
                    CustomTextfield(
                      textController: confirmPasswordController,
                      hintText: "Confirm new password",
                      validation: (value) =>
                          CustomValidations.nullValidator(value,customMessage: "Please enter confirm password"),
                      onChanged: (value) {
                        if (isValidationActivated) {
                          formKey.currentState!.validate();
                        }
                      },
                    ),
                    SizedBox(height: 30),
                    CustomButton(
                      text: "Reset Password",
                      loading: mViewModel?.loading ?? false,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          if (confirmPasswordController.text.trim() !=
                              passwordController.text.trim()) {
                            CommonMethods.showCustomSnackBar(
                              context: context,
                              text: "Password and Confirm Password must be same",
                            );
                            return;
                          }
                          mViewModel?.onResetPassword(
                            mViewModel?.commonModel?.verifyToken ?? "",
                            passwordController.text.trim(),
                            confirmPasswordController.text.trim(),
                          );
                        } else {
                          setState(() {
                            isValidationActivated = true;
                          });
                        }
                        //Navigation.push(context, LoginScreen());
                      },
                    ),
                    SizedBox(height: 20),
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
