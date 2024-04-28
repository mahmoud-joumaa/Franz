import 'package:flutter/material.dart';

import 'package:franz/pages/home/home.dart';
import 'package:franz/pages/welcome.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Franz",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "WelcomeScreen",
      routes: {
        // "SplashScreen": (context) => const Splash(),
        "WelcomeScreen": (context) => const Welcome(),
        "HomeScreen": (context) => const MyHomePage(title: "title"),
      }
    )
  );
}
