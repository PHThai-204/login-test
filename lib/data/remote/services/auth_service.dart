import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:login_test/core/utils/app_utils.dart';
import 'package:login_test/data/models/user_model.dart';

import '../../exceptions/auth_exception.dart';

@injectable
class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

      if (!user.enabled) {
        throw AuthException('Tài khoản đã bị khóa');
      }

      final passwordHash = userData['passwordHash'] as String;
      final hashedInput = await AppUtils.validatePassword(password);
      if (hashedInput != passwordHash) {
        throw AuthException('Thông tin đăng nhập không hợp lệ');
      }

      await _firestore.collection('accounts').doc(user.id).update({
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final updatedDoc = await _firestore.collection('accounts').doc(user.id).get();
      return UserModel.fromJson(updatedDoc.data()!, updatedDoc.id);
      
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Lỗi đăng nhập: $e');
    }
  }
}
