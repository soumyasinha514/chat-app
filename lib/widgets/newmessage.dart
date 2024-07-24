import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() {
    return NewMessageState();
  }
}

class NewMessageState extends State<NewMessage> {
  final _mssgController = TextEditingController();
  var _text = 'Send a message...';

 @override 
 void dispose(){
  _mssgController.dispose();
  super.dispose();
 }

  void _submit() async{
    final mssgInput = _mssgController.text;

    if(mssgInput.trim().isEmpty){
      return;
    }

    _mssgController.clear();
     setState(() {
                _text = 'Send a message...';
              });
    FocusScope.of(context).unfocus();

    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

    FirebaseFirestore.instance.collection('chats').add({
      'text' : mssgInput,
      'createdAt': Timestamp.now(),
      'userId' : user.uid,
      'user_name' : userData.data()!['user_name'],
      'userImageUrl' : userData.data()!['image_url']

    });

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
              child: TextField(

            decoration: InputDecoration(labelText: _text,),
            onTap: (){
              setState(() {
                _text = '';
              });
            },
            autocorrect: true,
            enableSuggestions: true,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
            controller: _mssgController,
          )),
          IconButton(
            onPressed: _submit,
            icon:const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }
}
