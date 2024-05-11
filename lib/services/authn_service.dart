import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

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
  }
}

/* ================================================================================================
User Sign In
================================================================================================ */

signInUser(String username, String password) async {
  try {
    final result = await Amplify.Auth.signIn(username: username, password: password);
    return await _handleSignInResult(result, username);
  }
  on AuthException catch (e) {
    return {
      "success": false,
      "message": e.message
    };
  }
}

_handleSignInResult(SignInResult result, String username) async {
  switch (result.nextStep.signInStep) {
    case AuthSignInStep.confirmSignInWithSmsMfaCode:
      final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
      _handleCodeDelivery(codeDeliveryDetails);
      break;
    case AuthSignInStep.confirmSignInWithNewPassword:
      safePrint('Enter a new password to continue signing in');
      break;
    case AuthSignInStep.confirmSignInWithCustomChallenge:
      final parameters = result.nextStep.additionalInfo;
      final prompt = parameters['prompt']!;
      safePrint(prompt);
      break;
    case AuthSignInStep.resetPassword:
      final resetResult = await Amplify.Auth.resetPassword(
        username: username,
      );
      await _handleResetPasswordResult(resetResult);
      break;
    case AuthSignInStep.confirmSignUp:
      // Resend the sign up code to the registered device.
      final resendResult = await Amplify.Auth.resendSignUpCode(
        username: username,
      );
      _handleCodeDelivery(resendResult.codeDeliveryDetails);
      break;
    case AuthSignInStep.done:
      safePrint('Sign in is complete');
      break;
  }
}

/* ================================================================================================
User Sign Out
================================================================================================ */

Future<void> signOutCurrentUser() async {
  final result = await Amplify.Auth.signOut();
  if (result is CognitoCompleteSignOut) {
    return {
      "success": true,
      "message": "Signed out successfully"
    };
  }
  else if (result is CognitoFailedSignOut) {
    return {
      "success": false,
      "message": result.exception.message
    };
  }
}

/* ================================================================================================
MFA
================================================================================================ */

Future<void> setUpMFASignUp() async {
  try {
    final userAttributes = <AuthUserAttributeKey, String>{
      AuthUserAttributeKey.email: 'email@domain.com',
      // Note: phone_number requires country code
      AuthUserAttributeKey.phoneNumber: '+15559101234',
    };
    final result = await Amplify.Auth.signUp(
      username: 'myusername',
      password: 'mysupersecurepassword',
      options: SignUpOptions(userAttributes: userAttributes),
    );
    await _handleSignUpResult(result);
  } on AuthException catch (e) {
    safePrint('Error signing up: ${e.message}');
  }
}

Future<void> confirmMFAUser() async {
  try {
    final result = await Amplify.Auth.confirmSignIn(
      confirmationValue: '123456',
    );
    await _handleSignInResult(result);
  } on AuthException catch (e) {
    safePrint('Error confirming sign in: ${e.message}');
  }
}
