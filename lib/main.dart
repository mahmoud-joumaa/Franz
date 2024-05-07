import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:franz/config.dart';
import 'package:franz/pages/home/home.dart';
import 'package:franz/pages/welcome.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  UserTheme.isDark = (WidgetsBinding.instance.platformDispatcher.platformBrightness==Brightness.dark);

  runApp(ChangeNotifierProvider<UserTheme>(
    create: (context) => UserTheme(),
    child: const Root(),
  ));

}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<UserTheme>(context,listen: false).toggleTheme(UserTheme.isDark);
    return MaterialApp(
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

    );
  }
}
