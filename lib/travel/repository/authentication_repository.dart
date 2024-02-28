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

      // //? Save Into Local
      // SharedService.setUserId(_firebaseAuth.currentUser!.uid);
      var newUser = User(
          id: _firebaseAuth.currentUser!.uid,
          email: email,
          password: password,
          name: name,
          country: country,
          phone: phone);
      DBOP.newUser(newUser);
      print('new: $newUser');
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
      User? userData;

      // Check if user exists in local DB
      userData = await DBOP.getLogin(email, password);
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userData == null) {
        // If sign-in successful, search for user in Firestore
        final querySnapshot = await FirebaseFirestore.instance
            .collection('user')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final userDoc = querySnapshot.docs.first;
          userData = User(
            id: userDoc.id,
            email: userDoc['email'],
            name: userDoc['name'],
            country: userDoc['country'],
            phone: userDoc['phoneNumber'],
          );

          // Add user to local DB
          await DBOP.newUser(userData);
          SharedService.setUserId(_firebaseAuth.currentUser!.uid);
          setSP(userData);
        }
      }

      if (userData != null) {
        // Set user ID and other data
        SharedService.setUserId(_firebaseAuth.currentUser!.uid);
        setSP(userData);
      } else {
        // If user data is still null, throw failure
        throw const LogInWithEmailAndPasswordFailure();
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future setSP(User user) async {
    SharedService.setEmail(user.email ?? '');
    SharedService.setName(user.name ?? '');
    SharedService.setPhone(user.phone ?? '');
    SharedService.setPassword(user.password ?? '');
    SharedService.setCountry(user.country ?? '');
  }

  Future<bool> forgotPassword(String email) async {
    try {
      bool status = false;
      await _firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
        status = true;

      }).catchError((e) {
        status = false;
      });
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
      SharedService.clear("likedPlaces");
      SharedService.clear("userId");
      SharedService.clear("email");
      SharedService.clear("name");
      SharedService.clear("password");
      SharedService.clear("phone");
      SharedService.clear("country");
      sharedServiceClear();
      // DBOP.deleteAll();
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
