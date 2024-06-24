import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:observerit/core/exceptions/AuthException.dart';
import 'package:observerit/entities/RegisterFormInputs.dart';
import 'package:observerit/entities/User.dart';
import 'package:observerit/shared/widgets/Dialog/LoadingDialog.dart';

class AuthService {

  FirebaseAuth firebaseInstance = FirebaseAuth.instance;
  GoogleSignIn googleAuth = GoogleSignIn();

  Future<void> createUser(RegisterFormInputs inputForm) async {
    try {
      UserCredential result = await firebaseInstance.createUserWithEmailAndPassword(email: inputForm.email!, password: inputForm.password!);

      final fuser = result.user;
      fuser!.updateDisplayName(inputForm.username);

    } catch (error) {
      if (error.toString() == '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        throw const AuthException('The email address is already in use by another account.');
      }
      throw const AuthException('Unexpected error to create User');
    }
  }

  Future<GoogleSignInAuthentication?> authByGoogle() async{
    try{
      GoogleSignInAccount? user = await this.googleAuth.signIn();
      GoogleSignInAuthentication? googleAuth = await user?.authentication;
      return googleAuth;
    } catch (error) {
      print(error);
    }
  }

  Future<UserObserverIt> loginByGoogle(GoogleSignInAuthentication? googleAuth) async {
    try {

      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential result = await firebaseInstance.signInWithCredential(credential);

      return UserObserverIt.fromJson({
        "username": result.user?.displayName != null ? result.user!.displayName : 'ObserverIt_User',
        "imageUrl": result.user?.photoURL,
        "id": result.user?.uid,
        "email": result.user?.email,
        "isFromGoogleAuth": true
      });
    } catch (error) {
      throw const AuthException('Error to login');
    }
  }

  Future<UserObserverIt> login(String login, String password) async {
    try {
      UserCredential result = await firebaseInstance.signInWithEmailAndPassword(email: login, password: password);

      final fuser = result.user;

      return UserObserverIt.fromJson({
        "username": fuser?.displayName != null ? fuser!.displayName : 'ObserverIt_User',
        "imageUrl": fuser?.photoURL,
        "id": fuser?.uid,
        "email": fuser?.email,
        "isFromGoogleAuth": false
      });
    } catch (error) {
      if (error.toString() == "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.") {
        throw const AuthException("Invalid credentials, your password may be wrong, or the account does not exist");
      } else if (error.toString() == "[firebase_auth/invalid-email] The email address is badly formatted.") {
        throw const AuthException("Unable to login, invalid email!");
      }
      print(error.toString());
      throw const AuthException('Error to login');
    }
  }

  Future<void> logout() async {
    try {
      this.firebaseInstance.signOut();
      this.googleAuth.signOut();
    } catch (error) {
      throw const AuthException('Error to logout');
    }
  }
}