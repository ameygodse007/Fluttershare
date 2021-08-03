import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/Chatmessage.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/widgets/progress.dart';

import 'home.dart';



class ChatDetailPage extends StatefulWidget {
  final User user;
  final String currentuser;
  ChatDetailPage({this.user, this.currentuser});
  @override
  _ChatDetailPageState createState() =>
      _ChatDetailPageState(user: user, currentuser: currentuser);
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  TextEditingController commentController = TextEditingController();
  final User user;
  bool sentmsg = false;
  final String currentuser;
  _ChatDetailPageState({this.user, this.currentuser});
  String message = "";
  List<ChatMessage> messages = [];
  List<ChatMessage> recemsgs = [];
  sendmessage() {
    chats
        .document(currentuser + user.id)
        .collection("messages")
        .add({"message": commentController.text, "sender": "sender"});
    setState(() {
      sentmsg = true;
    });
    print(currentuser);
    print("user id" + user.id);

    commentController.clear();
  }

  getmsgs() async {
    QuerySnapshot snapshot = await chats
        .document(user.id + currentuser)
        .collection('messages')
        .getDocuments();
    snapshot.documents.forEach((doc) => messages.add(ChatMessage(
                messageContent: doc["message"], messageType: "receiver")));
  }

  @override
  void initState() {
    super.initState();
    getmsgs();
  }

  chatRoom() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        user.username,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: ListView.builder(
              itemCount: messages.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (messages[index].messageType == "receiver"
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (messages[index].messageType == "receiver"
                            ? Colors.grey.shade200
                            : Colors.blue[200]),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        messages[index].messageContent,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: sendmessage,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildmessages() {
    return StreamBuilder(
        stream: chats
            .document(currentuser + user.id)
            .collection("messages")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          messages = [];
          snapshot.data.documents.forEach((doc) {
            messages.add(ChatMessage(
                messageContent: doc["message"], messageType: doc["sender"]));
          });

          return chatRoom();
        });
  }

  @override
  Widget build(BuildContext context) {
    return buildmessages();
  }
}
