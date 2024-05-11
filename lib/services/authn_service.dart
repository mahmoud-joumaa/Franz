import 'package:amplify_flutter/amplify_flutter.dart';

/* ================================================================================================
User Sign Up
================================================================================================ */

signUpUser({required String username, required String password, required String email, required String preferredInstrument}) async {
  try {
    // Define user attributes (email, and preferred instrument)
    final userAttributes = {
      AuthUserAttributeKey.email: email,
      const CognitoUserAttributeKey.custom('preferred_instrument'): preferredInstrument,
    };
    // Await the sign up result from Amplify
    final result = await Amplify.Auth.signUp(username: username, password: password, options: SignUpOptions(userAttributes: userAttributes));
    return await _handleSignUpResult(result);
  }
  on AuthException catch (e) {
    return {
      "success": false,
      "message": e.message
    };
  }
}

_handleSignUpResult(SignUpResult result) async {
  switch (result.nextStep.signUpStep) {
    case AuthSignUpStep.confirmSignUp:
      final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
      return _handleCodeDelivery(codeDeliveryDetails);
    case AuthSignUpStep.done:
      return "done";
  }
}

_handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
  return {
    "success": true,
    "message": "A confirmation code has been sent to ${codeDeliveryDetails.destination}.\nPlease check your ${codeDeliveryDetails.deliveryMedium.name} for the code."
  };
  // COMBAK: Copy this
  // Alert.show(
  //   context,
  //   "A confirmation code has been sent to your inbox.",
  //   "Please verify your email on the next page.",
  //   UserTheme.isDark ? Colors.greenAccent[700]! : Colors.greenAccent[100]!,
  //   "ok"
  // );
}

confirmUser({required String username, required String confirmationCode}) async {
  try {
    final result = await Amplify.Auth.confirmSignUp(username: username, confirmationCode: confirmationCode);
    // Check if further confirmations are needed or if the sign up is complete.
    return await _handleSignUpResult(result);
  }
  on AuthException catch (e) {
    return {
      "success": false,
      "message": e.message
    };
    // COMBAK: Copy this
    // Alert.show(
    //   context,
    //   "An error has occurred while verifying $username.",
    //   e.message,
    //   UserTheme.isDark ? Colors.redAccent[700]! : Colors.redAccent[100]!,
    //   "dismiss"
    // );
  }
}

/* ================================================================================================
User Sign In
================================================================================================ */
