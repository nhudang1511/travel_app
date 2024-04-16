import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;
import 'package:google_sign_in/google_sign_in.dart';
import '../../cache/cache.dart';
import '../../config/failure.dart';
import '../../config/shared_preferences.dart';
import '../model/user_model.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthRepository {
  AuthRepository(
      {CacheClient? cache,
      firebase_auth.FirebaseAuth? firebaseAuth,
      GoogleSignIn? googleSignIn,
      FacebookAuth? facebookAuth})
      : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();
  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

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
      await _firebaseAuth.currentUser?.sendEmailVerification();
      // print('new: $newUser');

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

      // Đảm bảo rằng đăng nhập đã thành công trước khi thực hiện các code sau
      if (_firebaseAuth.currentUser != null) {
        User? userData;
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
              password: password);
          setSP(userData);
        } else {
          throw const LogInWithEmailAndPasswordFailure();
        }
      } else {
        throw const LogInWithEmailAndPasswordFailure("Sign in unsuccessful.");
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }


  Future setSP(User user) async {
    SharedService.setUserId(user.id ?? '');
    SharedService.setEmail(user.email ?? '');
    SharedService.setName(user.name ?? '');
    SharedService.setPhone(user.phone ?? '');
    SharedService.setPassword(user.password ?? '');
    SharedService.setCountry(user.country ?? '');
    SharedService.setAvatar(user.avatar ?? '');
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

  Future<void> logInWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: firebaseUser!.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If user doesn't exist, create new user document
        await FirebaseFirestore.instance
            .collection("user")
            .doc(firebaseUser.uid)
            .set({
          'email': firebaseUser.email,
          "name": firebaseUser.displayName,
          "phoneNumber": firebaseUser.phoneNumber,
        });
      }
      final userData = User(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        name: firebaseUser.displayName,
        phone: firebaseUser.phoneNumber,
        // Add more fields if needed
      );
      await setSP(userData);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

  Future<void> logInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: (["public_profile", "email"]));

    // Create a credential from the access token
    final firebase_auth.OAuthCredential facebookAuthCredential =
        firebase_auth.FacebookAuthProvider.credential(
            loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    final userCredential = await _firebaseAuth.signInWithCredential(facebookAuthCredential);
    final firebaseUser = userCredential.user;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: firebaseUser!.email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      // If user doesn't exist, create new user document
      await FirebaseFirestore.instance
          .collection("user")
          .doc(firebaseUser.uid)
          .set({
        'email': firebaseUser.email,
        "name": firebaseUser.displayName,
        "phoneNumber": firebaseUser.phoneNumber,
      });
    }
    final userData = User(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      name: firebaseUser.displayName,
      phone: firebaseUser.phoneNumber,
      // Add more fields if needed
    );
    await setSP(userData);
  }

  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
      while (_firebaseAuth.currentUser!.emailVerified == false) {
        await Future.delayed(const Duration(seconds: 10)); // Đợi 1 giây trước khi kiểm tra lại
        await _firebaseAuth.currentUser?.reload(); // Tải lại thông tin người dùng từ Firebase Auth
      }
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
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
      SharedService.clear("likedHotels");
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
