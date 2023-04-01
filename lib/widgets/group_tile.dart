import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wechat/screens/chat_screen.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  GroupTile({Key? key, required this.userName, required this.groupId, required this.groupName}) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(groupId: widget.groupId,groupName: widget.groupName,userName: widget.userName,),));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: CupertinoColors.darkBackgroundGray.withOpacity(0.1), width: 1.0))
        ),
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: CupertinoColors.systemBlue.highContrastElevatedColor,
            child: Text(widget.groupName.substring(0,1).toUpperCase(),textAlign: TextAlign.center,style: GoogleFonts.poppins(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w600),),
          ),
          title: Text(widget.groupName,style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 15,color: CupertinoColors.systemBlue.highContrastElevatedColor),),
          subtitle: Text("Join the group as ${widget.userName}.",style: GoogleFonts.poppins(color: CupertinoColors.darkBackgroundGray,fontSize: 12,fontWeight: FontWeight.w600),),
        ),
      ),
    );
  }
}
