import 'package:chat_app_24/controller/auth_controller.dart';
import 'package:chat_app_24/helper/firestore_helper.dart';
import 'package:chat_app_24/model/user_model.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    UserData userData = ModalRoute.of(context)!.settings.arguments as UserData;

    TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(userData.name),
        elevation: 3,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              flex: 12,
              child: ListView(
                children: FireStoreHelper.fireStoreHelper.fetchedMessages
                    .map(
                      (e) => Row(
                        mainAxisAlignment:
                            (e.sender == AuthController.currentUser!.email)
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Chip(
                              label: Column(
                                crossAxisAlignment: (e.sender ==
                                        AuthController.currentUser!.email)
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.message,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    '${e.time.toDate().hour}:${e.time.toDate().minute}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        hintText: "Enter message",
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: FloatingActionButton(
                      onPressed: () async {
                        await FireStoreHelper.fireStoreHelper
                            .sendMessage(AuthController.currentUser!.email!,
                                userData.email, messageController.text)
                            .then((value) {
                          messageController.clear();
                        });

                        setState(() {});
                      },
                      elevation: 0,
                      child: const Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
