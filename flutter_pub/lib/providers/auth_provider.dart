import 'package:firebase_auth/firebase_auth.dart';
class AuthClass{
  FirebaseAuth auth = FirebaseAuth.instance;
  //create account

  Future<String> createAccount({
    String email,
    String password
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return "Account created";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      }
      else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return "Error occured";
    }
  }
}