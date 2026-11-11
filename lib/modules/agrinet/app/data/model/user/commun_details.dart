import 'package:citizenone_app/modules/agrinet/app/data/model/user/phone_details.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/user/residence_address.dart';

class CommunDetails {
  List<ResidenceAddress>? residenceAddress;
  List<PhoneDetails>? phoneDetails;

  CommunDetails({this.residenceAddress, this.phoneDetails});

  factory CommunDetails.fromJson(Map<String, dynamic> json) {
    return CommunDetails(
      residenceAddress:
          json['residenceAddress'] != null
              ? List<ResidenceAddress>.from(
                json['residenceAddress'].map(
                  (x) => ResidenceAddress.fromJson(x),
                ),
              )
              : null,
      phoneDetails:
          json['phoneDetails'] != null
              ? List<PhoneDetails>.from(
                json['phoneDetails'].map((x) => PhoneDetails.fromJson(x)),
              )
              : null,
    );
  }
}
