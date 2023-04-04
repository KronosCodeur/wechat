import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wechat/screens/group_info_screen.dart';
import 'package:wechat/services/database_service.dart';
import 'package:wechat/widgets/chat_tile.dart';
import 'package:wechat/widgets/show_snack_bar.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  ChatScreen(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver{
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        title: Text(widget.groupName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 25,color: Colors.white.withOpacity(0.8),letterSpacing:1)),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupInfo(
                        adminName: admin,
                        groupId: widget.groupId,
                        groupName: widget.groupName,
                      ),
                    ));
              },
              icon: Icon(Icons.info_outline_rounded,size: 30,))
        ],
      ),
      body: Stack(
        children: <Widget>[
          // chat messages here
          Padding(
            padding: EdgeInsets.only(bottom: 80),
            child: chatMessages(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: CupertinoColors.darkBackgroundGray,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
              ),
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                      autocorrect: true,
                  textAlign: TextAlign.start,
                  controller: messageController,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18,fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: "Type your message here...",
                     hintStyle:
                        GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontSize: 16,fontWeight: FontWeight.w500),
                    border: InputBorder.none,
                    enabled: true,
                  ),
                )),
                SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    ),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.userName ==
                          snapshot.data.docs[index]['sender'],
                    time: snapshot.data.docs[index]['daily']
                  );
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) { 
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().toString(),
        "daily":DateTime.now().toString().substring(11,16),
      };
      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
       _scrollController.jumpTo( _scrollController.position.maxScrollExtent);
      });
    }

  }
}
