import 'package:chat_app_24/controller/auth_controller.dart';
import 'package:chat_app_24/model/fetchChatRoomUsers.dart';
import 'package:chat_app_24/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addUserInFireStoreDatabase(UserData userData) async {
    await firebaseFirestore.collection('users').doc().set({
      'id': userData.id,
      'name': userData.name,
      'email': userData.email,
      'password': userData.password,
    });
  }

  Future<List<QueryDocumentSnapshot>> fetchAllUserData() async {
    QuerySnapshot querySnapshot = await firebaseFirestore
        .collection('users')
        .where("email", isNotEqualTo: AuthController.currentUser!.email)
        .get();

    List<QueryDocumentSnapshot> data = querySnapshot.docs;

    return data;
  }

  void createChatRoomId(String u1, String u2) async {
    List<FetchChatUserId> fetchedChatsId = [];
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('chats').get();

    List<QueryDocumentSnapshot> data = querySnapshot.docs;

    if (data.isEmpty) {
      AuthController.currentChatRoomId = "${u1}_$u2";
      print(AuthController.currentChatRoomId);
      print("====================");
    } else {
      fetchedChatsId = data
          .map((e) => FetchChatUserId(user1: e['sender'], user2: e['receiver']))
          .toList();
      for (var element in fetchedChatsId) {
        if ((u1 == element.user1 || u1 == element.user2) &&
            (u2 == element.user1 || u2 == element.user2)) {
          if (u1 == element.user1 && u2 == element.user2) {
            AuthController.currentChatRoomId = "${u1}_$u2";
          } else {
            AuthController.currentChatRoomId = "${u2}_$u1";
          }
        }
      }
    }
  }

  Future<void> sendMessage(
      String sender, String receiver, String message) async {
    await firebaseFirestore
        .collection('chats')
        .doc(AuthController.currentChatRoomId)
        .set({
      'sender': sender,
      'receiver': receiver,
    });

    firebaseFirestore
        .collection('chats')
        .doc(AuthController.currentChatRoomId)
        .collection('messages')
        .doc()
        .set({
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'time': DateTime.now(),
    });
  }
}
