import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/screens/forgot_password/forgot_password_view_model.dart';
import 'package:marine_media_enterprises/utils/app_colors/app_colors.dart';
import 'package:marine_media_enterprises/utils/local_images/local_images.dart';
import 'package:marine_media_enterprises/utils/text_style/text_style.dart';
import 'package:marine_media_enterprises/utils/validation.dart';
import 'package:marine_media_enterprises/widget/custom_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
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
                    SizedBox(height: 80),
                    Image.asset(LocalImages.logo),
                    SizedBox(height: 70),
                    Center(
                      child: Text(
                        "Enter Otp",
                        style: CommonStyle.getRalewayFont(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    PinCodeTextField(
                      controller: _otpController,
                      appContext: context,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      keyboardType: TextInputType.number,
                      mainAxisAlignment: MainAxisAlignment.center,
                      textStyle: CommonStyle.getRalewayFont(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      validator: (value) =>
                          CustomValidations.nullValidator(value),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.circle,
                        fieldHeight: 40,
                        fieldWidth: 40,
                        activeFillColor: AppColors.primaryColor,
                        selectedFillColor: AppColors.backgroundColor,
                        inactiveFillColor: Colors.white,
                        inactiveColor: AppColors.primaryColor,
                        selectedColor: AppColors.primaryColor,
                        activeColor: AppColors.primaryColor,
                        borderWidth: 2,
                        fieldOuterPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                        ),
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 32),
                    CustomButton(
                      text: "Next",
                      loading: mViewModel?.loading ?? false,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          mViewModel?.onOtpVerification(
                            widget.email,
                            _otpController.text.trim(),
                          );
                        } else {
                          setState(() {
                            isValidationActivated = true;
                          });
                        }
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
