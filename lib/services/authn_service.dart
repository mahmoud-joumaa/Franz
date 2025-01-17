import "package:amazon_cognito_identity_dart_2/cognito.dart";
import "package:graphql_flutter/graphql_flutter.dart";
import 'package:http/http.dart' as http;

import "package:franz/pages/home/home.dart";
import "package:franz/services/api_service.dart";

// Base Entities ==================================================================================

class Cognito {
  static final userPool = CognitoUserPool("eu-west-1_a5q6JvKhI", "664t4be3lio5av3d46tbc0629j");
}

// Custom User Class ==============================================================================

class User {

  bool isLoggedIn = false;

  // Cognito Authentication
  CognitoUser current;
  bool registrationConfirmed;
  AuthenticationDetails authDetails;
  CognitoUserSession? session;
  String? token;

  // Custom Attributes
  String? email;
  String? profileUrl;
  String? preferredInstrument;

  // Constructor
  User({required this.current, required this.registrationConfirmed, required this.authDetails});

  // toString() to print for debugging purposes
  @override
  String toString() {
    return "[Username]: ${authDetails.username}\n\t[Email]: $email\n\t[Profile URL]: $profileUrl\n\t[Preferred Instrument]: $preferredInstrument";
  }

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
  // Email already exists error (configured as a lambda pre-sign up trigger)
  catch (e) {
    return {
      "success": false,
      "message": e.toString()
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
  // await user.current.globalSignOut(); // IDEA: invalidates all issued tokens
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
      "message": "You can now log in to your account!"
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
    // Delete user data on dynamo and s3 (make sure to get the most recent list of transcriptions first)
    GraphQLClient client = DynamoGraphQL.initializeClient();
    final getUserTranscriptions = """query listTranscriptions {
      listTranscriptions(filter: {account_id: {eq: "${MyHomePage.user!.authDetails.username}"}}) {
        items {
          account_id
          transcription_id
        }
      }
    }""";
    final queryResult = await client.query(QueryOptions(document: gql(getUserTranscriptions)));
    final transcriptions = queryResult.data!['listTranscriptions']?['items'];
    for (final transcription in transcriptions) {
      final url = Uri.parse('https://lhflvireis7hjn2rrqq45l37wi0ajcbp.lambda-url.eu-west-1.on.aws/?account_id=${Uri.encodeComponent(transcription["account_id"])}&transcription_id=${Uri.encodeComponent(transcription["transcription_id"])}');
      http.get(url);
    }
    // Delete user account on cognito
    await user.current.deleteUser();
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
  catch (e) { // Errors triggered from the invoked lambda
    return {
      "success": false,
      "message": e.toString()
    };
  }
}
