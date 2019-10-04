import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuthentication {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password,String name);
  Future<String> getCurrentUser();
  Future<void> signOut();
}

class Authentication implements BaseAuthentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }

  @override
  Future<String> signIn(String email, String password) async {
  FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> signUp(String email, String password,String name) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    Firestore.instance.collection('users').document(user.uid).setData({'uid':user.uid,'email':email,'name':name});
    return user.uid;
  }
}

