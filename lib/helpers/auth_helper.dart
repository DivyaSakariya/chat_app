import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  AuthHelper._();

  static final AuthHelper authHelper = AuthHelper._();

  GetStorage getStorage = GetStorage();
  final _key = 'isLogged';

  bool userIsLogged() => getStorage.read(_key) ?? false;

  saveUserIsLogged(bool isDarkMode) {
    return getStorage.write(_key, isDarkMode);
  }

  GoogleSignIn google = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'operation-not-allowed':
          log("Unable to SignIn Anonymously");
          break;
        default:
          log("Exception: ${e.code}");
      }
      return false;
    }
  }

  registerUser({required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          log(e.code);
          break;
        case 'email-already-in-use':
          log(e.code);
          break;
        default:
          log(e.code);
      }
      return false;
    }
  }

  signInWithUserEmailPassword(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      log(e.code);
      return true;
    }
  }

  googleSignIn() async {
    GoogleSignInAccount? googleAccount = await google.signIn();

    GoogleSignInAuthentication googleAuthentication =
        await googleAccount!.authentication;

    AuthCredential authCredential = GoogleAuthProvider.credential(
      idToken: googleAuthentication.idToken,
      accessToken: googleAuthentication.accessToken,
    );

    FirebaseAuth.instance.signInWithCredential(authCredential);

    return googleAccount;
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    google.signOut();
  }
}
