import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../local/hive_storage.dart';
import '../local/secure_session_storage.dart';
import '../models/user_model.dart';
import '../remote/services/auth_service.dart';

abstract class AuthRepository {
  Future<UserModel?> getCurrentSessionUser();

  Future<UserModel> login({
    required String taxCode,
    required String username,
    required String password,
  });

  Future<void> syncLocalUpdatesToFirebase();
}

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl({required AuthService authService}) : _authService = authService;

  @override
  Future<UserModel?> getCurrentSessionUser() async {
    final session = await SecureSessionStorage.getSession();
    if (session == null) {
      return null;
    }

    return _getUser(session.username);
  }

  @override
  Future<UserModel> login({
    required String taxCode,
    required String username,
    required String password,
  }) async {
    try {
      if (await InternetConnection().hasInternetAccess) {
        final user = await _authService.login(
          taxCode: taxCode,
          username: username,
          password: password,
        );
        await _upsertCachedUser(user);
        return user;
      }

      final user = await HiveStorage.loginLocal(
        taxCode: taxCode,
        username: username,
        password: password,
      );
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> syncLocalUpdatesToFirebase() async {
    if (!(await InternetConnection().hasInternetAccess)) return;

    try {
      final cachedUsers = HiveStorage.getCachedUsers();
      if (cachedUsers.isEmpty) return;

      for (final localUser in cachedUsers) {
        final remoteUser = await _authService.getUserByUsername(localUser.username);

        if (remoteUser != null && (localUser.updatedAt!.isAfter(remoteUser.updatedAt!))) {
          await _authService.updateUpdatedAt(localUser.id, localUser.updatedAt!);
        }
      }
    } catch (e) {
      debugPrint('Lỗi: $e');
    }
  }

  Future<void> _upsertCachedUser(UserModel user) async {
    final users = HiveStorage.getCachedUsers().toList(growable: true);
    final index = users.indexWhere(
      (u) => u.taxCodeId == user.taxCodeId && u.username == user.username,
    );

    if (index >= 0) {
      users[index] = user;
    } else {
      users.add(user);
    }

    await HiveStorage.saveUsers(users);
  }

  Future<UserModel?> _getUser(String username) async {
    if (await InternetConnection().hasInternetAccess) {
      try {
        final user = await _authService.getUserByUsername(username);
        if (user != null) {
          await _upsertCachedUser(user);
          return user;
        }
      } catch (e) {
        debugPrint('Lỗi get user từ firebase: $e');
      }
    }

    final cachedUsers = HiveStorage.getCachedUsers();
    for (final user in cachedUsers) {
      if (user.username == username) {
        return user;
      }
    }
    return null;
  }
}
