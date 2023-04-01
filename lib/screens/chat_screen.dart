import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wechat/screens/group_info.dart';
import 'package:wechat/services/database_service.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  ChatScreen({Key? key, required this.userName, required this.groupId, required this.groupName}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String admin = "";
  Stream<QuerySnapshot>? chats;
  @override
  void initState() {
    super.initState();
    getChatAndAdmin();
  }
  getChatAndAdmin(){
    DatabaseService().getChats(widget.groupId).then((value){
      setState(() {
        chats = value;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((value){
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName,style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 17,),),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => GroupInfo(adminName: admin, groupId: widget.groupId, groupName: widget.groupName,),));
              },
              icon: Icon(Icons.info_outline_rounded))
        ],
      ),
      body: Center(
        child: Text(widget.groupName),
      ),
    );
  }
}
