import 'package:androidmap/splash.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'home.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Houshan Map',
      theme: ThemeData.dark(
        // useMaterial3: true,
        // colorSchemeSeed: const Color(0xFF8dea88),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        // '/': (context) => SplashFuturePage(),
        '/home': (context) => MapControllerPage(),
      },
      // home: const MapControllerPage(),
      // routes: <String, WidgetBuilder>{
      //   PolylinePage.route: (context) => const PolylinePage(),
      //   MapControllerPage.route: (context) => const MapControllerPage(),
      //   AnimatedMapControllerPage.route: (context) => const AnimatedMapControllerPage(),
      // },
    );
  }
}
