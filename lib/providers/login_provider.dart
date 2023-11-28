import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential? userLogged;
  User? user;

  bool isLogin = false;
  bool isRegister = false;
  bool isLoading = false;
  List<bool> selectedEvent = [false, false];

  bool accesGranted = false;
  String errorMessage = '';

  LoginProvider();

  loginOrRegister(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      if (isRegister) {
        userLogged = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      } else if (isLogin) {
        userLogged = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      }
      user = userLogged!.user;
    } catch (error) {
      //print(getMessageFromErrorCode(error));
      errorMessage = getMessageFromErrorCode(error);
      notifyListeners();
    }
    isLoading = false;
    accesGranted = user != null;
    notifyListeners();
  }

  void logOut() {
    userLogged = null;
    user = null;
    accesGranted = false;
    isLogin = false;
    isRegister = false;
    errorMessage = '';
    selectedEvent = [false, false];
  }

  void opcioMenu(int index) {
    for (int i = 0; i < selectedEvent.length; i++) {
      selectedEvent[i] = i == index;
    }
    if (index == 0) {
      isLogin = true;
      isRegister = false;
    } else {
      isLogin = false;
      isRegister = true;
    }
    notifyListeners();
  }

  bool get isLoginOrRegister {
    return isLogin || isRegister;
  }
}

String getMessageFromErrorCode(errorCode) {
  switch (errorCode.code) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return "Email already used. Go to login page.";
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return "Wrong email/password combination.";
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      return "No user found with this email.";
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      return "User disabled.";
    case "ERROR_TOO_MANY_REQUESTS":
    case "operation-not-allowed":
      return "Too many requests to log into this account.";
    case "ERROR_OPERATION_NOT_ALLOWED":
    case "operation-not-allowed":
      return "Server error, please try again later.";
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      return "Email address is invalid.";
    case "INVALID_LOGIN_CREDENTIALS":
      return "Invalid credentials.";
    default:
      return "Login failed. Please try again.";
  }
}
