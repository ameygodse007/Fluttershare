import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
class ChatUsers {
  String id;
  String name;
  String text;
  String secondaryText;
  String image;
  String time;
  ChatUsers({this.id,this.name, this.text, this.secondaryText, this.image, this.time});

  factory ChatUsers.fromDocument(DocumentSnapshot doc) {
    return ChatUsers(
      id: doc['id'],
      name: doc['username'],
      image: doc['photoUrl'],
      secondaryText: doc['bio'],
      time: DateFormat.jm().format(DateTime.now()).toString()
    );
  }
}
