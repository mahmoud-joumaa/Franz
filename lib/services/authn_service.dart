import "package:amazon_cognito_identity_dart_2/cognito.dart";

import "package:franz/pages/home/home.dart";

// Base Entities ==================================================================================

class Cognito {
  static final userPool = CognitoUserPool("eu-west-1_a5q6JvKhI", "664t4be3lio5av3d46tbc0629j");
}

// Custom User Class ==============================================================================

class User {

  bool isLoggedIn = false;

  CognitoUser current;
  bool registrationConfirmed;
  AuthenticationDetails authDetails;
  CognitoUserSession? session;
  String? token;

  User({required this.current, required this.registrationConfirmed, required this.authDetails});

}

class UserData {

  final bool isLoggedIn;
  final CognitoUser current;
  final bool registrationConfirmed;
  final AuthenticationDetails authDetails;
  final CognitoUserSession session;
  final String token;

  UserData(this.isLoggedIn, this.current, this.registrationConfirmed, this.authDetails, this.session, this.token);

}

/* ================================================================================================
User Sign Up
================================================================================================ */

signUpUser({required username, required email, required password}) async {
  try {
    final userAttributes = [
      AttributeArg(name: "email", value: email),
      const AttributeArg(name: "profile", value: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQb5ay974Ak1bGFIDStEQaYK7qK60bzbbmczDft-ao-Xw&s"),
      const AttributeArg(name: "custom:preferred_instrument", value: "None")
    ];
    await Cognito.userPool.signUp(username, password, userAttributes: userAttributes);
    final result = await signInUser(User(current: CognitoUser(username, Cognito.userPool), registrationConfirmed: false, authDetails: AuthenticationDetails(username: username, password: password)));
    if (result["success"]) {
      return {
        "success": true,
        "message": "Successfully registered as $username\n\n${result.message}"
      };
    }
    else {
      return {
        "success": false,
        "message": result["message"]
      };
    }
  }
  on CognitoClientException catch (e) {
    return {
      "success": false,
      "message": e.message
    };
  }
}

/* ================================================================================================
User Sign In
================================================================================================ */

signInUser(User user) async {
  try {
    final result = await authenticateUser(user);
    if (result["success"] == true) {
      // Inittialize the user object
      MyHomePage.user = User(current: user.current, registrationConfirmed: user.registrationConfirmed, authDetails: user.authDetails);
      MyHomePage.user!.isLoggedIn = true;
      MyHomePage.user!.session = result["session"];
      MyHomePage.user!.token = result["token"];
    }
    return {
      "success": result["success"],
      "message": result["message"]
    };
  }
  on CognitoClientException catch (e) {
    return {
      "success": false,
      "message": e.message
    };
  }
}

/* ================================================================================================
User Sign Out
================================================================================================ */

signOutCurrentUser(User user) async {
  await user.current.signOut();
  await user.current.globalSignOut(); // invalidates all issued tokens
  MyHomePage.user = null;
  return {
    "success": true,
    "message": "${user.authDetails.username} signed out successfully"
  };
}

/* ================================================================================================
User Verification
================================================================================================ */

authenticateUser(User user) async {
  try {
    final session = await user.current.authenticateUser(user.authDetails);
    return {
      "success": true,
      "message": "Logged in successfully as ${user.authDetails.username}",
      "session": session,
      "token": session!.getAccessToken().getJwtToken()
    };
  }
  on CognitoUserNewPasswordRequiredException catch (e) {
    // handle New Password challenge
    return {
      "success": false,
      "message": e.message
    };
  }
  on CognitoUserMfaRequiredException catch (e) {
    // handle SMS_MFA challenge
    return {
      "success": false,
      "message": e.message
    };
  }
  on CognitoUserSelectMfaTypeException catch (e) {
    // handle SELECT_MFA_TYPE challenge
    return {
      "success": false,
      "message": e.message
    };
  }
  on CognitoUserMfaSetupException catch (e) {
    // handle MFA_SETUP challenge
    return {
      "success": false,
      "message": e.message
    };
  }
  on CognitoUserTotpRequiredException catch (e) {
    // handle SOFTWARE_TOKEN_MFA challenge
    return {
      "success": false,
      "message": e.message
    };
  }
  on CognitoUserCustomChallengeException catch (e) {
    // handle CUSTOM_CHALLENGE challenge
    return {
      "success": false,
      "message": e.message
    };
  }
  on CognitoUserConfirmationNecessaryException catch (e) {
    // handle User Confirmation Necessary
    return {
      "success": false,
      "message": e.message
    };
  }
  on CognitoClientException catch (e) {
    // handle user is not confirmed error
    if (e.message!.contains("User is not confirmed.")) {
      return {
        "success": false,
        "message": "Welcome, ${user.authDetails.username}\n\n${e.message}\nYou have not confirmed your email yet. To do so, please enter the verification code sent to your email address on the following screen.\nIf you've lost the code, choose the \"resend code\" option.\nIf you've entered the wrong email address, kindly send an email to franz.transcriber@gmail.com with the subject line \"Change Email Address For Verification\". Be sure to include your username and the new email address in the email body.\nOnce you've entered the code, please wait patiently while the brief verification finalizes :)"
      };
    }
    // handle Wrong Username and Password and Cognito Client
    return {
      "success": false,
      "message": e.message
    };
  }
}

// User Attributes ================================================================================

fetchUserAttributes(User user) async {
  try {
    final attributes = await user.current.getUserAttributes();
    return {
      "success": true,
      "attributes": attributes
    };
  }
  on CognitoClientException catch (e) {
    return {
      "success": false,
      "message": e.message
    };
  }
}

updateUserAttribute(User user, String attributeName, String attributeValue) async {
  try {
    await user.current.updateAttributes([CognitoUserAttribute(name: attributeName, value: attributeValue)]);
    return {
      "success": true,
      "message": "$attributeName update to $attributeValue successfullly"
    };
  }
  on CognitoClientException catch (e) {
    return {
      "success": false,
      "message": e.message
    };
  }
}

changePassword(User user, String oldPassword, String newPassword) async {
  try {
    await user.current.changePassword(oldPassword, newPassword);
    return {
      "success": true,
      "message": "Changed password successfully"
    };
  }
  on CognitoClientException catch (e) {
    return {
      "success": false,
      "message": e.message
    };
  }
}

// Confirmation & MFA =============================================================================

confirmUser(User user, String confirmationCode) async {
  try {
    user.registrationConfirmed = await user.current.confirmRegistration(confirmationCode);
    return {
      "success": true,
      "message": "Confirmation Successful!"
    };
  }
  on CognitoClientException catch (e) {
    return {
      "success": false,
      "message": e.message
    };
  }
}

resendConfirmationCode(User user) async {
  try {
    await user.current.resendConfirmationCode();
    return {
      "success": true,
      "message": "Please check your spam and junk folders if the code is not present in your inbox."
    };
  }
  on CognitoClientException catch (e) {
    return {
      "success": false,
      "message": e.message
    };
  }
}

// Delete a user & corresponding data =============================================================

deleteUser(User user) async {
  try {
    await user.current.deleteUser();
    // TODO: invoke delete lambda here
    return {
      "success": true,
      "message": "${user.authDetails.username} deleted successfully"
    };
  }
  on CognitoClientException catch (e) {
    return {
      "success": false,
      "message": e.message
    };
  }
}
