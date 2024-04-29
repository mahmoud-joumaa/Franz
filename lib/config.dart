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
  static const int white = 0xFFC3CCC8;
  static const int lightblue = 0xFFA0B4B1;
  static const int darkblue = 0xFF172426;
  static const int blue = 0xFF34444C;
  static const int brown = 0xFF50382A;
  static const int goldbrown = 0xFF6D5F39;
  static const int lightbrown = 0xFF7A6556;
  static const int pink = 0xFFCC947C;
  static const int gold = 0xFF94865A;
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
          color: backgroundColor ?? (UserTheme.isDark ? Colors.black : Colors.deepPurple),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        child: SpinKitFadingCircle(
          color: color ?? (UserTheme.isDark ? Colors.deepPurple : Colors.black),
          size: size ?? 50.0,
        ),
      ),
    );
  }
}
