import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';

String roleBase(UserRole role) {
  switch (role) {
    case UserRole.agent:
      return '/agent';
    case UserRole.farmer:
      return '/farmer';
    case UserRole.citizen:
      return '/customer';
  }
}

bool shouldHideShellHeader(String location) {
  return location.contains('/services/') &&
      location != '/services' &&
      location != '/customer/services' &&
      location != '/agent/services' &&
      location != '/farmer/services';
}
