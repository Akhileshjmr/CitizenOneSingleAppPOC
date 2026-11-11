import 'package:citizenone_app/modules/agency_banking/constants/AppConfig.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/formatter.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/repsonsive_helper.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/snack.dart';
import 'package:citizenone_app/modules/agency_banking/data/api/end_points/ApiEndPoints.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/responsive/breakpoints.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/app_bar/kyc_app_bar.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_scaffold.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'kyc_edit_user_screen.dart';

class KycDetailsScreen extends StatelessWidget {
  const KycDetailsScreen({super.key, this.enableEdit = true});
  final bool enableEdit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (Breakpoints.isDesktop(constraints.maxWidth)) {
          return _buildDesktopScaffold(context);
        }
        return _buildMobileTabletScaffold(context);
      },
    );
  }

  void _detailsListener(BuildContext context, KycState state) {
    if (state.fileDownloadStatus == FileDownloadStatus.loading) {
      Snack.show(context, message: "Downloading...");
    }
    if (state.fileDownloadStatus == FileDownloadStatus.success) {
      Snack.show(context, message: "Downloaded Successfully");
    }
    if (state.fileDownloadStatus == FileDownloadStatus.failure) {
      Snack.show(context, message: "Download Failed");
    }
  }

  Widget _buildDesktopScaffold(BuildContext context) {
    return BlocConsumer<KycBloc, KycState>(
      listener: _detailsListener,
      builder: (context, state) {
        return KycDesktopScaffold(
          pageTitle: "KYC Details",
          maxContentWidth: 900,
          child: Column(
            children: [
              _buildProfileSection(state),
              const SizedBox(height: 24),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildPersonalDetailsCard(context, state)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildProfessionalDetailsCard(state)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildContactCard(state),
              const SizedBox(height: 16),
              AccordionCard(
                title: "Signature",
                onEdit: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _imageWidget(
                      imageUrl: (state.signatureUrl != null)
                          ? "${ApiEndpoints.profittoBaseUrl}${state.signatureUrl}"
                          : "",
                      label: "Signature",
                      fileBytes: state.signatureFile,
                      isSignature: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildDocumentsCard(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileTabletScaffold(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: const KycAppBar(
        centerTitle: true,
        showBack: true,
        title: 'KYC Details',
      ),
      body: BlocConsumer<KycBloc, KycState>(
        listener: _detailsListener,
        builder: (context, state) {
          // if (state.status == KycUserStatus.loading) {
          //   return const Center(child: CircularProgressIndicator());
          //  }
          // if (state.status == KycStatus.error) {
          //   return const Center(child: CircularProgressIndicator());
          // }
          // if (state.status == KycStatus.empty) {
          //   return _buildEmptyState(context, state);
          // }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding(context),
              vertical: Responsive.value(context, mobile: 16.0, web: 24.0),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.contentMaxWidth(context),
                ),
                child: Column(
                  children: [
                    _buildProfileSection(state),
                    const SizedBox(height: 24),
                    if (isMobile) ...[
                      _buildPersonalDetailsCard(context, state),
                      const SizedBox(height: 16),
                      _buildProfessionalDetailsCard(state),
                    ] else
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child:
                                    _buildPersonalDetailsCard(context, state)),
                            const SizedBox(width: 16),
                            Expanded(
                                child: _buildProfessionalDetailsCard(state)),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    _buildContactCard(state),
                    const SizedBox(height: 16),
                    AccordionCard(
                      title: "Signature",
                      onEdit: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _imageWidget(
                            imageUrl: (state.signatureUrl != null)
                                ? "${ApiEndpoints.profittoBaseUrl}${state.signatureUrl}"
                                : "",
                            label: "Signature",
                            fileBytes: state.signatureFile,
                            isSignature: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDocumentsCard(context, state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
    VoidCallback? onEdit,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              if (onEdit != null)
                IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit,
                        color: AppColors.teal1, size: 23))
            ],
          ),
          ...children
        ],
      ),
    );
  }

  Widget _detailRow(String label, String? value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: AppColors.textHint, fontSize: 14)),
          Text(
            value ?? "-",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(KycState state) {
    final imageUrl = (state.photoUrl != null)
        ? "${ApiEndpoints.profittoBaseUrl}/${state.photoUrl}"
        : "";

    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: (imageUrl.isEmpty)
                ? Container(
                    color: AppColors.lightGray,
                    child: const Icon(Icons.person,
                        size: 60, color: AppColors.darkGray),
                  )
                : Image.network(
                    imageUrl,
                    headers: const {
                      'Authorization':
                          'Bearer ${AppConfig.staticProfittoAccessToken}'
                    },
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.darkGrey,
                        child: const Icon(Icons.person,
                            size: 60, color: AppColors.darkGray),
                      );
                    },
                  ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "${state.firstName ?? ""} ${state.lastName ?? ""}",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _imageWidget({
    required String? imageUrl,
    required String label,
    List<int>? fileBytes,
    bool isSignature = false,
  }) {
    return Column(
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.lightGray,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                // (fileBytes != null && fileBytes.isNotEmpty)
                //     ? Image.memory(
                //         Uint8List.fromList(fileBytes),
                //         fit: BoxFit.cover,
                //       )
                //     :
                (imageUrl == null || imageUrl.isEmpty)
                    ? Icon(
                        isSignature ? Icons.draw : Icons.person,
                        color: AppColors.darkGrey,
                      )
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.fill,
                        headers: {
                          'Authorization':
                              'Bearer ${AppConfig.staticProfittoAccessToken}'
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                              color: AppColors.darkGrey,
                              child: const Icon(
                                Icons.draw,
                                color: AppColors.darkGrey,
                              ));
                        },
                      ),
          ),
        ),
        const SizedBox(height: 6),
        // Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _documentTile(String title, String date, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(date),
      trailing: const Icon(Icons.open_in_new, color: AppColors.teal1),
      onTap: onTap,
    );
  }

  Widget _buildPersonalDetailsCard(BuildContext context, KycState state) {
    return _buildSectionCard(
      title: "Personal Details",
      onEdit: enableEdit
          ? () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditKycScreen()),
              )
          : null,
      children: [
        _detailRow("First Name", state.firstName),
        _detailRow("Last Name", state.lastName),
        _detailRow("Gender", state.gender),
        _detailRow("DOB", state.dob?.toString().split(" ").first),
        _detailRow("Mobile", state.mobileNumber),
        _detailRow(
          "National ID",
          Formatter.formatNationalId(state.nationalId.toString()),
          isBold: true,
        ),
        _detailRow("Origin Country", state.originCountryFriendlyType),
      ],
    );
  }

  Widget _buildProfessionalDetailsCard(KycState state) {
    return _buildSectionCard(
      title: "Professional Details",
      children: [
        _detailRow("Employment Type", state.employmentType),
        _detailRow("Sector", state.sector),
        if (state.employmentType == "Employed")
          _detailRow("Employer", state.employerName)
        else ...[
          _detailRow("Business Nature", state.businessNature),
          _detailRow("Business Name", state.businessName),
        ],
        _detailRow("Monthly Income", state.monthlyIncome?.toString()),
      ],
    );
  }

  Widget _buildContactCard(KycState state) {
    return _buildSectionCard(
      title: "Contact",
      children: [
        _detailRow("Email", state.email),
        _detailRow("Phone", state.phNumber),
        _detailRow("Address", state.addressLine),
        _detailRow("Post Box No", state.pbNumber),
        _detailRow("Country", state.countryFriendlyType),
        _detailRow("State", state.stateFriendlyType),
        _detailRow("District", state.districtFriendlyType),
        _detailRow("City", state.cityFriendlyType),
      ],
    );
  }

  Widget _buildDocumentsCard(BuildContext context, KycState state) {
    return _buildSectionCard(
      title: "Documents",
      children: state.kycUserDocuments.map((doc) {
        return _documentTile(
          doc.docName,
          doc.expiryDate != null
              ? "Expiry: ${DateFormat('dd/MM/yyyy').format(doc.expiryDate!)}"
              : "",
          () => context.read<KycBloc>().add(
                DownloadDocument(url: doc.docUrl, fileName: doc.fileName),
              ),
        );
      }).toList(),
    );
  }
}

class AccordionCard extends StatefulWidget {
  final String title;
  final VoidCallback? onEdit;
  final Widget child;

  const AccordionCard({
    super.key,
    required this.title,
    this.onEdit,
    required this.child,
  });

  @override
  State<AccordionCard> createState() => _AccordionCardState();
}

class _AccordionCardState extends State<AccordionCard> {
  bool isExpanded = false;

  void toggle() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        children: [
          /// HEADER (clickable)
          InkWell(
            onTap: toggle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),

          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                2.verticalSpace,
                widget.child,
              ],
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
