import 'package:equatable/equatable.dart';

class CustomerDetails extends Equatable {
  final String firstName;
  final String lastName;
  final String gender;
  final String idType;
  final String idNumber;
  final String email;
  final String mobileNumber;
  final String address;

  const CustomerDetails({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.idType,
    required this.idNumber,
    required this.email,
    required this.mobileNumber,
    required this.address,
  });

  CustomerDetails copyWith({
    String? firstName,
    String? lastName,
    String? gender,
    String? idType,
    String? idNumber,
    String? email,
    String? mobileNumber,
    String? address,
  }) {
    return CustomerDetails(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      idType: idType ?? this.idType,
      idNumber: idNumber ?? this.idNumber,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        gender,
        idType,
        idNumber,
        email,
        mobileNumber,
        address,
      ];
}
