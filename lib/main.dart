import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat/helper/helper_function.dart';
import 'package:wechat/screens/auth/login_screen.dart';
import 'package:wechat/screens/auth/register_screen.dart';
import 'package:wechat/screens/home_screen.dart';
import 'package:wechat/screens/search_screen.dart';
import 'package:wechat/screens/splash_creen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyAppWrapper());
}

class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  @override
  void initState() {
    super.initState();
    getUserLoggedStatus();
  }

  void getUserLoggedStatus() async {
    await HelperFunctions.getUserloggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: CupertinoColors.systemBlue.highContrastElevatedColor,
          appBarTheme: AppBarTheme(
              backgroundColor:
                  CupertinoColors.systemBlue.highContrastElevatedColor)),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/splash': (context) => SplashScreen(isSignedIn: _isSignedIn),
        '/home': (context) => HomeScreen(),
        '/search': (context) => SearchScreen(),
      },
    );
  }
}
