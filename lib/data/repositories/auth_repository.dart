import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../core/network/network_info.dart';
import '../local/hive_storage.dart';
import '../local/secure_storage.dart';
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
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({required AuthService authService, required NetworkInfo networkInfo})
    : _authService = authService,
      _networkInfo = networkInfo;

  @override
  Future<UserModel?> getCurrentSessionUser() async {
    final session = await SecureStorage.getSession();
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
      if (await _networkInfo.isConnected) {
        try {
          final user = await _authService.login(
            taxCode: taxCode,
            username: username,
            password: password,
          );
          try {
            final allUsers = await _authService.getAllUsers();
            await HiveStorage.saveUsers(allUsers);
          } catch (e) {
            debugPrint('Lỗi đồng bộ users từ Firebase: $e');
            await _upsertCachedUser(user);
          }
          return user;
        } catch (e) {
          try {
            final allUsers = await _authService.getAllUsers();
            await HiveStorage.saveUsers(allUsers);
          } catch (syncE) {
            debugPrint('Lỗi đồng bộ users từ Firebase khi login fail: $syncE');
          }
          rethrow;
        }
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
    if (!await _networkInfo.isConnected) return;

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
      debugPrint('Lỗi sync: $e');
    }
  }

  Future<void> _upsertCachedUser(UserModel user) async {
    final users = HiveStorage.getCachedUsers().toList(growable: true);
    final index = users.indexWhere((u) => u.taxCode == user.taxCode && u.username == user.username);

    if (index >= 0) {
      users[index] = user;
    } else {
      users.add(user);
    }

    await HiveStorage.saveUsers(users);
  }

  Future<UserModel?> _getUser(String username) async {
    if (await _networkInfo.isConnected) {
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
