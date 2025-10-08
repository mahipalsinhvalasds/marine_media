import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/core/navigator/navigation.dart';
import 'package:marine_media_enterprises/screens/forgot_password_screen.dart';
import 'package:marine_media_enterprises/screens/home/home_screen.dart';
import 'package:marine_media_enterprises/screens/login/login_view_model.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:marine_media_enterprises/utils/validation.dart';
import 'package:marine_media_enterprises/widget/custom_button.dart';
import 'package:marine_media_enterprises/widget/custom_textfield.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isValidationActivated = false;

  bool showPassword = false;
  bool isRemember = false;

  LoginViewModel? mViewModel;

  @override
  void initState() {
    super.initState();
    mViewModel = Provider.of<LoginViewModel>(context, listen: false);
    mViewModel?.init(context);
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<LoginViewModel>(context);
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
              child: Form(
                key: formKey,
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
                    CustomTextfield(
                      textController: passwordController,
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
                            : Icon(
                                Icons.visibility_outlined,
                                color: Colors.grey,
                              ),
                      ),
                      validation: (value) => CustomValidations.nullValidator(
                        value,
                        customMessage: "Please enter Password",
                      ),
                      onChanged: (value) {
                        if (isValidationActivated) {
                          formKey.currentState!.validate();
                        }
                      },
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
                    SizedBox(height: 40),
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
                      loading: mViewModel?.loading ?? false,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          mViewModel?.onLoginTap(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            isRemember == true ? "true" : "false",
                          );
                        } else {
                          setState(() {
                            isValidationActivated = true;
                          });
                        }
                      },
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
