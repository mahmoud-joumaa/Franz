import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
Error handling
================================================================================================ */

class Error {
  static dynamic error = false;
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
