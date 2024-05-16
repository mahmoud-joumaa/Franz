// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:franz/services/authn_service.dart';

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
Dialog Pop Ups
================================================================================================ */

class Alert {

  static show(context, String title, content, Color backgroundColor, String type, [User? user]) {
    type = type.toLowerCase(); // For comparison checks
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title, style: TextStyle(color: UserTheme.isDark ? Colors.white : Colors.black)),
        content: Text(content, style: TextStyle(color: UserTheme.isDark ? Colors.white : Colors.black)),
        backgroundColor: backgroundColor,
        actions: [
          TextButton(
            child: Text(type.toUpperCase(), style: TextStyle(color: UserTheme.isDark ? Colors.white : Colors.black)),
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
                case "verify":
                  Navigator.of(context).pop();
                  Alert.confirmCode(context, title, backgroundColor, user!);
                default:
                  Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }

  static confirmCode(context, String title, Color backgroundColor, User user) {
    TextEditingController codeController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title, style: TextStyle(color: UserTheme.isDark ? Colors.white : Colors.black)),
        backgroundColor: backgroundColor,
        content: TextField(
          controller: codeController,
          autocorrect: false,
          enableSuggestions: false,
          obscureText: false,
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  TextButton(
                    child: Text("Resend Code", style: TextStyle(color: UserTheme.isDark ? Colors.white : Colors.black)),
                    onPressed: () async {
                      Alert.load(context);
                      final result = await resendConfirmationCode(user);
                      Navigator.of(context).pop();
                      if (result["success"]) {
                        Alert.show(
                          context,
                          "Confirmation code successfully resent.",
                          result["message"],
                          UserTheme.isDark ? Colors.greenAccent[700]! : Colors.greenAccent[300]!,
                          "dismiss"
                        );
                      }
                      else {
                        Alert.show(
                          context,
                          "An error has occurred while resending the confirmation code.\nPlease try again later.",
                          result["message"],
                          UserTheme.isDark ? Colors.redAccent[700]! : Colors.redAccent[300]!,
                          "ok"
                        );
                      }
                    }
                  ),
                  TextButton(
                    child: Text("Confirm Code", style: TextStyle(color: UserTheme.isDark ? Colors.white : Colors.black)),
                    onPressed: () async {
                      Alert.load(context);
                      final result = await confirmUser(user, codeController.text);
                      if (result["success"]) {
                        await signInUser(user);
                        Navigator.of(context).pop();
                        Alert.show(
                          context,
                          "Successfully verified ${user.authDetails.username}",
                          result["message"],
                          UserTheme.isDark ? Colors.greenAccent[700]! : Colors.greenAccent[300]!,
                          "login"
                        );
                      }
                      else {
                        Navigator.of(context).pop();
                        Alert.show(
                          context,
                          "An error has occurred while verifying ${user.authDetails.username}",
                          result["message"],
                          UserTheme.isDark ? Colors.redAccent[700]! : Colors.redAccent[300]!,
                          result["message"].contains("An account with the email already exists.") ? "try with a different email" : "dismiss"
                        );
                      }
                    }
                  ),
                ],
              ),
              TextButton(
                  child: Text("Dismiss", style: TextStyle(color: UserTheme.isDark ? Colors.white : Colors.black)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
              ),
            ],
          ),
        ]
      )
    );
  }

  static load(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const AlertDialog(
        backgroundColor: Colors.transparent,
        content: SizedBox(
          height: 50.0,
          width: 50.0,
          child: Loading(backgroundColor: Colors.white, color: Colors.deepPurple)
        ),
      )
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
          color: backgroundColor ?? Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        child: SpinKitFadingCircle(
          color: color ?? (UserTheme.isDark ? Colors.deepPurple[200] : Colors.deepPurple[800]),
          size: size ?? 50.0,
        ),
      ),
    );
  }
}

/* ================================================================================================
Map Classes to Instruments
================================================================================================ */

