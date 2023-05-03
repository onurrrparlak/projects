import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> registerUser(
      String email, String password, String username) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'username': username,
      'email': email,
      // Add other fields as needed, e.g., 'avatar': 'default_avatar_url'
    });
    return userCredential;
  }

  Future<UserCredential> loginUser(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }
}
