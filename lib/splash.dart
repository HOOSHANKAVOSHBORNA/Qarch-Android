import 'package:easy_splash_screen/easy_splash_screen.dart';
import '../home.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('images/location.png'),
      title: Text(
        "Houshan Map",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.black26,
      showLoader: true,
      loaderColor: Colors.white54,
      loadingText: Text("Loading..."),
      navigator: MapControllerPage(),
      durationInSeconds: 3,
    );
  }
}