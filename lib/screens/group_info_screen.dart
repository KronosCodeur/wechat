import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wechat/services/database_service.dart';
import 'package:wechat/widgets/show_snack_bar.dart';

class GroupInfo extends StatefulWidget {
  final String adminName;
  final String groupId;
  final String groupName;
  GroupInfo(
      {Key? key,
      required this.adminName,
      required this.groupId,
      required this.groupName})
      : super(key: key);

  @override
  _GroupInfoState createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? Members;
  @override
  void initState() {
    super.initState();
    getMembers();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((value) {
      setState(() {
        Members = value;
      });
    });
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Group Info",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: 250,
                        height: 125,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Exit',
                              style: GoogleFonts.poppins(
                                  color: CupertinoColors
                                      .systemBlue.highContrastColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Are you sure you exit the group?',
                              style: GoogleFonts.poppins(
                                  color: CupertinoColors.systemBlue
                                      .withOpacity(0.8),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.cancel_rounded,
                                      size: 25,
                                      color: CupertinoColors.systemRed,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      DatabaseService(
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .toggleGroupJoin(
                                              widget.groupId,
                                              getName(widget.adminName),
                                              widget.groupName)
                                          .whenComplete(() {
                                        Navigator.pushNamed(context, "/home");
                                        showSnackbar(
                                            context,
                                            "You successfully exit ${widget.groupName}",
                                            GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700),
                                            CupertinoColors.systemRed);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.done_rounded,
                                      size: 25,
                                      color: CupertinoColors.activeGreen,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                      elevation: 5,
                    );
                  },
                );
              },
              icon: Icon(Icons.exit_to_app_rounded),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: CupertinoColors.systemBlue.highContrastElevatedColor
                      .withOpacity(0.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor:
                          CupertinoColors.systemBlue.highContrastElevatedColor,
                      child: Text(
                        widget.groupName.substring(0, 1).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Group:  ${widget.groupName}",
                          style: GoogleFonts.poppins(
                              color: CupertinoColors.darkBackgroundGray,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Admin:  ${getName(widget.adminName)}",
                          style: GoogleFonts.poppins(
                              color: CupertinoColors.darkBackgroundGray,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ),
              ),
              memberList(),
            ],
          ),
        ));
  }

  memberList() {
    return StreamBuilder(
      stream: Members,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'] != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['members'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: CupertinoColors
                              .systemBlue.highContrastElevatedColor,
                          child: Text(
                            getName(snapshot.data['members'][index])
                                .substring(0, 1)
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        title: Text(getName(snapshot.data['members'][index]),
                            style: GoogleFonts.poppins(
                                color: CupertinoColors.darkBackgroundGray,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(getId(snapshot.data['members'][index]),
                            style: GoogleFonts.poppins(
                                color: CupertinoColors.darkBackgroundGray
                                    .withOpacity(0.5),
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                    );
                  });
            } else {
              return Center(
                child: Text("NO MEMBERS",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        color: CupertinoColors.darkBackgroundGray,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              );
            }
          } else {
            return Center(
              child: Text("NO MEMBERS",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: CupertinoColors.darkBackgroundGray,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: CupertinoColors.systemBlue.highContrastElevatedColor,
              strokeWidth: 2,
            ),
          );
        }
      },
    );
  }
}
