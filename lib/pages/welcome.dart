// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:franz/global.dart';
import 'package:franz/amplifyconfiguration.dart';
import 'package:franz/services/authn_service.dart';

// COMBAK: Fix the color scheme of the page

// Form Inputs Start ==============================================================================

final TextEditingController loginEmailController = TextEditingController();
final TextEditingController loginPasswordController = TextEditingController();
final TextEditingController signUpUsernameController = TextEditingController();
final TextEditingController signUpEmailController = TextEditingController();
final TextEditingController signUpPasswordController = TextEditingController();
final TextEditingController signUpConfirmPasswordController = TextEditingController();

final loginUsername = InputField(type: "username", controller: loginEmailController);
final loginPassword = InputField(type: "password", controller: loginPasswordController);
final signupUsername = InputField(type: "username", controller: signUpUsernameController);
final signupEmail = InputField(type: "email", controller: signUpEmailController);
final signupPassword = InputField(type: "password", controller: signUpPasswordController);
final signupConfirmPassword = InputField(type: "confirm password", controller: signUpConfirmPasswordController);

// Form Inputs End ================================================================================

// Welcome Page Start =============================================================================
class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  static bool? isLogin; // Toggle between the two tabs (login & sign up)
  dynamic configureError; // Assume no errors by default :)

  @override
  void initState() {
    super.initState();
    _configureAmplify();
    isLogin = true; // default the registration form to "login" instead of "signup"
  }

  // Configure Amplify w/ any plugins necessary
  Future<void> _configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);
      // Initialize the configured categories' plugins in our app
      await Amplify.configure(amplifyconfig);
    }
    catch (e) {
      configureError = e;
    }
  }

  @override
  Widget build(BuildContext context) {

    if (configureError) {
      Alert.show(
        context,
        "An error has occurred while initializing the application. Please try again later.",
        configureError,
        UserTheme.isDark ? Colors.redAccent[700] : Colors.redAccent[100],
        "exit"
      );
    }

    return Scaffold(
      backgroundColor: UserTheme.isDark ? const Color(Palette.brown) : const Color(Palette.lightbrown),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Stack(
            children: [
              // Title Header
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10.0, 35.0, 10.0, 5.0),
                  child: const Column(
                    children: [
                      // FIXME: add logo to pubspec.yml
                      // Image.asset("assets/Franz.jpg", height: 65.0, width: 65.0),
                      Text("Franz",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Your personal Automatic Music Transcriber!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Login & Signup Tabs
              Positioned(
                top: 200,
                left: 0,
                child: generateTab("login"),
              ),
              Positioned(
                top: 400,
                left: 0,
                child: generateTab("sign up"),
              ),
              // Login / Signup Forms
              Positioned(
                top: 150,
                bottom: 25,
                left: 65,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                    color: Color(Palette.orange),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ListView(
                          physics: const ClampingScrollPhysics(),
                          children: isLogin! ?
                          [
                            loginUsername,
                            loginPassword,
                          ] :
                          [
                            signupUsername,
                            signupEmail,
                            signupPassword,
                            signupConfirmPassword,
                          ],
                        ),
                      ),
                      SubmitButton(text: isLogin!?"Login with Email":"Sign Up with Email", type: isLogin!?"login":"signup"),
                      const SubmitButton(text: "Connect with Google", type: "google"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tab widget
  Widget generateTab(String title) {
    title = title.toLowerCase(); // Lowercase string for comparison
    return GestureDetector(
      onTap: () { setState(() { isLogin = title=="login"; }); },
      child: RotatedBox(
        quarterTurns: 3,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          decoration: BoxDecoration(
            color: (isLogin! && title=="login") || (!isLogin! && title=="sign up") ? const Color(Palette.orange) : Colors.transparent,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
          ),
          child: Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: (isLogin! && title=="login") || (!isLogin! && title=="sign up") ? Colors.black : Colors.white,
              fontSize: 35.0,
            ),
          )
        ),
      )
    );
  }

}
// Welcome Page End ===============================================================================

// Form Inputs Start ==============================================================================
class InputField extends StatefulWidget {

  final String? type;
  final TextEditingController? controller;

  const InputField({super.key, this.type, this.controller});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {

  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {

    final controller = widget.controller;
    final type = widget.type;

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: type=="username" ? const Icon(Icons.account_circle_outlined) :
                    type=="email" ? const Icon(Icons.email_outlined) :
                    type=="password" || type=="confirm password" ? const Icon(Icons.lock_outlined) :
                    null,
        suffixIcon: type=="password" || type=="confirm password" ? IconButton(icon: _hidePassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off), onPressed: () {setState(() {_hidePassword = !_hidePassword;});}) : null,
        labelText: type!.substring(0,1).toUpperCase()+type.substring(1),
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.0)),
      ),
      keyboardType: type=="email" ? TextInputType.emailAddress : TextInputType.text,
      style: const TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      obscureText: type=="password"||type=="confirm password"?_hidePassword:false,
      obscuringCharacter: '*',
      autocorrect: false,
      enableSuggestions: false,
    );
  }
}
// Form Inputs End ================================================================================

// Submit Buttons Start ===========================================================================
class SubmitButton extends StatefulWidget {

  final String? text;
  final String? type;

  const SubmitButton({super.key, this.text, this.type});

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    final String text = widget.text!;
    final String type = widget.type!;

    return ElevatedButton(
      onPressed: () async {
        setState(() {isLoading = true;});
        try {
          if (type != "google") { // i.e. sign up with AWS Cognito
            // User Sign Up w/ email
            if (!_WelcomeState.isLogin!) {
              // Validate password
              if (signUpPasswordController.text != signUpConfirmPasswordController.text) {
                Alert.show(
                  context,
                  "An error has occurred while creating ${signUpUsernameController.text}.",
                  "Passwords don't match",
                  UserTheme.isDark ? Colors.redAccent[700] : Colors.redAccent[100],
                  "dismiss"
                );
              }
              else {
                await signUpUser(context, username: signUpUsernameController.text, password: signUpPasswordController.text, email: signUpEmailController.text, preferredInstrument: "");
                // No Error (error handled in try/catch block)
                Navigator.pushReplacementNamed(context, "HomeScreen");
              }
            }
            // User login w/ email
            else {
              // TODO: Add authentication logic
              // No error
              // COMBAK: Add proper navigation logic
              Navigator.pushReplacementNamed(context, "HomeScreen");
              // Error
              // TODO: Add catch error logic
            }
          }
          // Login w/ Google
          else {
            // IDEA: Sign in with Google
          }
        }
        catch (e) {
          Alert.show(
            context,
            "An error has occurred.",
            e,
            UserTheme.isDark ? Colors.redAccent[700] : Colors.redAccent[100],
            "dismiss"
          );
        }
        await Future.delayed(const Duration(milliseconds: 500), () {}); // Have a slight buffer between changes
        setState(() {isLoading = false;});
        // await Future.delayed(const Duration(milliseconds: 500), _WelcomeState.clearInputs); FIXME: Add proper clearInputs() logic
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(const Color(Palette.yellow)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      ),
      child: Row(
        children: [
          Icon(type=="google"?MdiIcons.google:type=="login"?Icons.login:type=="signup"?Icons.login:null,
          ),
          Expanded(
            child: isLoading ? const Loading(color: Colors.black, backgroundColor: Colors.transparent, size: 20.0) : Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.0,
              )
            ),
          ),
        ],
      ),
    );
  }
}
// Submit Buttons End =============================================================================
