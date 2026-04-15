import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:login_test/core/utils/app_utils.dart';
import 'package:login_test/data/models/user_model.dart';

import '../../exceptions/auth_exception.dart';

@injectable
class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> getAllUsers() async {
    try {
      final query = await _firestore.collection('accounts').get();
      
      return query.docs
          .map((doc) => UserModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw AuthException('Lỗi lấy danh sách người dùng: $e');
    }
  }

  Future<UserModel?> getUserByUsername(String username) async {
    try {
      final query = await _firestore
          .collection('accounts')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return null;
      }

      final userDoc = query.docs.first;
      return UserModel.fromJson(userDoc.data(), userDoc.id);
    } catch (e) {
      throw AuthException('Lỗi lấy thông tin người dùng: $e');
    }
  }

  Future<void> updateUpdatedAt(String userId, DateTime updatedAt) async {
    try {
      await _firestore.collection('accounts').doc(userId).update({
        'updatedAt': Timestamp.fromDate(updatedAt),
      });
    } catch (e) {
      throw AuthException('Lỗi cập nhật updatedAt: $e');
    }
  }

  Future<UserModel> login({
    required String taxCode,
    required String username,
    required String password,
  }) async {
    try {
      final query = await _firestore
          .collection('accounts')
          .where('taxCodeId', isEqualTo: taxCode)
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw AuthException('Thông tin đăng nhập không hợp lệ');
      }

      final userDoc = query.docs.first;
      final userData = userDoc.data();
      final user = UserModel.fromJson(userData, userDoc.id);
      debugPrint('user: ${user.toJson()}');

      if (!user.enabled) {
        throw AuthException('Tài khoản đã bị khóa');
      }

      if (user.lockUntil != null && user.lockUntil!.isAfter(DateTime.now())) {
        throw AuthException('Tài khoản của bạn đã bị tạm khoá trong 5 phút do nhập sai nhiều lần.');
      }

      final passwordHash = userData['passwordHash'] as String;
      final hashedInput = await AppUtils.validatePassword(password);
      if (hashedInput != passwordHash) {
        if (user.failedAttempts < 4) {
          await _increaseFailedAttempts(user.id);
        } else {
          await _firestore.collection('accounts').doc(user.id).update({
            'lockUntil': Timestamp.fromDate(DateTime.now().add(const Duration(minutes: 5))),
            'failedAttempts': 0,
          });
        }
        throw AuthException('Thông tin đăng nhập không hợp lệ');
      }

      await _firestore.collection('accounts').doc(user.id).update({
        'updatedAt': FieldValue.serverTimestamp(),
        'failedAttempts': 0,
      });

      final updatedDoc = await _firestore.collection('accounts').doc(user.id).get();
      return UserModel.fromJson(updatedDoc.data()!, updatedDoc.id);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Lỗi đăng nhập: $e');
    }
  }

  Future<void> _increaseFailedAttempts(String userId) async {
    try {
      await _firestore.collection('accounts').doc(userId).update({
        'failedAttempts': FieldValue.increment(1),
      });
    } catch (e) {
      throw AuthException('Lỗi tăng số lần đăng nhập thất bại: $e');
    }
  }
}
