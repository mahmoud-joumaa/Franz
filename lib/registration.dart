import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  // Styling vars
  final BorderSide tabBorder = const BorderSide(color: Colors.white, width: 2.5);

  // Toggle between the two tabs
  static bool? isLogin;

  @override
  void initState() { // TODO: Add authentication logic here
    super.initState();
    isLogin = true;
  }

  @override
  Widget build(BuildContext context) {

    // Form Inputs Start ==========================================================================

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
    final signupConfirmPassword = InputField(type: "password", controller: signUpConfirmPasswordController);

    // Form Inputs End ============================================================================

    return Scaffold(
      backgroundColor: Colors.orange[800],
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
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Your personal Automatic Music Transcriber!",
                        style: TextStyle(
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
                child: tab("login"),
              ),
              Positioned(
                top: 400,
                left: 0,
                child: tab("sign up"),
              ),
              // Login / Signup Forms
              Positioned(
                top: 150,
                bottom: 25,
                left: 65,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.orange[500]!,
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    // border: Border.all(color: Colors.white, width: 2.5),
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
                      SubmitButton(text: isLogin!?"Login":"Sign Up", type: isLogin!?"login":"signup"),
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

  Widget tab(String title) {
    title = title.toLowerCase();
    return GestureDetector(
      onTap: () { setState(() { isLogin = title=="login"; }); },
      child: RotatedBox(
        quarterTurns: 3,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          decoration: BoxDecoration(
            color: (isLogin! && title=="login") || (!isLogin! && title=="sign up") ? Colors.orange[500]! : Colors.orange[800]!,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
            // border: Border(
            //   top: (isLogin! && title=="login") || (!isLogin! && title=="sign up") ? tabBorder : BorderSide.none,
            //   left: (isLogin! && title=="login") || (!isLogin! && title=="sign up") ? tabBorder : BorderSide.none,
            //   right: (isLogin! && title=="login") || (!isLogin! && title=="sign up") ? tabBorder : BorderSide.none,
            // ),
          ),
          child: Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 35.0,
            ),
          )
        ),
      )
    );
  }

}

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
                    type=="password" ? const Icon(Icons.lock_outlined) :
                    null,
        suffixIcon: type=="password" ? IconButton(icon: _hidePassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off), onPressed: () {setState(() {_hidePassword = !_hidePassword;});}) : null,
        labelText: type!.substring(0,1).toUpperCase()+type.substring(1),
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2.0)),
      ),
      keyboardType: type=="email"?TextInputType.emailAddress:TextInputType.text,
      style: const TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      obscureText: type=="password"||type=="confirm password"?_hidePassword:false,
      obscuringCharacter: '*',
      autocorrect: false,
      enableSuggestions: false,
    );
  }
}

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
        if (type != "google") {
          // User Sign Up
          if (!_WelcomeState.isLogin!) {
            // TODO: Add authentication logic
            // Validate password
            // TODO: Add validation logic
            // No error
            // TODO: Add navigation logic
            // Error
            // TODO: Add catch error logic
          }
          // User login
          else {
            // TODO: Add authentication logic
            // No error
            // TODO: Add navigation logic
            // Error
            // TODO: Add catch error logic
          }
        }
        else {
          // TODO: Sign in with Google
        }
        setState(() {isLoading = false;});
        // await Future.delayed(const Duration(milliseconds: 500), _WelcomeState.clearInputs); FIXME: Add proper clearInputs() logic
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      ),
      child: Row(
        children: [
          Icon(type=="google"?MdiIcons.google:type=="login"?Icons.login:type=="signup"?Icons.login:null,
          ),
          Expanded(
            // child: isLoading ? Loading(color: UserTheme.isDark ? const Color(Palette.white) : const Color(Palette.black), backgroundColor: Colors.transparent, size: 20.0) : Text(text!, FIXME:  Add loading animation
            child: Text(text,
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
