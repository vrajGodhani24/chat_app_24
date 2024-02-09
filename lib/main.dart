import 'package:chat_app_24/firebase_options.dart';
import 'package:chat_app_24/views/screens/chatpage/chatpage.dart';
import 'package:chat_app_24/views/screens/homepage/screen/homepage.dart';
import 'package:chat_app_24/views/screens/login/screen/login_screen.dart';
import 'package:chat_app_24/views/screens/splash/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/chat', page: () => const ChatScreen()),
        GetPage(name: '/pickedImage', page: () => const PickedImageView()),
      ],
    );
  }
}
