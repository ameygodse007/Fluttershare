import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';

import 'Conversationlist.dart';

class Timeline extends StatefulWidget {
  final String currentuser;

  Timeline({this.currentuser});
  @override
  _TimelineState createState() => _TimelineState(currentuser: currentuser);
}

class _TimelineState extends State<Timeline> {
  final String currentuser;
  String text = "";
  String secondaryText = "";
  String image = "";
  String time = "";
  TextEditingController commentController = TextEditingController();
  Future<QuerySnapshot> users;
  _TimelineState({this.currentuser});
  getmessangers() {
    Future<QuerySnapshot> users = usersRef.getDocuments();
    setState(() {
      users = users;
    });

    return FutureBuilder(
        future: users,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<ConversationList> chatUsers = [];
          snapshot.data.documents.forEach((doc) {
            User user = User.fromDocument(doc);
            chatUsers.add(ConversationList(user: user,currentuser:currentuser));
          });

          return ListView(
            children: chatUsers,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: getmessangers(),
    );
  }
}
