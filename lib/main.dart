import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'package:franz/amplifyconfiguration.dart';

import 'package:franz/global.dart';
import 'package:franz/pages/home/home.dart';
import 'package:franz/pages/welcome.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Detect system theme
  UserTheme.isDark = (WidgetsBinding.instance.platformDispatcher.platformBrightness==Brightness.dark);

  // Configure amplify
  try {
    final auth = AmplifyAuthCognito();
    final storage = AmplifyStorageS3();
    await Amplify.addPlugins([auth, storage]);
    // Initialize the configured categories' plugins in our app
    await Amplify.configure(amplifyconfig);
  }
  catch (e) {
    safePrint(e);
  }

  runApp(ChangeNotifierProvider<UserTheme>(
    create: (context) => UserTheme(),
    child: const Root(),
  ));

}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    // Apply system theme
    Provider.of<UserTheme>(context,listen: false).toggleTheme(UserTheme.isDark);
    // Build material app
    return MaterialApp(
      title: "Franz",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "HomeScreen",
      routes: {
        // "SplashScreen": (context) => const Splash(),
        "WelcomeScreen": (context) => const Welcome(),
        "HomeScreen": (context) => const MyHomePage(title: "Franz"),
      }

    );
  }
}
