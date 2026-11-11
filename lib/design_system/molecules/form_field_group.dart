import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/molecules/section_header.dart';

/// Groups a set of form fields under an optional section title.
class FormFieldGroup extends StatelessWidget {
  final String? title;
  final List<Widget> fields;
  final double spacing;

  const FormFieldGroup({
    super.key,
    this.title,
    required this.fields,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;

    return Container(
      padding: EdgeInsets.all(tokens.spacingMd),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(tokens.radiusMd),
        border: Border.all(color: tokens.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            SectionHeader(title: title!),
            SizedBox(height: tokens.spacingMd),
          ],
          ...fields
              .expand((f) => [f, SizedBox(height: spacing)])
              .toList()
            ..removeLast(),
        ],
      ),
    );
  }
}
