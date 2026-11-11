enum UserRole {
  citizen,
  agent,
  farmer;

  String get displayName {
    switch (this) {
      case UserRole.citizen:
        return 'Citizen';
      case UserRole.agent:
        return 'Agent';
      case UserRole.farmer:
        return 'Farmer';
    }
  }

  String get roleCode {
    switch (this) {
      case UserRole.citizen:
        return 'CITIZEN';
      case UserRole.agent:
        return 'AGENT';
      case UserRole.farmer:
        return 'FARMER';
    }
  }
}

