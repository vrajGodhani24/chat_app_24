import 'package:chat_app_24/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper fireStoreHelper = FireStoreHelper._();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addUserInFireStoreDatabase(UserData userData) async {
    await firebaseFirestore.collection('users').doc().set({
      'name': userData.name,
      'email': userData.email,
      'password': userData.password,
    });
  }

  Future<List<QueryDocumentSnapshot>> fetchAllUserData() async {
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('users').get();

    List<QueryDocumentSnapshot> data = querySnapshot.docs;

    return data;
  }
}
