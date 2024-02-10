import 'package:chat_app_24/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("-----------------------------------------------------");
    print(AuthController.currentChatRoomId);
    print("-----------------------------------------------------");
    return ZegoUIKitPrebuiltCall(
      appID:
          1182374150, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign:
          "29ca099d06f61e312d8feb34e335f1bb539e0ea4f800e291a0b45fdfdcdbc743", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: AuthController.currentUser!.email!,
      userName: AuthController.currentUser!.email!,
      callID: AuthController.currentChatRoomId,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}
