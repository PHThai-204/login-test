import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

@lazySingleton
class NetworkInfo {
  final InternetConnection connection = InternetConnection();

  Future<bool> get isConnected => connection.hasInternetAccess;
}
