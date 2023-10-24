// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'auth_results_status.dart';

class AuthExceptionHandler {
  static handleException(e) {
    print(e.code);
    var status;
    switch (e.code) {
      case "invalid-email":
        status = AuthResultStatus.invalidEmail;
        break;
      // case "invalid-password":
      //   status = AuthResultStatus.wrongPassword;
      //   break;
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "INVALID_LOGIN_CREDENTIALS":
        status = AuthResultStatus.invalidLoginCredentials;
        break;
      case "too-many-requests":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "operation-not-allowed":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "email-already-exists":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  ///
  /// Accepts AuthExceptionHandler.errorType
  ///
  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "The email address is badly formatted.";
        break;
      case AuthResultStatus.invalidLoginCredentials:
        errorMessage = "Wrong Username or Password.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      // case AuthResultStatus.wrongPassword:
      //   errorMessage = "Your password is wrong.";
      //   break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this email doesn't exist.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
            "The email has already been registered. Please login or reset your password.";
        break;
      default:
        errorMessage = "An undefined Error happened";
    }

    return errorMessage;
  }
}
