import 'package:chat_app_24/controller/auth_controller.dart';
import 'package:chat_app_24/helper/firestore_helper.dart';
import 'package:chat_app_24/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  List<UserData> fetchedAllUserData = [];

  @override
  void onInit() async {
    super.onInit();

    List<QueryDocumentSnapshot> data =
        await FireStoreHelper.fireStoreHelper.fetchAllUserData();

    for (var element in data) {
      if (element['email'] != AuthController.currentUser!.email) {
        fetchedAllUserData.add(UserData(
            name: element['name'],
            email: element['email'],
            password: element['password']));
      }
    }
    update();
  }
}
