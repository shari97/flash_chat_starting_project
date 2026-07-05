import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // 1. Initialise FirebaseAuth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get getCurrentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();



  // 2. Pass parameters directly rather than using UI controllers
  Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
          return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
    Future signInWithEmailAndPassword({
      required String email,
      required String password
    })async{
       return await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
       );

    }
    Future signOut()async{
    await _firebaseAuth.signOut();
    }

    }

