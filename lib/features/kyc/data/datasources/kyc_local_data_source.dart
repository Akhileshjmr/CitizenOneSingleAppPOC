// features/kyc/data/datasources/kyc_local_data_source.dart

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class KycLocalDataSource {
  Future<String> getAgentMobileNumber();
}

class KycLocalDataSourceImpl implements KycLocalDataSource {
  final SharedPreferences sharedPreferences;

  KycLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<String> getAgentMobileNumber() async {
    try {
      final storageData = sharedPreferences.getString('loginResponse');
      if (storageData == null) return '630316048';
      final data = jsonDecode(storageData);
      return data?['loginUserInfo']?['mobileno']?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }
}
