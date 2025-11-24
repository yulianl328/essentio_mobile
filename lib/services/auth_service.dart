import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> loginWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _ensureUserDocument(credential.user, fallbackEmail: email);
    return credential;
  }

  Future<UserCredential> registerWithEmail(
      String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _ensureUserDocument(credential.user, fallbackEmail: email);
    return credential;
  }

  Future<UserCredential> loginWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'google-cancelled',
        message: 'Google sign-in was cancelled',
      );
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    await _ensureUserDocument(userCredential.user,
        fallbackEmail: googleUser.email);
    return userCredential;
  }

  Future<void> _ensureUserDocument(
    User? user, {
    String? fallbackEmail,
  }) async {
    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);
    final existing = await userDoc.get();
    await userDoc.set({
      'email': user.email ?? fallbackEmail ?? existing.data()?['email'],
      if (!existing.exists) 'role': 'user',
      if (!existing.exists) 'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<String> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    final data = doc.data();
    return (data?['role'] as String?) ?? 'user';
  }
}
