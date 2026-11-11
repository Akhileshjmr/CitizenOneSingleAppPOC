import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_image.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_constants.dart';
import 'package:flutter/material.dart';

class BidCard extends StatelessWidget {
  final String readyBy;
  final String bidCloses;
  final String title;
  final String code;
  final String minPrice;
  final String quantity;
  final String imageUrl;
  final Function? onTapCard;

  const BidCard({
    super.key,
    required this.readyBy,
    required this.bidCloses,
    required this.title,
    required this.code,
    required this.minPrice,
    required this.quantity,
    required this.imageUrl,
    this.onTapCard,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapCard!(),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: AgColors.kF3F3F3,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 70,
                        child:
                            imageUrl.isEmpty
                                ? Center(
                                  child: Opacity(
                                    opacity: 0.4,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.camera_alt,
                                          size: 36,
                                          color: AgColors.k4F4F4F,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'NO IMAGE AVAILABLE',
                                          style: TextStyle(
                                            color: AgColors.k4F4F4F,
                                            fontSize: 10,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : AgImage(
                                  imageUrl: imageUrl.addBaseUrl,
                                  width: double.infinity,
                                ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title, style: kw400grey24),
                                const SizedBox(height: 4),
                                Text(
                                  code,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: minPrice,
                              style: kw500Primary16,
                              children: [
                                TextSpan(
                                  text: '  ${AgConstants.currency} (Min price)',
                                  style: kw300Primary10,
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.right,
                            text: TextSpan(
                              text: quantity,
                              style: kA13D3Ffs16w500,
                              children: [
                                TextSpan(
                                  text: ' ${AgConstants.quantity}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Opacity(
              opacity: 0.6,
              child: Container(
                color: AgColors.kBlack,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _labelWithValue(
                      label: 'Ready by',
                      value: readyBy,
                      alignEnd: false,
                    ),
                    _labelWithValue(
                      label: 'Bid Closes',
                      value: bidCloses,
                      alignEnd: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _labelWithValue extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _labelWithValue({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: kw400White10),
        const SizedBox(height: 2),
        Text(value, style: kw400white14),
      ],
    );
  }
}
