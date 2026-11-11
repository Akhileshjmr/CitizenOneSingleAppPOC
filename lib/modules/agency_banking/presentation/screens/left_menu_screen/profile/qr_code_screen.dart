import 'dart:convert';
import 'package:citizenone_app/modules/agency_banking/data/models/LoginQRImage.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_qr_bloc/login_qr_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_qr_bloc/login_qr_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_qr_bloc/login_qr_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/BaseScreen/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../utils/UICleanupHelper.dart';

class QRCodeScreen extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  const QRCodeScreen({required this.loginResponse});

  @override
  _QRCodeScreen createState() => _QRCodeScreen();
}

class _QRCodeScreen extends State<QRCodeScreen> {
  Color myHexColor = const Color(0xff5c7d33);
  LoginQRImage? qrImage; // Variable to store api response

  @override
  void initState() {
    super.initState();
    _fetchQrImage(); // Trigger the event to fetch data
  }

  void _fetchQrImage() {
    // Initialize LoginQrImage
    LoginQRImage qrImage = LoginQRImage();
    qrImage.headerInfo = widget.loginResponse.headerInfo;

    // Trigger the UserProfileSubmitted event
    context.read<LoginQrBloc>().add(
          LoginQrSubmitted(qrImage),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "QR Code",
      ),
      body: BlocConsumer<LoginQrBloc, LoginQrState>(
        listener: (context, state) {
          if (state is LoginQrSuccess) {
            // Store the response in a variable
            setState(() {
              qrImage = state.qrImage;
            });
          } else if (state is LoginQrFailure) {
            showCustomBottomPopup(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is LoginQrLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoginQrSuccess && qrImage != null) {
            // Decode the base64 QR code string into bytes
            final decodedBytes = base64Decode(qrImage!.qrcodeImage!);

            // Display the QR code image
            return Center(
              child: Image.memory(decodedBytes),
            );
          } else if (state is LoginQrFailure) {
            return Center(
              child: Text('Error: ${state.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          }

          return const Center(child: Text('No QR code available.'));
        },
      ),
    );
  }
}
