enum UserRole {
  citizen,
  agent,
  farmer; // Added farmer role

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

  String get iconAsset {
    // Return path to role icons if we have them, or use Material Icons mapping elsewhere
    return ''; 
  }
}
