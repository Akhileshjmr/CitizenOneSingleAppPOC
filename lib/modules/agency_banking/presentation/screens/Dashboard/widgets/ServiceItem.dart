import 'package:citizenone_app/modules/agency_banking/constants/AppStrings.dart';
import 'package:flutter/material.dart';
/// Service Item = just an icon wrapper
class ServiceItem {
  final IconData icon;

  const ServiceItem({required this.icon});
}

/// Local icon mapping for known service codes
/// Backend supplies the codes + labels.
/// If backend sends an unknown code → app shows a fallback.
final Map<String, ServiceItem> serviceMapping = {
  // Transactions
  AppStrings.fundTransfer: const ServiceItem(icon: Icons.account_balance),
  AppStrings.receiveMoney: const ServiceItem(icon: Icons.download),
  AppStrings.sendMoney: const ServiceItem(icon: Icons.send),
  AppStrings.deposit: const ServiceItem(icon: Icons.attach_money),
  AppStrings.withdrawal: const ServiceItem(icon: Icons.money_off),
  AppStrings.trustAccount: const ServiceItem(icon: Icons.security),
  AppStrings.balanceEnquiry: const ServiceItem(icon: Icons.search),
  AppStrings.requestMoney: const ServiceItem(icon: Icons.request_page),
  AppStrings.receiveRequest: const ServiceItem(icon: Icons.reply),
  AppStrings.cbsToWallet: const ServiceItem(icon: Icons.swap_horiz),
  AppStrings.walletToCbs: const ServiceItem(icon: Icons.swap_vert),
  AppStrings.domesticFT: const ServiceItem(icon: Icons.public),
  AppStrings.internationalFT: const ServiceItem(icon: Icons.flight),

  // Customer Services
  AppStrings.accountCreation: const ServiceItem(icon: Icons.account_circle),
  AppStrings.customerCreation: const ServiceItem(icon: Icons.person_add),
  AppStrings.walletRegistration: const ServiceItem(icon: Icons.qr_code),

  // Loans
  AppStrings.accountRepayment:
      const ServiceItem(icon: Icons.account_balance_wallet),
  AppStrings.customerRepayment: const ServiceItem(icon: Icons.people),

  // Deposits
  AppStrings.savingsDeposit: const ServiceItem(icon: Icons.savings),
  AppStrings.termDeposit: const ServiceItem(icon: Icons.timeline),

  // Utilities
  AppStrings.billPayment: const ServiceItem(icon: Icons.receipt),

  // Other Services
  AppStrings.customerServiceRequest:
      const ServiceItem(icon: Icons.support_agent),
  AppStrings.accountServiceRequest: const ServiceItem(icon: Icons.account_box),
  AppStrings.genericServiceRequest:
      const ServiceItem(icon: Icons.miscellaneous_services),
  AppStrings.complaint: const ServiceItem(icon: Icons.report_problem),
};

/// Category fallback icons for unknown service codes
final Map<String, IconData> categoryFallbackIcons = {
  AppStrings.transactions: Icons.swap_horiz,
  AppStrings.repayments: Icons.account_balance_wallet,
  AppStrings.onboardingService: Icons.person_add,
  AppStrings.utilityServices: Icons.receipt,
  AppStrings.otherServices: Icons.miscellaneous_services,
  AppStrings.bulkUploadServices: Icons.cloud_upload,
};

/// Safe method to fetch an icon
IconData getServiceIcon(String category, String code) {
  return serviceMapping[code]?.icon ??
      categoryFallbackIcons[category] ??
      Icons.help_outline;
}
