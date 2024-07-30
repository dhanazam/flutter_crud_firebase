import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_pref/shared_pref.dart';

class AuthRepository {
  firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.standard();
  final SharedPreferencesManager _sharedPreferencesManager =
      SharedPreferencesManager();

  Stream<User> retrieveCurrentUser() {
    return _auth.authStateChanges().map((firebase_auth.User? user) {
      if (user != null) {
        return User(uid: user.uid, email: user.email);
      } else {
        return User(uid: "uid");
      }
    });
  }

  Future<firebase_auth.UserCredential?> signUp(User user) async {
    try {
      firebase_auth.UserCredential userCredential = await firebase_auth
          .FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email!, password: user.password!);
      return userCredential;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw firebase_auth.FirebaseAuthException(code: e.code, message: e.code);
    }
  }

  Future<firebase_auth.UserCredential?> signIn(User user) async {
    try {
      firebase_auth.UserCredential userCredential =
          await firebase_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
              email: user.email!, password: user.password!);
      return userCredential;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw firebase_auth.FirebaseAuthException(code: e.code, message: e.code);
    }
  }

  Future<firebase_auth.UserCredential?> signInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw firebase_auth.FirebaseAuthException(code: e.code, message: e.code);
    }
  }

  Future<void> signOut() async {
    await _sharedPreferencesManager.clearKey('user_id');
    return await firebase_auth.FirebaseAuth.instance.signOut();
  }

  Future<void> saveUID(String uid) async {
    _sharedPreferencesManager.putString('user_id', uid);
  }

  Future<String?> getUserId() async {
    return await _sharedPreferencesManager.getString('user_id');
  }
}
