import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfooddiscovery_streetbite/core/exceptions/app_exception.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/data/datasources/user_service.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/data/models/profile_model.dart';
import 'package:flutterfooddiscovery_streetbite/features/settings/l10n/profile_locale.dart';

class UserViaFirestore implements UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _users => _firestore.collection('users');

  @override
  Future<ProfileModel?> read(String id) async {
    try {
      final doc = await _users.doc(id).get();
      final data = doc.data();
      if (!doc.exists || data == null) return null;
      return ProfileModel.fromJson(data);
    } on FirebaseException {
      throw GeneralException(message: ProfileLocale.loadFailed);
    }
  }

  @override
  Future<void> saveAccount({
    required String id,
    required String name,
    required String email,
  }) async {
    try {
      final current = await read(id);
      await _users.doc(id).set({
        'id': id,
        'name': name,
        'email': email,
        'image': current?.image ?? '',
      });
    } on AppException {
      rethrow;
    } on FirebaseException {
      throw GeneralException(message: ProfileLocale.saveFailed);
    }
  }

  @override
  Future<void> update({
    required String id,
    required String name,
    required String email,
    required String image,
  }) async {
    try {
      await _users.doc(id).set({
        'id': id,
        'name': name,
        'email': email,
        'image': image,
      }, SetOptions(merge: true));
    } on FirebaseException {
      throw GeneralException(message: ProfileLocale.saveFailed);
    }
  }

  @override
  Future<bool> emailVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    try {
      await user.reload();
      return _auth.currentUser?.emailVerified ?? false;
    } catch (_) {
      return false;
    }
  }
}
