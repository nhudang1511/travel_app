import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;
import '../../cache/cache.dart';
import '../../config/failure.dart';
import '../../config/shared_preferences.dart';
import '../model/user_model.dart';
import '../sqlite/database.dart';

class AuthRepository {
  AuthRepository({
    CacheClient? cache,
    firebase_auth.FirebaseAuth? firebaseAuth,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;
  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  @visibleForTesting
  bool isWeb = kIsWeb;

  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  User? get currentUser {
    return _cache.read<User>(key: userCacheKey);
  }

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser?.toUser;
      return user;
    });
  }

  Future<void> signUp(
      {required String name,
      required String country,
      required String phone,
      required String email,
      required String password}) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance
          .collection("user")
          .doc(userCredential.user?.uid)
          .set({
        'email': email,
        "name": name,
        "phoneNumber": phone,
        "country": country
      });

      //? Save Into Local
      SharedService.setUserId(_firebaseAuth.currentUser!.uid);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      SharedService.setUserId(_firebaseAuth.currentUser!.uid);
      SharedService.setEmail(email);
      var newUser = User(
          id: _firebaseAuth.currentUser!.uid,
          name: "exp@",
          password: password);
      DBOP.newUser(newUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      bool status = false;
      await _firebaseAuth
          .sendPasswordResetEmail(email: email)
          .then((value) => status = true)
          .catchError((e) => status = false);
      return status;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
      SharedService.clear("userId");
      SharedService.clear("likedPlaces");
      SharedService.clear("email");
      sharedServiceClear();
      DBOP.deleteAll();
    } catch (_) {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  /// Maps a [firebase_auth.User] into a [User].
  User get toUser {
    return User(id: uid, name: displayName, email: email, phone: phoneNumber);
  }
}
