import 'package:chat_app_24/controller/auth_controller.dart';
import 'package:chat_app_24/utils/colors.dart';
import 'package:chat_app_24/utils/strings.dart';
import 'package:chat_app_24/views/screens/homepage/controller/homepage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageController homePageController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              appSecondaryWhiteColor,
              appPrimaryColor.withOpacity(0.7),
            ],
          ),
        ),
        alignment: Alignment.center,
        child: GetBuilder<HomePageController>(builder: (controller) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          (AuthController.currentUser!.photoURL == null)
                              ? photoURL
                              : AuthController.currentUser!.photoURL!),
                    ),
                    const SizedBox(width: 30),
                    Text(
                        "${AuthController.currentUser!.email!.split("@")[0].capitalizeFirst}"),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  homePageController.fetchedAllUserData
                      .map((e) => Card(
                            child: ListTile(
                              leading: const FlutterLogo(size: 45),
                              title: Text(e.name),
                              subtitle: Text(e.email),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}