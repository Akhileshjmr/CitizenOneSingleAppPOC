// =============================================================================
// AppSpacer  —  ATOM
// -----------------------------------------------------------------------------
// Thin wrapper around SizedBox using AppSpacing tokens. Disallows magic
// numbers from leaking into widget trees and keeps spacing intent visible:
//
//     AppSpacer.lg()     // vertical 16px gap
//     AppSpacer.md(axis: Axis.horizontal)
// =============================================================================

import 'package:flutter/widgets.dart';
import '../../core/theme/app_spacing.dart';

class AppSpacer extends StatelessWidget {
  const AppSpacer._(this.size, this.axis, {super.key});

  const AppSpacer.xs({Axis axis = Axis.vertical, Key? key})
      : this._(AppSpacing.xs, axis, key: key);
  const AppSpacer.sm({Axis axis = Axis.vertical, Key? key})
      : this._(AppSpacing.sm, axis, key: key);
  const AppSpacer.md({Axis axis = Axis.vertical, Key? key})
      : this._(AppSpacing.md, axis, key: key);
  const AppSpacer.lg({Axis axis = Axis.vertical, Key? key})
      : this._(AppSpacing.lg, axis, key: key);
  const AppSpacer.xl({Axis axis = Axis.vertical, Key? key})
      : this._(AppSpacing.xl, axis, key: key);
  const AppSpacer.xxl({Axis axis = Axis.vertical, Key? key})
      : this._(AppSpacing.xxl, axis, key: key);

  final double size;
  final Axis axis;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: axis == Axis.horizontal ? size : 0,
        height: axis == Axis.vertical ? size : 0,
      );
}
