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
