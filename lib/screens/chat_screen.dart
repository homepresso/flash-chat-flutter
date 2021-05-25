import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'Chat_Screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String messageText;

  @override
  initState() {
    // Firebase.initializeApp();

    getCurrentUser();
    print(loggedInUser.email);
    super.initState();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      print(user.email);
    }
  }

// void getMessages() async {
// final messages = await _fireStore.collection('messages').get();
// for (var message in messages.docs) {
//   print(message.data());
// }

//   }

  void messageStream() async {
    await for (var snapshot in _fireStore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messageStream();
                // _auth.signOut();

                // Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _fireStore.collection('messages').where("sender", isEqualTo: "andy@gmail.com").snapshots(), 
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),);
                  }
                    final messages = snapshot.data.docs;
                    List<Text> messageWidgets = [];
                    for (var message in messages) {
                      final messageText = message.get('text');
                      final messageSender = message.get('sender');

                      final messageWidget =
                          Text('$messageText from $messageSender', style: TextStyle(fontSize: 14, color: Colors.white),);
                      messageWidgets.add(messageWidget);
                    }
                         return Expanded(
                           child: ListView(
                             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    children: messageWidgets,
                  ),
                         );
            
                  
            
                },
                ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _fireStore.collection('messages').add(
                          {'text': messageText, 'sender': loggedInUser.email});
                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
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

class messageBubble extends StatelessWidget {

  messageBubble({@required this.text,@required this.sender});

  final String text;
  final String sender;
  @override
  Widget build(BuildContext context) {
    return Text('$text from $sender', style: TextStyle(fontSize: 14, color: Colors.white),);
                    
  

                    }
  }
}