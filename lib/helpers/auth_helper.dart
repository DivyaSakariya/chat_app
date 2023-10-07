import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/helpers/firestore_helper.dart';
import 'package:firebase_chat_app/modals/person_modal.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  AuthHelper._();

  static final AuthHelper authHelper = AuthHelper._();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

  signInWithUserEmailPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      throw Exception(e.code);
    }
  }

  signUpWithUserEmailPassword(
      {required String email,
      required String password,
      required String name}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      FireStoreHelper.fireStoreHelper.addUser(
        personModal: PersonModal(
          email,
          name,
          password,
          [],
          {},
          {},
          'Online',
        ),
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      throw Exception(e.code);
    }
  }

  signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'operation-not-allowed':
          print("Unable to SignIn Anonymously");
          break;
        default:
          print("Exception: ${e.code}");
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
          print(e.code);
          break;
        case 'email-already-in-use':
          print(e.code);
          break;
        default:
          print(e.code);
      }
      return false;
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
