import 'package:flutter/material.dart';
import 'package:marine_media_enterprises/app/app_view_model.dart';
import 'package:marine_media_enterprises/screens/add_to_training/add_training_view_model.dart';
import 'package:marine_media_enterprises/screens/change_password/change_password_view_model.dart';
import 'package:marine_media_enterprises/screens/forgot_password/forgot_password_view_model.dart';
import 'package:marine_media_enterprises/screens/home/home_view_model.dart';
import 'package:marine_media_enterprises/screens/login/login_view_model.dart';
import 'package:marine_media_enterprises/screens/my_training/my_training_view_model.dart';
import 'package:marine_media_enterprises/screens/privacy_policy/privacy_policy_view_model.dart';
import 'package:marine_media_enterprises/screens/quiz_question/quiz_question_view_model.dart';
import 'package:marine_media_enterprises/screens/splash_screen.dart';
import 'package:marine_media_enterprises/screens/term_condition/term_condition_view_model.dart';
import 'package:provider/provider.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

final routeObserver = RouteObserver<PageRoute>();

class _AppViewState extends State<AppView> with WidgetsBindingObserver {
  static BuildContext? appContext;
  final _app = AppModel();

  @override
  void initState() {
    super.initState();
    appContext = context;
  }

  Color statusBarColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    appContext = context;
    return ChangeNotifierProvider<AppModel>.value(
      value: _app,
      child: Consumer<AppModel>(
        builder: (context, value, child) {
          value.isLoading = false;
          if (value.isLoading) {
            return Container(color: Theme.of(context).colorScheme.background);
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<LoginViewModel>(
                create: (_) => LoginViewModel(),
              ),
              ChangeNotifierProvider<HomeViewModel>(
                create: (_) => HomeViewModel(),
              ),
              ChangeNotifierProvider<AddTrainingApiViewModel>(
                create: (_) => AddTrainingApiViewModel(),
              ),
              ChangeNotifierProvider<MyTrainingViewModel>(
                create: (_) => MyTrainingViewModel(),
              ),
              ChangeNotifierProvider<QuizQuestionViewModel>(
                create: (_) => QuizQuestionViewModel(),
              ),
              ChangeNotifierProvider<PrivacyPolicyViewModel>(
                create: (_) => PrivacyPolicyViewModel(),
              ),
              ChangeNotifierProvider<TermConditionViewModel>(
                create: (_) => TermConditionViewModel(),
              ),
              ChangeNotifierProvider<ChangePasswordViewModel>(
                create: (_) => ChangePasswordViewModel(),
              ),
              ChangeNotifierProvider<ForgotPasswordViewModel>(
                create: (_) => ForgotPasswordViewModel(),
              ),
            ],
            child: MaterialApp(
              scrollBehavior: const ScrollBehavior().copyWith(
                overscroll: false,
              ),
              debugShowCheckedModeBanner: false,
              title: "Marine Media Enterprises",
              locale: value.locale,
              builder: (BuildContext context, Widget? child) {
                final MediaQueryData data = MediaQuery.of(context);
                return MediaQuery(
                  data: data.copyWith(textScaler: const TextScaler.linear(1)),
                  child: child!,
                );
              },
              home: const SplashScreen(),
              routes: const <String, WidgetBuilder>{},
              navigatorObservers: [routeObserver],
            ),
          );
        },
      ),
    );
  }
}
