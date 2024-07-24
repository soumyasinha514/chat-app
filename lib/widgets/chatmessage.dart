import 'package:chatapp/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({super.key});

  final _currentAuthenticatedUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found!'),
          );
        }
        if (chatSnapshot.hasError) {
          return const Center(
            child: Text('Something went wrong!'),
          );
        }
        final loadedMessages = chatSnapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            final currentMessage = loadedMessages[index].data();
            final nextMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;

            final currentMessageUserId = currentMessage['userId'];
            final nextMessageUserId =
                nextMessage != null ? nextMessage['userId'] : null;

            final isNextUserSame = currentMessageUserId == nextMessageUserId;

            if (isNextUserSame) {
              return MessageBubble.next(
                  message: currentMessage['text'],
                  isMe: _currentAuthenticatedUser!.uid == currentMessageUserId);
            } else {
              return MessageBubble.first(
                  userImage: currentMessage['userImageUrl'],
                  username: currentMessage['user_name'],
                  message: currentMessage['text'],
                  isMe: _currentAuthenticatedUser!.uid == currentMessageUserId);
            }
          },
        );
      },
    );
  }
}
