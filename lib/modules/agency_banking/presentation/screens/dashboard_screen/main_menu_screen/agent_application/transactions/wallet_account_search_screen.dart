import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/transaction_details_screen.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // For accessing contacts
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../constants/AppStrings.dart';
import '../../../../../../constants/ModuleCode.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../data/models/BannerContent.dart';
import '../../../../../../data/models/CommWalletAccountRequest.dart';
import '../../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../../data/services/AuthService.dart';
import '../../../../../../utils/AESEncryption.dart';
import '../../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../../utils/ResponsiveLeftBanner.dart';
import '../../../../../blocs/wallet_account_search/wallet_account_search_bloc.dart';
import '../../../../../blocs/wallet_account_search/wallet_account_search_event.dart';
import '../../../../../blocs/wallet_account_search/wallet_account_search_state.dart';
import '../../../../Dashboard/widgets/BankSelectionScreen.dart';
import '../../customer_application/customer_transaction_setails_screen.dart';
import 'money_transfers/balance_enquiry.dart';

class WalletAccountSearch extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  final dynamic itemKey;
  final String? transactionType;
  final BankOption selectedBank;

  @override
  _WalletAccountSearchState createState() => _WalletAccountSearchState();
  const WalletAccountSearch(
      {required this.loginResponse,
      required this.itemKey,
      this.transactionType,
      required this.selectedBank});
}

