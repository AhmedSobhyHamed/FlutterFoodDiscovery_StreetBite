import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/data/datasources/auth_interface.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/data/models/user_model.dart';
import 'package:flutterfooddiscovery_streetbite/features/auth/l10n/auth_locale.dart';

class AuthViaFirebase implements AuthWithEmailAndPasswordInterface<UserModel> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      throw _mapException(error, AuthLocale.loginFailed, {
        'invalid-credential': AuthLocale.wrongCredentials,
        'wrong-password': AuthLocale.wrongCredentials,
        'user-not-found': AuthLocale.wrongCredentials,
        'network-request-failed': AuthLocale.noConnection,
      });
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (name.isNotEmpty) {
        await credential.user?.updateDisplayName(name);
      }
    } on FirebaseAuthException catch (error) {
      throw _mapException(error, AuthLocale.signupFailed, {
        'email-already-in-use': AuthLocale.emailInUse,
        'invalid-email': AuthLocale.emailInvalid,
        'weak-password': AuthLocale.weakPassword,
        'network-request-failed': AuthLocale.noConnection,
      });
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      throw _mapException(error, AuthLocale.forgotPasswordFailed, {
        'user-not-found': AuthLocale.userNotFound,
        'invalid-email': AuthLocale.emailInvalid,
        'network-request-failed': AuthLocale.noConnection,
      });
    }
  }

  @override
  Future<void> verifyEmail() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw GeneralException(message: AuthLocale.userNotFound);
    }
    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (error) {
      throw _mapException(error, AuthLocale.verifyEmailFailed, {
        'too-many-requests': AuthLocale.verifyEmailFailed,
        'network-request-failed': AuthLocale.noConnection,
      });
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    await _auth.authStateChanges().first;
    final user = _auth.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      throw _mapException(error, AuthLocale.signOutFailed, {
        'network-request-failed': AuthLocale.noConnection,
      });
    }
  }

  GeneralException _mapException(
    FirebaseAuthException error,
    String fallback,
    Map<String, String> messages,
  ) {
    return GeneralException(message: messages[error.code] ?? fallback);
  }
}
