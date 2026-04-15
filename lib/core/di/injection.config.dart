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
import 'package:login_test/data/remote/services/auth_service.dart' as _i123;
import 'package:login_test/data/repositories/auth_repository.dart' as _i229;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i123.AuthService>(() => _i123.AuthService());
    gh.factory<_i229.AuthRepository>(
      () => _i229.AuthRepositoryImpl(authService: gh<_i123.AuthService>()),
    );
    return this;
  }
}
