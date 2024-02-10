import 'dart:async';

import 'package:chat_app_24/controller/auth_controller.dart';
import 'package:chat_app_24/helper/firestore_helper.dart';
import 'package:chat_app_24/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class AuthHelper {
  AuthHelper._();

  static final AuthHelper authHelper = AuthHelper._();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String?> signUpUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserData userData = UserData(
          id: userCredential.user!.uid,
          name: "${email.split("@")[0].capitalizeFirst}",
          email: email,
          password: password);

      await FireStoreHelper.fireStoreHelper
          .addUserInFireStoreDatabase(userData);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    }
    return null;
  }

  Future<String?> loginUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      AuthController.currentUser = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return 'Invalid Credential';
      }
    }

    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 1182374150 /*input your AppID*/,
      appSign:
          "29ca099d06f61e312d8feb34e335f1bb539e0ea4f800e291a0b45fdfdcdbc743" /*input your AppSign*/,
      userID: AuthController.currentUser!.email!,
      userName: AuthController.currentUser!.email!,
      plugins: [ZegoUIKitSignalingPlugin()],
    );
    return null;
  }

  Future<User?> loginUserWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    AuthController.currentUser = userCredential.user;

    return userCredential.user;
  }
}
