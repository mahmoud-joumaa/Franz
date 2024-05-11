import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:franz/global.dart';

/* ================================================================================================
User Sign Up
================================================================================================ */

Future<void> signUpUser({required String username, required String password, required String email, required String preferredInstrument}) async {
  try {
    // Define user attributes (email, username, and preferred instrument)
    final userAttributes = {
      AuthUserAttributeKey.email: email,
      AuthUserAttributeKey.preferredUsername: username,
      const CognitoUserAttributeKey.custom('preferred_instrument'): preferredInstrument,
    };
    // Await the sign up result from Amplify
    final result = await Amplify.Auth.signUp(username: username, password: password, options: SignUpOptions(userAttributes: userAttributes));
    await _handleSignUpResult(result);
  }
  on AuthException catch (e) {
    safePrint('Error signing up user: $e');
    Error.error = e;
  }
}

Future<void> _handleSignUpResult(SignUpResult result) async {
  switch (result.nextStep.signUpStep) {
    case AuthSignUpStep.confirmSignUp:
      final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
      _handleCodeDelivery(codeDeliveryDetails);
      break;
    case AuthSignUpStep.done:
      safePrint('Sign up is complete');
      break;
  }
}

void _handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
  safePrint(
    'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
    'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
  );
}

Future<void> confirmUser({required String username, required String confirmationCode}) async {
  try {
    final result = await Amplify.Auth.confirmSignUp(username: username, confirmationCode: confirmationCode);
    // Check if further confirmations are needed or if the sign up is complete.
    await _handleSignUpResult(result);
  }
  on AuthException catch (e) {
    safePrint('Error confirming user: ${e.message}');
    Error.error = e;
  }
}

/* ================================================================================================
User Sign In
================================================================================================ */
