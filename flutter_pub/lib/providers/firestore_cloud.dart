import 'package:firebase_auth/firebase_auth.dart';

//imports for the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> userSetup(String Firstname, String lastname, String username, String companyName, String companyLocation)
async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid.toString();
  String email = auth.currentUser.email.toString();
  users.add({
    'uid': uid,
    'Firstname': Firstname,
    'Lastname' : lastname,
    'Email' : email,
    'Username' : username,
    'Company Name' :companyName,
    'Company Location' : companyLocation
  });
  return;
}