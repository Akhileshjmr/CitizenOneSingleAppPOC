
// Arguments to be passed when opening the quiz
import 'package:flutter/material.dart';

class LimitArguments {

  /// Arguments to be passed when opening the quiz
  LimitArguments({
    required this.LimitMode,
  });

  /// Either [Sporting] or [Learning]
  final String LimitMode;
}


class AutoArguments {

  /// Arguments to be passed when opening the quiz
  AutoArguments({
    required this.filterval,
    required this.productid,
    required this.vendorid,
    required this.productKey,
  });

  /// Either [Sporting] or [Learning]
  final String filterval;
  final String productid;
  final String vendorid;
  final String productKey;

}

class AutoImgArguments {

  /// Arguments to be passed when opening the quiz
  AutoImgArguments({
    required this.filterval,
    required this.imageType
  });

  /// Either [Sporting] or [Learning]
  final String filterval;
  final String imageType;

}

class AutoTestDriveArguments {

  /// Arguments to be passed when opening the quiz
  AutoTestDriveArguments({
    required this.filterval,
    required this.skuid,
    required this.vendorid,
    required this.productKey,
  });

  /// Either [Sporting] or [Learning]
  final String filterval;
  final String skuid;
  final String vendorid;
  final String productKey;

}


class AutoReviewArguments {

  /// Arguments to be passed when opening the quiz
  AutoReviewArguments({
    required this.filterval,
  });

  /// Either [Sporting] or [Learning]
  final String filterval;
}

class RealEstateSecurityArguments {

  /// Arguments to be passed when opening the quiz
  RealEstateSecurityArguments({
    required this.filterval,
    required this.amount,
    required this.vendorName,
    required this.vendorid,
  });

  /// Either [Sporting] or [Learning]
  final String filterval;
  final String amount;
  final String vendorName;
  final String vendorid;
}

class MortgageEligibilityArguments {

  /// Arguments to be passed when opening the Mortgage
  MortgageEligibilityArguments({
    required this.EligibilityStatus,
  });

  final String EligibilityStatus;
}

class AutoChatArguments {

  /// Arguments to be passed when opening the quiz
  AutoChatArguments({
    required this.bankId,
    required this.name,
    required this.vendorid,
    required this.skuParams,
  });

  /// Either [Sporting] or [Learning]
  final String bankId;
  final String name;
  final String vendorid;
  final String skuParams;

}

class AutoVendorArguments {

  /// Arguments to be passed when opening the quiz
  AutoVendorArguments({
    required this.vendorName,
    required this.vendorid,
    required this.filterVal,
  });

  /// Either [Sporting] or [Learning]
  final String vendorName;
  final String vendorid;
  final String filterVal;
}


class SiteVisitArguments {

  /// Arguments to be passed when opening the quiz
  SiteVisitArguments({
    required this.name,
    required this.vendorid,
  });

  /// Either [Sporting] or [Learning]
  final String name;
  final String vendorid;

}


class CartBenfitArguments {

  /// Arguments to be passed when opening the quiz
  CartBenfitArguments({
    required this.cashBack,
    required this.saveMoney,
    required this.earnPoint,
  });

  /// Either [Sporting] or [Learning]
  final bool cashBack;
  final bool saveMoney;
  final bool earnPoint;
}


class FlightPersonArguments {

  /// Arguments to be passed when opening the quiz
  FlightPersonArguments({
    required this.adult,
    required this.childern,
    required this.infant,
    required this.orderId
  });

  /// Either [Sporting] or [Learning]
  final int adult;
  final int childern;
  final int infant;
  final String orderId;
}

class PlSatusArguments {

  /// Arguments to be passed when opening the quiz
  PlSatusArguments({
    required this.index,
    required this.pdfUrl
  });

  /// Either [Sporting] or [Learning]
  final int index;
  final String pdfUrl;
}
class maidServiceArguments {

  /// Arguments to be passed when opening the quiz
  maidServiceArguments({
    required this.addressID,
    required this.navigType,
  });

  /// Either [Sporting] or [Learning]
  final String addressID;
  final String navigType;
}
