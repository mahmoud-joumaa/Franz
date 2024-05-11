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
    "message": "A confirmation code has been sent to ${codeDeliveryDetails.destination}.\nPlease check your ${codeDeliveryDetails.deliveryMedium.name} for the code to verify your account on the profile page."
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
    return _handleSignInResult(result);
  }
  on AuthException catch (e) {
    return {
      "success": false,
      "message": e.message
    };
  }
}

_handleSignInResult(SignInResult result) async {
  switch (result.nextStep.signInStep) {
    case AuthSignInStep.done:
      return {
        "success": true,
        "message": "Sign In Successful"
      };
    case AuthSignInStep.confirmSignUp:
      return {
        "success": true,
        "message": "Sign In Successful\nRemember to verify your account on the profile page :)"
      };
    default:
      return {
        "success": false,
        "message": "This sign in method is not supported"
      };
  }
}

/* ================================================================================================
User Sign Out
================================================================================================ */

signOutCurrentUser() async {
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

// COMBAK: Add optional MFA
