import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key,required this.isSignedIn}) : super(key: key);
  bool isSignedIn;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  redirection (){
    if(widget.isSignedIn){
      Navigator.pushNamed(context, "/home");
    }else{
      Navigator.pushNamed(context, "/login");
    }
  }
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      redirection();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset("assets/116791-chat.json",height: 300,width: 300,animate: true,repeat: true,fit: BoxFit.cover,alignment: Alignment.center,),
                Text("WeChat",
                  style: GoogleFonts.poppins(
                    color: CupertinoColors.systemBlue.highContrastElevatedColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 20,),
                LottieBuilder.asset("assets/81154-typing-in-chat.json",height: 25,width: 150,animate: true,repeat: true,fit: BoxFit.cover,alignment: Alignment.center,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
