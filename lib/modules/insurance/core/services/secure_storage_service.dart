// lib/core/services/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:citizenone_app/modules/insurance/core/constants/app_constants.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  Future<String?> getVendorCode() =>
      _storage.read(key: AppConstants.vendorCode);
  Future<String?> getAgentCode() => _storage.read(key: AppConstants.agentCode);
  Future<String?> getAgentMobNo() =>
      _storage.read(key: AppConstants.agentMobNo);
  Future<String?> getVendorKey() => _storage.read(key: AppConstants.vendorKey);
  Future<String?> getVendorMob() => _storage.read(key: AppConstants.vendorMob);
  Future<String?> getVendorLogo() =>
      _storage.read(key: AppConstants.vendorLogo);
}
