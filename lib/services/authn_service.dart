import "package:amazon_cognito_identity_dart_2/cognito.dart";

// Base Entities ==================================================================================

class Cognito {
  static final userPool = CognitoUserPool("eu-west-1_a5q6JvKhI", "664t4be3lio5av3d46tbc0629j");
}

// Custom User Class ==============================================================================

class User {

  CognitoUser current;
  bool registrationConfirmed;
  AuthenticationDetails authDetails;
  CognitoUserSession? session;

  User({required this.current, required this.registrationConfirmed, required this.authDetails});

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
    final result = await authenticateUser(User(current: CognitoUser(username, Cognito.userPool), registrationConfirmed: false, authDetails: AuthenticationDetails(username: username, password: password)));
    if (result["success"]) {
      return {
        "success": true,
        "message": "Successfully registered as $username"
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
    if (result["success"]) {
      return {
        "success": true,
        "message": result["message"]
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
User Sign Out
================================================================================================ */

signOutCurrentUser(User user) async {
  await user.current.signOut();
  await user.current.globalSignOut(); // invalidates all issued tokens
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
    if (e.message == "User is not confirmed.") {
      return {
        "success": true,
        "message": "Logged in successfully as ${user.authDetails.username}\n\n${e.message}\nRemember to confirm your account on the settings screen :)"
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
