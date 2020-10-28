import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//* widgets
import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging();

    //* for iOS
    fbm.requestNotificationPermissions();
    //*

    fbm.configure(
      onMessage: (msg) {
        if (Platform.isAndroid) {
          print(msg['notification']);
          print(msg['data']);
        }
        if (Platform.isIOS) {
          print(msg['aps']['alert']);
        }
        return;
      },
      onLaunch: (msg) {
        if (Platform.isAndroid) {
          print(msg['notification']);
          print(msg['data']);
        }
        if (Platform.isIOS) {
          print(msg['aps']['alert']);
        }
        return;
      },
      onResume: (msg) {
        if (Platform.isAndroid) {
          print(msg['notification']);
          print(msg['data']);
        }
        if (Platform.isIOS) {
          print(msg['aps']['alert']);
        }
        return;
      },
    );
    fbm.subscribeToTopic('chat');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'Logout',
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'Logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
      // body: StreamBuilder(
      //   stream: Firestore.instance
      //       .collection('/chats/Ddid3Ihbqd0qxixMTLwB/messages')
      //       .snapshots(),
      //   builder: (ctx, streamSnapshot) {
      //     if (streamSnapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     final documents = streamSnapshot.data.documents;
      //     return ListView.builder(
      //       itemCount: documents.length,
      //       itemBuilder: (context, index) => Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Text(
      //           documents[index]['text'],
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
