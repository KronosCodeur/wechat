import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wechat/helper/helper_function.dart';
import 'package:wechat/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  String userName;
  String email;
  ProfileScreen({Key? key, required this.userName, required this.email})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "";
  String email = "";
  @override
  void initState() {
    super.initState();
    getUserData();
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
  }

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CupertinoColors.systemBlue.highContrastColor,
        title: Text(
          "Profile",
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
              onTap: () {
                Navigator.pushNamed(context, "/home");
              },
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
              onTap: () {},
              selectedColor: CupertinoColors.systemBlue,
              selected: true,
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
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_rounded,
              size: 200,
              color: CupertinoColors.darkBackgroundGray,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Full Name",
                  style: GoogleFonts.poppins(
                      color: CupertinoColors.systemBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.userName,
                  style: GoogleFonts.poppins(
                      color: CupertinoColors.systemBlue.highContrastColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Email",
                  style: GoogleFonts.poppins(
                      color: CupertinoColors.systemBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.email,
                  style: GoogleFonts.poppins(
                      color: CupertinoColors.systemBlue.highContrastColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
