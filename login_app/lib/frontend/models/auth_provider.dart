import 'package:firebase_auth/firebase_auth.dart';

import 'package:login_app/frontend/front_end_globals.dart' as globals;

class AuthClass {

  FirebaseAuth auth = FirebaseAuth.instance;
  //create collection

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
      return "Error occurred";
    }
  }

  //sign in
  Future<String> signIn({
    String email,
    String password
  })
  async {
    try {
         await auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
         return "welcome";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        return "Wrong password provided for that user.";
      }
    }
  }

  //reset password
  Future<String> resetPassword({
    String email
  }) async {
    try {
      await auth.sendPasswordResetEmail(
          email: email
      );
      return "Email sent";
    }
    catch (e) {
      return "Error occurred";
    }
  }

  //delete account
  Future<String> deleteAccount() async {
    try {
      FirebaseAuth.instance.currentUser.delete();
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return 'The user must reauthenticate before this operation can be executed.';
      }
      return 'Error occurred';
    }
  }

  //update email
  Future<String> updateEmail({
    String newEmail
  }) async {
     try {
       await auth.currentUser.updateEmail(newEmail);
       return 'Success';
     } on FirebaseAuthException catch (e) {
       if (e.code == 'requires-recent-login') {
         return 'The user must reauthenticate before this operation can be executed.';
       }
       return 'Error occurred';
     }
  }

  //sign out
  void signOut(){
     //Clear currently signed in user data first
     globals.loggedInUserType = '';
     globals.loggedInUserEmail = '';
     globals.loggedInUserId = '';

     auth.signOut();
  }
}