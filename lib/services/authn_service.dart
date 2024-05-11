import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:franz/global.dart';

/* ================================================================================================
User Sign Up
================================================================================================ */

Future<void> signUpUser(context, {required String username, required String password, required String email, required String preferredInstrument}) async {
  try {
    // Define user attributes (email, and preferred instrument)
    final userAttributes = {
      AuthUserAttributeKey.email: email,
      const CognitoUserAttributeKey.custom('preferred_instrument'): preferredInstrument,
    };
    // Await the sign up result from Amplify
    final result = await Amplify.Auth.signUp(username: username, password: password, options: SignUpOptions(userAttributes: userAttributes));
    await _handleSignUpResult(context, result);
  }
  on AuthException catch (e) {
    Alert.show(
      context,
      "An error has occurred while creating $username.",
      e.message,
      UserTheme.isDark ? Colors.redAccent[700] : Colors.redAccent[100],
      "dismiss"
    );
  }
}

Future<void> _handleSignUpResult(context, SignUpResult result) async {
  switch (result.nextStep.signUpStep) {
    case AuthSignUpStep.confirmSignUp:
      final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
      _handleCodeDelivery(context, codeDeliveryDetails);
      break;
    case AuthSignUpStep.done:
        Alert.show(
        context,
        "Sign-up completed successfully.",
        result,
        UserTheme.isDark ? Colors.greenAccent[700] : Colors.greenAccent[100],
        "dismiss"
      );
      break;
  }
}

void _handleCodeDelivery(context, AuthCodeDeliveryDetails codeDeliveryDetails) {
  safePrint(
    'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
    'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
  );
  Alert.show(
    context,
    "A confirmation code has been sent to your inbox.",
    "Please verify your email on the next page.",
    UserTheme.isDark ? Colors.greenAccent[700] : Colors.greenAccent[100],
    "ok"
  );
}

Future<void> confirmUser(context, {required String username, required String confirmationCode}) async {
  try {
    final result = await Amplify.Auth.confirmSignUp(username: username, confirmationCode: confirmationCode);
    // Check if further confirmations are needed or if the sign up is complete.
    await _handleSignUpResult(context, result);
  }
  on AuthException catch (e) {
    Alert.show(
      context,
      "An error has occurred while verifying $username.",
      e.message,
      UserTheme.isDark ? Colors.redAccent[700] : Colors.redAccent[100],
      "dismiss"
    );
  }
}

/* ================================================================================================
User Sign In
================================================================================================ */
