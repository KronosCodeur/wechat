import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:wechat/helper/helper_function.dart';
import 'package:wechat/services/auth_service.dart';
import 'package:wechat/services/database_service.dart';
import 'package:wechat/widgets/show_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  AuthService authService = AuthService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator(
                color: CupertinoColors.systemBlue,
                strokeWidth: 2,
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: LottieBuilder.asset(
                            "assets/59839-commnet-animation.json",
                            height: 150,
                            width: 150,
                            animate: true,
                            fit: BoxFit.cover,
                            repeat: true,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "CodeTalk",
                          style: GoogleFonts.badScript(
                            color: CupertinoColors.systemBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        )
                      ],
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: 300,
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:
                                  CupertinoColors.systemBlue.withOpacity(0.4),
                            ),
                            child: TextFormField(
                              style: GoogleFonts.poppins(
                                  color: CupertinoColors
                                      .systemBlue.highContrastColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15),
                              controller: _email,
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: GoogleFonts.poppins(
                                    color: CupertinoColors
                                        .systemGrey.highContrastColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15),
                                border: InputBorder.none,
                                icon: Icon(Icons.mail,
                                    color: CupertinoColors
                                        .systemBlue.highContrastColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: 300,
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:
                                  CupertinoColors.systemBlue.withOpacity(0.4),
                            ),
                            child: TextField(
                                style: GoogleFonts.poppins(
                                    color: CupertinoColors
                                        .systemBlue.highContrastColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15),
                                controller: _password,
                                obscureText: _isObscure,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: GoogleFonts.poppins(
                                      color: CupertinoColors
                                          .systemGrey.highContrastColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15),
                                  border: InputBorder.none,
                                  icon: Icon(Icons.lock,
                                      color: CupertinoColors
                                          .systemBlue.highContrastColor),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      },
                                      icon: _isObscure
                                          ? Icon(
                                              Icons.visibility_rounded,
                                              color: CupertinoColors.systemGrey
                                                  .highContrastElevatedColor,
                                            )
                                          : Icon(Icons.visibility_off_rounded,
                                              color: CupertinoColors.systemGrey
                                                  .highContrastElevatedColor)),
                                )),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?"),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, "/register");
                                  },
                                  child: Text("Register")),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              login();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 150,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: CupertinoColors
                                      .systemBlue.highContrastElevatedColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 1.0,
                                      color: CupertinoColors.darkBackgroundGray
                                          .withOpacity(0.4),
                                      blurRadius: 0.5,
                                      offset: Offset(1, 1),
                                    )
                                  ]),
                              child: Text(
                                "Login",
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void login() async {
    String _userMail = _email.text;
    String _userPassword = _password.text;
    if (_userMail.isEmpty || _userPassword.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 5,
            title: Text(
              'Champs vides',
              style: GoogleFonts.poppins(
                  color: CupertinoColors.systemBlue.highContrastColor,
                  fontWeight: FontWeight.bold),
            ),
            content: Text('Veuillez remplir tous les champs'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithEmailAndPassword(_userMail, _userPassword)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(_userMail);
          await HelperFunctions.saveUserloggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(_userMail);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          Navigator.pushReplacementNamed(context, "/home");
          showSnackbar(context,"You are successfully login", GoogleFonts.poppins(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500,), CupertinoColors.activeGreen);
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
