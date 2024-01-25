import 'package:chat_app_24/controller/auth_controller.dart';
import 'package:chat_app_24/helper/auth_helper.dart';
import 'package:chat_app_24/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Duration loginTime = const Duration(milliseconds: 2250);
    AuthController authController = Get.put(AuthController());

    return Scaffold(
      body: GetBuilder<AuthController>(builder: (controller) {
        return FlutterLogin(
          logo: 'assets/icon/logo.png',
          title: 'DROP',
          hideForgotPasswordButton: true,
          loginAfterSignUp: false,
          theme: LoginTheme(
            pageColorLight: appSecondaryWhiteColor,
            pageColorDark: appPrimaryColor,
            accentColor: appPrimaryColor,
            logoWidth: 0.3,
          ),
          loginProviders: <LoginProvider>[
            LoginProvider(
              icon: FontAwesomeIcons.google,
              label: 'Google',
              callback: () async {
                await Future.delayed(loginTime);
                await AuthHelper.authHelper.loginUserWithGoogle().then((value) {
                  Get.offAllNamed('/');
                });
              },
            ),
          ],
          onLogin: (LoginData loginData) async {
            return await AuthHelper.authHelper.loginUserWithEmailAndPassword(
                email: loginData.name, password: loginData.password);
          },
          onSignup: (SignupData signupData) async {
            return await AuthHelper.authHelper.signUpUserWithEmailAndPassword(
                email: signupData.name!, password: signupData.password!);
          },
          onRecoverPassword: (_) {},
          onSubmitAnimationCompleted: () {
            if (AuthController.currentUser != null) {
              Get.offAllNamed('/');
            }
          },
        );
      }),
    );
  }
}