class _WalletAccountSearchState extends State<WalletAccountSearch>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Color myHexColor = const Color(0xff5c7d33);
  bool isScanning = true;
  bool isFlashOn = false;
  String? qrCode;
  String? mobileNumber;

  final MobileScannerController _scannerController = MobileScannerController();
  final TextEditingController _mobileNumberController =
      TextEditingController(); // Controller for mobile number input
  final AuthService authService =
      AuthService(); // Initialize the AuthService here
  List<Contact> contacts = []; // Store contacts
  List<Contact> filteredContacts = []; // Store filtered contacts

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getContacts(); // Fetch contacts at the start
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  String sanitizeMobile(String number) {
    return number
        .replaceAll(RegExp(r'[^\d]'), '') // remove everything except digits
        .trim();
  }

  Future<void> _getContacts() async {
    final status = await Permission.contacts.status;

    if (status.isGranted) {
      final _contacts = await FlutterContacts.getContacts(withProperties: true);
      AppLogger.debug('Contacts fetched: ${_contacts.length}');
      setState(() {
        contacts = _contacts;
        // Do not set filteredContacts yet
      });
    } else if (status.isDenied) {
      final newStatus = await Permission.contacts.request();
      if (newStatus.isGranted) {
        final _contacts =
            await FlutterContacts.getContacts(withProperties: true);
        setState(() {
          contacts = _contacts;
          // Do not set filteredContacts yet
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contacts permission denied')),
        );
      }
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Permission permanently denied. Please enable it in app settings.'),
          action: SnackBarAction(
            label: 'Open Settings',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
    }
  }

  void _filterContacts(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredContacts = contacts
            .where((contact) =>
                contact.displayName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filteredContacts = []; // hide list again when input is cleared
      });
    }
  }

  void _submitMobileNumber(BuildContext context) {
    final rawMobile = _mobileNumberController.text;
    final mobileNumber = sanitizeMobile(rawMobile);
    AppLogger.debug('Wallet account search initiated');

    if (mobileNumber.isEmpty) {
      showCustomBottomPopup(context, "Mobile number is required");
      return;
    }

    if (mobileNumber.length != 9) {
      showCustomBottomPopup(context, 'Enter a valid 9 digit mobile number');
      return;
    }
    if (AESEncryptionService.decrypt(
            widget.loginResponse.headerInfo.userName) ==
        mobileNumber) {
      showCustomBottomPopup(
          context, "Debit and Credit Accounts should not be same");
      return;
    }
    CommWalletAccountRequest request = CommWalletAccountRequest();
    request.mobileno = AESEncryptionService.encrypt(mobileNumber);
    request.headerInfo = widget.loginResponse.headerInfo;
    AppLogger.debug('Wallet search itemKey: ${widget.itemKey}');
    request.moduleCode = AESEncryptionService.encrypt(widget.itemKey);
    context.read<WalletSearchBloc>().add(WalletSearchSubmitted(request));
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final List<BannerContent> banners = [
      BannerContent(
        imagePath: "assets/images/home_banner.jpg",
        title: AppStrings.bannerTitle,
        headline: AppStrings.bannerHeading,
        subtitle: AppStrings.bannerSubtitle,
        ctaText: AppStrings.bannerCreateText,
        onCtaPressed: () {
          AppLogger.debug('Banner CTA clicked');
        },
      ),
    ];
    return DefaultTabController(
        length: 3,
        child: BlocProvider(
            create: (_) => WalletSearchBloc(authService),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: CustomAppBar(
                title: "Wallet Account Search",
                bottom: TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.black,
                  tabs: const [
                    Tab(icon: Icon(Icons.contacts_outlined), text: "Contacts"),
                    Tab(icon: Icon(Icons.dialpad), text: "New Number"),
                    Tab(icon: Icon(Icons.qr_code), text: "QR Code"),
                  ],
                ),
              ),
              body: Row(children: [
                if (!isMobile) ResponsiveLeftBanner(banners: banners),
                Expanded(
                  child: BlocConsumer<WalletSearchBloc, WalletSearchState>(
                    listener: (context, state) {
                      if (state is WalletSearchSuccess) {
                        final screen = widget.itemKey ==
                                ModuleCode.balanceEnquiry
                            ? BalanceEnquiryScreen(
                                commWalletAccountRequest:
                                    state.commWalletAccountRequest,
                                itemKey: widget.itemKey,
                                transactionType: widget.transactionType ?? '',
                                loginResponse: widget.loginResponse,
                                selectedBank: widget.selectedBank,
                              )
                            : widget.itemKey == ModuleCode.requestMoney ||
                                    widget.itemKey == ModuleCode.trustAccount ||
                                    widget.itemKey == ModuleCode.deposit ||
                                    widget.itemKey == ModuleCode.withdrawal
                                ? TransactionScreen(
                                    commWalletAccountRequest:
                                        state.commWalletAccountRequest,
                                    itemKey: widget.itemKey,
                                    transactionType:
                                        widget.transactionType ?? '',
                                    loginResponse: widget.loginResponse,
                                    selectedBank: widget.selectedBank,
                                  )
                                : CustomerTransactionScreen(
                                    commWalletAccountRequest:
                                        state.commWalletAccountRequest,
                                    itemKey: widget.itemKey,
                                    transactionType:
                                        widget.transactionType ?? '',
                                    loginResponse: widget.loginResponse,
                                    selectedBank: widget.selectedBank,
                                  );
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => screen));
                      } else if (state is WalletSearchFailure) {
                        showCustomBottomPopup(context, state.error);
                      }
                    },
                    builder: (context, state) => TabBarView(
                      controller: _tabController,
                      children: [
                        // Contacts Tab
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search by name or number',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onChanged: _filterContacts,
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: filteredContacts.length,
                                  itemBuilder: (_, i) {
                                    final c = filteredContacts[i];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        child: Text(c.displayName.isNotEmpty
                                            ? c.displayName[0]
                                            : '?'),
                                      ),
                                      title: Text(c.displayName),
                                      subtitle: c.phones.isNotEmpty
                                          ? Text(c.phones.first.number)
                                          : const Text('No number'),
                                      // onTap: () {
                                      //   if (c.phones.isNotEmpty) {
                                      //     _mobileNumberController.text =
                                      //         c.phones.first.number;
                                      //     _submitMobileNumber(context);
                                      //   }
                                      // },
                                      onTap: () {
                                        if (c.phones.isNotEmpty) {
                                          final cleaned = sanitizeMobile(
                                              c.phones.first.number);
                                          _mobileNumberController.text =
                                              cleaned;
                                          _submitMobileNumber(context);
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Manual Entry Tab
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextField(
                                key: const Key("search_mobile_number"),
                                controller: _mobileNumberController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  hintText: 'Enter mobile number',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (val) => val.length == 9
                                    ? _submitMobileNumber(context)
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              if (state is WalletSearchLoading)
                                const CircularProgressIndicator(),
                            ],
                          ),
                        ),
                        // QR Code Scanner Tab
                        Stack(
                          children: [
                            MobileScanner(
                              controller: _scannerController,
                              fit: BoxFit.cover,
                              onDetect: (capture) {
                                final code =
                                    capture.barcodes.firstOrNull?.rawValue;
                                if (code != null && isScanning) {
                                  setState(() => isScanning = false);
                                  _scannerController.stop();
                                  _mobileNumberController.text = code;
                                  _submitMobileNumber(context);
                                }
                              },
                            ),
                            if (qrCode != null)
                              Positioned(
                                bottom: 16,
                                left: 16,
                                right: 16,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  color: Colors.white,
                                  child: Text('Scanned QR: $qrCode',
                                      textAlign: TextAlign.center),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            )));
  }
}
