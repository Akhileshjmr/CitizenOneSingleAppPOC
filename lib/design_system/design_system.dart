/// Citizen One Design System — Atomic Architecture
///
/// Import this single file to access the complete component library:
///   import 'package:citizenone_app/design_system/design_system.dart';
///
/// Hierarchy:
///   Atoms     → indivisible base components
///   Molecules → atoms composed with standardised behaviour
///   Organisms → reusable screen sections built from molecules
///   Templates → full page layout shells
///   Models    → shared data transfer objects used by organisms
library;

// ── Atoms ────────────────────────────────────────────────────────────────────
export 'atoms/app_text.dart';
export 'atoms/app_button.dart';
export 'atoms/app_icon.dart';
export 'atoms/app_icon_button.dart';
export 'atoms/app_text_field.dart';
export 'atoms/app_badge.dart';
export 'atoms/app_avatar.dart';
export 'atoms/app_loader.dart';
export 'atoms/app_chip.dart';
export 'atoms/app_divider.dart';
export 'atoms/app_vertical_divider.dart';
export 'atoms/glass_container.dart';
export 'atoms/press_scale_widget.dart';
export 'atoms/hover_card.dart';
export 'atoms/success_check_animation.dart';
export 'atoms/animated_input_wrapper.dart';

// ── Molecules ─────────────────────────────────────────────────────────────────
export 'molecules/labeled_text_field.dart';
export 'molecules/search_field.dart';
export 'molecules/amount_input_field.dart';
export 'molecules/form_field_group.dart';
export 'molecules/section_header.dart';
export 'molecules/quick_action_button.dart';
export 'molecules/service_list_tile.dart';
export 'molecules/action_list_tile.dart';
export 'molecules/info_row.dart';
export 'molecules/stat_tile.dart';
export 'molecules/hero_role_chip.dart';
export 'molecules/hero_metric_block.dart';

// ── Organisms ─────────────────────────────────────────────────────────────────
export 'organisms/service_section_card.dart';
export 'organisms/service_grid_section.dart';
export 'organisms/staggered_list.dart';
export 'organisms/mini_service_scaffold.dart';
export 'organisms/hero_card_shell.dart';
export 'organisms/ai_insight_card.dart';
export 'organisms/ai_insight_section_header.dart';

// ── Models ────────────────────────────────────────────────────────────────────
export 'models/quick_action_data.dart';
export 'models/service_list_data.dart';

// ── Templates ─────────────────────────────────────────────────────────────────
export 'templates/app_page_scaffold.dart';
export 'templates/service_page_template.dart';

// ── Shared Architecture Foundations ─────────────────────────────────────────
export 'tokens/app_palette.dart';
export 'tokens/app_color_tokens.dart';
export 'tokens/theme_context_extension.dart';
export 'molecules/app_card.dart';
export 'molecules/module_switcher_bar.dart';
export 'molecules/performance_yield_chart_card.dart';
export 'organisms/app_error_view.dart';
export 'typography/app_typography.dart';
export 'spacing/app_spacing.dart';
export 'layout/app_layout_grid.dart';
export 'layout/app_shell.dart';
export 'theme/app_theme.dart';
