import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:frontend/controllers/user/user_helpers.dart' as userHelpers;

Future<void> userSetup(String firstName, String lastName, String username, String companyId) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid.toString();
  String email = auth.currentUser.email.toString();
  users.add({
    'uid': uid,
    'Type': "User",
    'Firstname': firstName,
    'Lastname' : lastName,
    'Email' : email,
    'Username' : username,
    'Company ID' :companyId
  });
  userHelpers.createUser(firstName, lastName, email, username, companyId);
  return;
}

Future<void> adminSetup(String firstName, String lastName, String username,
    String companyId, String companyName, String companyLocation) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid.toString();
  String email = auth.currentUser.email.toString();
  users.add({
    'uid': uid,
    'Type': "Admin",
    'Firstname': firstName,
    'Lastname' : lastName,
    'Email' : email,
    'Username' : username,
    'Company ID' : companyId,
    'Company Name' :companyName,
    'Company Location' : companyLocation
  });
  userHelpers.createAdmin(firstName, lastName, email,
      username, companyId, companyName, companyLocation);
  return;
}