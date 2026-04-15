import 'package:hive_flutter/hive_flutter.dart';
import 'package:login_test/core/utils/app_utils.dart';
import 'package:login_test/data/models/user_model.dart';

import '../exceptions/auth_exception.dart';

class HiveStorage {
  static const String appBoxName = 'appBox';
  static const String cachedUsersKey = 'cached_users';
  static const String cachedUsersUpdatedAtKey = 'cached_users_updated_at';

  static late Box _appBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    _appBox = await Hive.openBox(appBoxName);
  }

  static Box get appBox => _appBox;

  static Future<void> saveUsers(List<UserModel> users) async {
    final payload = users.map((user) => user.toJson()).toList(growable: false);
    await _appBox.put(cachedUsersKey, payload);
    await _appBox.put(cachedUsersUpdatedAtKey, DateTime.now().toIso8601String());
  }

  static List<UserModel> getCachedUsers() {
    final rawUsers = _appBox.get(cachedUsersKey, defaultValue: <dynamic>[]);
    if (rawUsers is! List) {
      return <UserModel>[];
    }

    return rawUsers
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(UserModel.fromCacheJson)
        .toList(growable: false);
  }

  static Future<UserModel> loginLocal({
    required String taxCode,
    required String username,
    required String password,
  }) async {
    final users = getCachedUsers().toList(growable: true);

    try {
      final index = users.indexWhere((us) => us.taxCodeId == taxCode && us.username == username);
      
      if (index == -1) {
        throw AuthException('Thông tin đăng nhập không hợp lệ');
      }

      final user = users[index];

      if (!user.enabled) {
        throw AuthException('Tài khoản đã bị khóa');
      }

      final hashedInput = await AppUtils.validatePassword(password);

      if (hashedInput != user.passwordHash) {
        throw AuthException('Thông tin đăng nhập không hợp lệ');
      }

      final updatedUser = UserModel(
        id: user.id,
        username: user.username,
        fullName: user.fullName,
        taxCodeId: user.taxCodeId,
        passwordHash: user.passwordHash,
        enabled: user.enabled,
        updatedAt: DateTime.now(),
      );

      users[index] = updatedUser;
      await saveUsers(users);

      return updatedUser;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Lỗi đăng nhập: $e');
    }
  }

  static Future<void> clearAll() async {
    await _appBox.clear();
  }
}
