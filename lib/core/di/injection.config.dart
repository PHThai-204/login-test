// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:login_test/core/network/network_info.dart' as _i98;
import 'package:login_test/data/remote/services/auth_service.dart' as _i123;
import 'package:login_test/data/repositories/auth_repository.dart' as _i229;
import 'package:login_test/views/login/cubit/login_cubit.dart' as _i1068;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i123.AuthService>(() => _i123.AuthService());
    gh.lazySingleton<_i98.NetworkInfo>(() => _i98.NetworkInfo());
    gh.factory<_i229.AuthRepository>(
      () => _i229.AuthRepositoryImpl(
        authService: gh<_i123.AuthService>(),
        networkInfo: gh<_i98.NetworkInfo>(),
      ),
    );
    gh.factory<_i1068.LoginCubit>(
      () => _i1068.LoginCubit(authRepository: gh<_i229.AuthRepository>()),
    );
    return this;
  }
}
