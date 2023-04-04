import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wechat/helper/helper_function.dart';
import 'package:wechat/screens/profile_screen.dart';
import 'package:wechat/services/auth_service.dart';
import 'package:wechat/services/database_service.dart';
import 'package:wechat/widgets/group_tile.dart';
import 'package:wechat/widgets/show_snack_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";
  String email = "";
  String groupName = "";
  Stream? groups;
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  getUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  bool _isLoading = false;

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CupertinoColors.systemBlue.highContrastColor,
        title: Text(
          "Groups",
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/search");
            },
            icon: Icon(
              Icons.search_rounded,
              weight: 600,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(
              Icons.account_circle,
              size: 150,
              color: CupertinoColors.darkBackgroundGray,
            ),
            Text(
              userName,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            Divider(
              height: 5,
            ),
            ListTile(
              onTap: () {},
              selectedColor: CupertinoColors.systemBlue,
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(
                Icons.groups_rounded,
                size: 30,
              ),
              title: Text(
                "Groups",
                style: GoogleFonts.poppins(
                    color: CupertinoColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w800),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(userName: userName, email: email),
                    ));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(
                Icons.person_rounded,
                size: 30,
              ),
              title: Text(
                "Contact",
                style: GoogleFonts.poppins(
                    color: CupertinoColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w800),
              ),
            ),
            ListTile(
              onTap: () async {
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
                              'Logout',
                              style: GoogleFonts.poppins(
                                  color: CupertinoColors
                                      .systemBlue.highContrastColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Are you sure you ant to logout?',
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
                                      authService.signOut();
                                      Navigator.pushNamed(context, "/login");
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
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(
                Icons.exit_to_app_rounded,
                size: 30,
              ),
              title: Text(
                "Logout",
                style: GoogleFonts.poppins(
                    color: CupertinoColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
      body: GroupList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CupertinoColors.systemBlue.highContrastElevatedColor,
        elevation: 5,
        onPressed: () {
          popUpDialog(context);
        },
        child: Icon(
          Icons.group_add_rounded,
          color: CupertinoColors.white,
          size: 30,
        ),
      ),
    );
  }

  GroupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    int reverseIndex =
                        snapshot.data['groups'].length - index - 1;
                    return GroupTile(
                      userName: snapshot.data['fullName'],
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getName(snapshot.data['groups'][reverseIndex]),
                    );
                  });
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: CupertinoColors.systemBlue,
              strokeWidth: 2,
            ),
          );
        }
      },
    );
  }

  void popUpDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                width: 250,
                height: 175,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Create a group",
                      style: GoogleFonts.poppins(
                          color: CupertinoColors.systemBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Column(
                      children: [
                        _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: CupertinoColors.systemBlue,
                                  strokeWidth: 2,
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.center,
                                width: 200,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: CupertinoColors.systemBlue)),
                                child: TextField(
                                  onChanged: (value) {
                                    groupName = value;
                                  },
                                  style: GoogleFonts.poppins(
                                      color: CupertinoColors
                                          .systemBlue.highContrastColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (groupName != null) {
                              setState(() {
                                _isLoading = true;
                              });
                              await DatabaseService(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .createGroup(
                                      userName,
                                      FirebaseAuth.instance.currentUser!.uid,
                                      groupName)
                                  .whenComplete(() {
                                _isLoading = false;
                                Navigator.of(context).pop();
                                showSnackbar(
                                    context,
                                    "Groupe crée avec success",
                                    GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    CupertinoColors.systemGreen);
                              });
                            } else {}
                          },
                          child: Text(
                            "Create",
                            style: GoogleFonts.poppins(
                                color: CupertinoColors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  CupertinoColors.systemBlue)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                                color: CupertinoColors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  CupertinoColors.systemBlue)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              elevation: 5,
            );
          },
        );
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                popUpDialog(context);
              },
              child: Icon(
                Icons.add_circle_outline_rounded,
                color: CupertinoColors.darkBackgroundGray,
                size: 75,
              )),
          SizedBox(
            height: 20,
          ),
          Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            style: GoogleFonts.poppins(
                color: CupertinoColors.darkBackgroundGray.withOpacity(0.7),
                fontSize: 15,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
