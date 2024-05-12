// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

/* ================================================================================================
Custom User Class
================================================================================================ */

class User {
  static AuthUser? current;
  static Map<AuthUserAttributeKey, dynamic>? attributes;
}

/* ================================================================================================
User Theme
================================================================================================ */

class UserTheme extends ChangeNotifier {
  static bool isDark = false;
  bool isDarkNotify = isDark;
  toggleTheme(bool flag) {
    isDark = flag;
    isDarkNotify = flag;
    return notifyListeners();
  }
}

// Color Palette ==================================================================================

class Palette {
  static const int darkgrey = 0xFF6b705c;
  static const int grey = 0xFFb7b7a4;
  static const int brown = 0xFF825f45;
  static const int lightbrown = 0xFF997b66;
  static const int green = 0xFF797d62;
  static const int orange = 0xFFd08c60;
  static const int yellow = 0xFFffcb69;
}

/* ================================================================================================
Dialog Pop Up
================================================================================================ */

class Alert {
  static show(context, String title, content, Color backgroundColor, String type) {
    type = type.toLowerCase(); // For comparison checks
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        backgroundColor: backgroundColor,
        actions: [
          TextButton(
            child: Text(type.toUpperCase()),
            onPressed: () async {
              switch (type) {
                case "exit":
                  await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
                  break;
                case "login":
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, "HomeScreen");
                  break;
                case "logout":
                  Navigator.pushReplacementNamed(context, "WelcomeScreen");
                  break;
                default:
                  Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }
}

/* ================================================================================================
Loading Animation
================================================================================================ */

class Loading extends StatelessWidget {

  final Color? backgroundColor;
  final Color? color;
  final double? size;

  const Loading({super.key, this.backgroundColor, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? (UserTheme.isDark ? Colors.black : const Color(Palette.orange)),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        child: SpinKitFadingCircle(
          color: color ?? (UserTheme.isDark ? const Color(Palette.orange) : Colors.black),
          size: size ?? 50.0,
        ),
      ),
    );
  }
}