class Instruments {
  static Map<String, List<String>> midiInstruments = {
    "Piano": [
      "Acoustic Grand Piano",
      "Bright Acoustic Piano",
      "Electric Grand Piano",
      "Honky-tonk Piano",
      "Electric Piano 1",
      "Electric Piano 2",
      "Harpsichord",
      "Clavinet",
    ],
    "Chromatic Percussion": [
      "Celesta",
      "Glockenspiel",
      "Music Box",
      "Vibraphone",
      "Marimba",
      "Xylophone",
      "Tubular Bells",
      "Dulcimer",
    ],
    "Organ": [
      "Drawbar Organ",
      "Percussive Organ",
      "Rock Organ",
      "Church Organ",
      "Reed Organ",
      "Accordion",
      "Harmonica",
      "Tango Accordion",
    ],
    "Guitar": [
      "Acoustic Guitar (nylon)",
      "Acoustic Guitar (steel)",
      "Electric Guitar (jazz)",
      "Electric Guitar (clean)",
      "Electric Guitar (muted)",
      "Overdriven Guitar",
      "Distortion Guitar",
      "Guitar Harmonics",
    ],
    "Bass": [
      "Acoustic Bass",
      "Electric Bass (finger)",
      "Electric Bass (pick)",
      "Fretless Bass",
      "Slap Bass 1",
      "Slap Bass 2",
      "Synth Bass 1",
      "Synth Bass 2",
    ],
    "Strings": [
      "Violin",
      "Viola",
      "Cello",
      "Contrabass",
      "Tremolo Strings",
      "Pizzicato Strings",
      "Orchestral Harp",
      "Timpani",
    ],
    "Ensemble": [
      "String Ensemble 1",
      "String Ensemble 2",
      "SynthStrings 1",
      "SynthStrings 2",
      "Choir Aahs",
      "Voice Oohs",
      "Synth Voice",
      "Orchestra Hit",
    ],
    "Brass": [
      "Trumpet",
      "Trombone",
      "Tuba",
      "Muted Trumpet",
      "French Horn",
      "Brass Section",
      "SynthBrass 1",
      "SynthBrass 2",
    ],
    "Reed": [
      "Soprano Sax",
      "Alto Sax",
      "Tenor Sax",
      "Baritone Sax",
      "Oboe",
      "English Horn",
      "Bassoon",
      "Clarinet",
    ],
    "Pipe": [
      "Piccolo",
      "Flute",
      "Recorder",
      "Pan Flute",
      "Blown Bottle",
      "Shakuhachi",
      "Whistle",
      "Ocarina",
    ],
    "Synth Lead": [
      "Lead 1 (square)",
      "Lead 2 (sawtooth)",
      "Lead 3 (calliope)",
      "Lead 4 (chiff)",
      "Lead 5 (charang)",
      "Lead 6 (voice)",
      "Lead 7 (fifths)",
      "Lead 8 (bass + lead)",
    ],
    "Synth Pad": [
      "Pad 1 (new age)",
      "Pad 2 (warm)",
      "Pad 3 (polysynth)",
      "Pad 4 (choir)",
      "Pad 5 (bowed)",
      "Pad 6 (metallic)",
      "Pad 7 (halo)",
      "Pad 8 (sweep)",
    ],
    "Synth Effects": [
      "FX 1 (rain)",
      "FX 2 (soundtrack)",
      "FX 3 (crystal)",
      "FX 4 (atmosphere)",
      "FX 5 (brightness)",
      "FX 6 (goblins)",
      "FX 7 (echoes)",
      "FX 8 (sci-fi)",
    ],
    "Ethnic": [
      "Sitar",
      "Banjo",
      "Shamisen",
      "Koto",
      "Kalimba",
      "Bag pipe",
      "Fiddle",
      "Shanai",
    ],
    "Percussive": [
      "Tinkle Bell",
      "Agogo",
      "Steel Drums",
      "Woodblock",
      "Taiko Drum",
      "Melodic Tom",
      "Synth Drum",
      "Reverse Cymbal",
    ],
    "Sound Effects": [
      "Guitar Fret Noise",
      "Breath Noise",
      "Seashore",
      "Bird Tweet",
      "Telephone Ring",
      "Helicopter",
      "Applause",
      "Gunshot",
    ],
  };

}
