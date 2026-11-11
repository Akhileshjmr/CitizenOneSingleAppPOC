// =============================================================================
// PartnerSelectionPopup  —  ORGANISM
// -----------------------------------------------------------------------------
// Row content shown when the vendor logo in AppDesktopHeader is tapped, plus
// a PartnerSelectionMenuController that presents it — anchored below the
// vendor logo on desktop/tablet via an OverlayEntry + CompositedTransform, or
// as a bottom sheet on mobile — and hands off to AppShell.of(context).onExit
// when "Select Partner" is chosen. Kept as its own widget/controller pair so
// future partner-related rows can be appended without touching the trigger.
//
// The anchored popup MUST be wrapped in `Positioned` inside the overlay's
// Stack: an Overlay gives non-Positioned children the full screen size, so
// without it the popup card stretches to cover the whole page.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:citizenone_app/modules/insurance/app.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/assets/app_assets.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_spacing.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

class PartnerSelectionPopup extends StatelessWidget {
  const PartnerSelectionPopup({super.key, required this.onSelectPartner});

  final VoidCallback onSelectPartner;

  static const double width = 280;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSelectPartner,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceSoft,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppAssets.iconPeopleSwap,
                  package: AppConfig.packageName,
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Expanded(
                child: AppText(
                  'Select Partner',
                  style: AppTextStyle.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Owns the LayerLink used to anchor the popup under its trigger and the
/// open/close lifecycle. One instance per trigger avoids duplicate overlays.
class PartnerSelectionMenuController {
  final LayerLink layerLink = LayerLink();

  final GlobalKey<_PartnerMenuOverlayState> _overlayKey =
      GlobalKey<_PartnerMenuOverlayState>();
  OverlayEntry? _overlayEntry;

  bool get isOpen => _overlayEntry != null;

  /// Opens the menu, or closes it if it is already open (re-tapping the
  /// trigger toggles it shut).
  Future<void> toggle(BuildContext context) async {
    if (isOpen) {
      await close();
      return;
    }
    if (context.isMobile) {
      await _openBottomSheet(context);
    } else {
      _openOverlay(context);
    }
  }

  void _openOverlay(BuildContext context) {
    if (isOpen) return;

    _overlayEntry = OverlayEntry(
      builder: (overlayContext) => _PartnerMenuOverlay(
        key: _overlayKey,
        layerLink: layerLink,
        onDismissed: _removeEntry,
        onSelectPartner: () {
          if (context.mounted) {
            AppShell.of(context).onExit();
          }
        },
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeEntry() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Plays the exit animation before removing the overlay, if it's open.
  Future<void> close() async {
    final state = _overlayKey.currentState;
    if (state != null) {
      await state.requestClose();
    } else {
      _removeEntry();
    }
  }

  Future<void> _openBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (sheetContext) => SafeArea(
        top: false,
        child: PartnerSelectionPopup(
          onSelectPartner: () {
            Navigator.of(sheetContext).pop();
            AppShell.of(context).onExit();
          },
        ),
      ),
    );
  }
}

class _PartnerMenuOverlay extends StatefulWidget {
  const _PartnerMenuOverlay({
    super.key,
    required this.layerLink,
    required this.onDismissed,
    required this.onSelectPartner,
  });

  final LayerLink layerLink;
  final VoidCallback onDismissed;
  final VoidCallback onSelectPartner;

  @override
  State<_PartnerMenuOverlay> createState() => _PartnerMenuOverlayState();
}

class _PartnerMenuOverlayState extends State<_PartnerMenuOverlay> {
  static const _duration = Duration(milliseconds: 180);

  bool _visible = false;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
  }

  Future<void> requestClose() async {
    if (_closing) return;
    _closing = true;
    if (mounted) setState(() => _visible = false);
    await Future<void>.delayed(_duration);
    widget.onDismissed();
  }

  void _handleSelectPartner() {
    requestClose();
    widget.onSelectPartner();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: requestClose,
          ),
        ),
        // `Positioned` (not a bare Stack child) so the Overlay's theatre
        // sizes this to its content instead of stretching it full-screen.
        Positioned(
          width: PartnerSelectionPopup.width,
          child: CompositedTransformFollower(
            link: widget.layerLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomRight,
            followerAnchor: Alignment.topRight,
            offset: const Offset(0, 8),
            child: Align(
              alignment: Alignment.topRight,
              child: AnimatedScale(
                scale: _visible ? 1 : 0.92,
                duration: _duration,
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  opacity: _visible ? 1 : 0,
                  duration: _duration,
                  curve: Curves.easeOutCubic,
                  child: Shortcuts(
                    shortcuts: const {
                      SingleActivator(LogicalKeyboardKey.escape):
                          DismissIntent(),
                    },
                    child: Actions(
                      actions: {
                        DismissIntent: CallbackAction<DismissIntent>(
                          onInvoke: (_) {
                            requestClose();
                            return null;
                          },
                        ),
                      },
                      child: FocusScope(
                        autofocus: true,
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusLg),
                              boxShadow: AppColors.shadowMd,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: PartnerSelectionPopup(
                              onSelectPartner: _handleSelectPartner,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
