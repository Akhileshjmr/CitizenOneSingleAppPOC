import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../utils/CommSuccessDialogues.dart';
import '../../../../blocs/wallet_account_search/wallet_account_search_bloc.dart';
import '../../../../blocs/wallet_account_search/wallet_account_search_event.dart';
import '../../../../blocs/wallet_account_search/wallet_account_search_state.dart';
import '../../../BaseScreen/base_screen.dart';
import '../../../../../data/models/CommWalletAccountRequest.dart';
import '../../../Dashboard/widgets/BankSelectionScreen.dart';
import '../agent_application/transactions/transaction_details_screen.dart';

class ScanPayScreen extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  final String itemKey;
  final String? transactionType;
  final BankOption selectedBank;

  const ScanPayScreen({
    required this.loginResponse,
    required this.itemKey,
    this.transactionType,
    Key? key, required this.selectedBank,
  }) : super(key: key);

  @override
  _ScanPayScreenState createState() => _ScanPayScreenState();
}

class _ScanPayScreenState extends BaseScreenState<ScanPayScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool isScanning = true;
  bool isFlashOn = false;
  String? qrCode;
  String? mobileNumber;

  @override
  Widget build(BuildContext context) {
    Color myHexColor = const Color(0xff5c7d33);

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Scan & pay",
      ),
      body: BlocListener<WalletSearchBloc, WalletSearchState>(
        listener: (context, state) {
          if (state is WalletSearchSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionScreen(
                  commWalletAccountRequest: state.commWalletAccountRequest,
                  itemKey: widget.itemKey,
                  transactionType: widget.transactionType ?? "",
                  loginResponse: widget.loginResponse,
                  selectedBank: widget.selectedBank,
                ),
              ),
            );
          } else if (state is WalletSearchFailure) {
            showCustomBottomPopup(context, state.error);
          }
        },
        child: Stack(
          children: [
            if (isScanning)
              MobileScanner(
                controller: _scannerController,
                fit: BoxFit.cover,
                onDetect: (BarcodeCapture capture) {
                  final Barcode? barcode = capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
                  final String? code = barcode?.rawValue;

                  if (code != null) {
                    _scannerController.stop();
                    setState(() {
                      qrCode = code;
                      mobileNumber = code;
                      isScanning = false;
                    });

                    if (mobileNumber != null) {
                      _callWalletSearchApi(mobileNumber!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid QR Code: Mobile number not found')),
                      );
                      _scannerController.start();
                      setState(() {
                        isScanning = true;
                      });
                    }
                  }
                },
              ),
            // Scan Frame UI
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            // Flash Toggle Button
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(
                  isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    isFlashOn = !isFlashOn;
                    _scannerController.toggleTorch();
                  });
                },
              ),
            ),

            // Display Scanned QR Code
            if (qrCode != null)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _callWalletSearchApi(String mobileNumber) {
    CommWalletAccountRequest request = CommWalletAccountRequest();
    request.headerInfo = widget.loginResponse.headerInfo;
    request.moduleCode = widget.itemKey;
    request.mobileno = mobileNumber;

    context.read<WalletSearchBloc>().add(WalletSearchSubmitted(request));
  }
}
