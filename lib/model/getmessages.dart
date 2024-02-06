import 'package:cloud_firestore/cloud_firestore.dart';

class GetMessageData {
  String message;
  Timestamp time;
  String sender;

  GetMessageData({
    required this.message,
    required this.time,
    required this.sender,
  });
}
