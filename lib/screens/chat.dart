import 'package:chatapp/widgets/chatmessage.dart';
import 'package:chatapp/widgets/newmessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  void setupPushNotifications() async {

    final fcm = FirebaseMessaging.instance; // fcm stands for 'Firebase Cloud Messaging'.
    fcm.requestPermission();
   fcm.subscribeToTopic('chat');

  }

  @override
  void initState() {
   
    super.initState();
    setupPushNotifications();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        actions: [
          TextButton.icon(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            label: const Text('Log Out'),
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
      body: Column( children: [  
        Expanded(child: ChatMessage()),
        const NewMessage()
      ],)
      );
   
  }
}
