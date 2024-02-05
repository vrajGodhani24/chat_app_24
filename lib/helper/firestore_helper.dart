import 'package:chat_app_24/controller/auth_controller.dart';
import 'package:chat_app_24/model/fetchChatRoomUsers.dart';
import 'package:chat_app_24/model/getmessages.dart';
import 'package:chat_app_24/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  List<GetMessageData> fetchedMessageData = [];

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

  bool alreadyIdExists(String u1, String u2, FetchChatUserId element) {
    if ((u1 == element.user1 || u1 == element.user2) &&
        (u2 == element.user1 || u2 == element.user2)) {
      if (u1 == element.user1 && u2 == element.user2) {
        AuthController.currentChatRoomId = "${u1}_$u2";
        print(AuthController.currentChatRoomId);
        print("++++++++++++++++++++++++");
      } else {
        AuthController.currentChatRoomId = "${u2}_$u1";
        print(AuthController.currentChatRoomId);
        print("-------------////////////");
      }
      return true;
    }
    return false;
  }

  void createChatRoomId(String u1, String u2) async {
    List<FetchChatUserId> fetchedChatsId = [];
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('chats').get();

    List<QueryDocumentSnapshot> data = querySnapshot.docs;

    if (data.isEmpty) {
      AuthController.currentChatRoomId = "${u1}_$u2";
      await firebaseFirestore
          .collection('chats')
          .doc(AuthController.currentChatRoomId)
          .set({
        'chat_id': AuthController.currentChatRoomId,
      });
      print(AuthController.currentChatRoomId);
      print("====================");
    } else {
      fetchedChatsId = data.map((e) {
        String fetchUser1 = e['chat_id'].toString().split("_")[0];
        String fetchUser2 = e['chat_id'].toString().split("_")[1];
        return FetchChatUserId(user1: fetchUser1, user2: fetchUser2);
      }).toList();

      for (var e in fetchedChatsId) {
        print("u1 = ${e.user1}");
        print("u2 = ${e.user2}");
      }
      bool? alreadyId = false;
      for (var element in fetchedChatsId) {
        alreadyId = alreadyIdExists(u1, u2, element);
        if (alreadyId) {
          break;
        }
      }
      if (alreadyId == false) {
        AuthController.currentChatRoomId = "${u1}_$u2";
        await firebaseFirestore
            .collection('chats')
            .doc(AuthController.currentChatRoomId)
            .set({
          'chat_id': AuthController.currentChatRoomId,
        });
        print(AuthController.currentChatRoomId);
        print("----------_____________");
      }
    }
  }

  Future<List<GetMessageData>> getMessages() async {
    QuerySnapshot querySnapshot = await firebaseFirestore
        .collection('chats')
        .doc(AuthController.currentChatRoomId)
        .collection('messages')
        .get();

    List<QueryDocumentSnapshot> data = querySnapshot.docs;

    return data
        .map((e) => GetMessageData(message: e['message'], time: e['time']))
        .toList();
  }

  Future<void> sendMessage(
      String sender, String receiver, String message) async {
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
