import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:go_router/go_router.dart';

class AIAssistantScreen extends StatelessWidget {
  const AIAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        elevation: 0,
        title: Row(
          children: [
            Icon(LucideIcons.sparkles, color: tokens.brandBlue, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  context.l10n.aiAssistantTitle,
                  style: AppTextStyle.bodyLarge,
                  fontWeight: FontWeight.bold,
                  color: tokens.textPrimary,
                ),
                AppText(
                  context.l10n.aiAssistantTagline,
                  style: AppTextStyle.labelSmall,
                  fontSize: 10,
                  color: tokens.textSecondary,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: tokens.textSecondary),
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildMessage(
                  context: context,
                  isUser: false,
                  content: context.l10n.aiMessageGreeting('Mahesh'),
                ),
                _buildMessage(
                  context: context,
                  isUser: true,
                  content: context.l10n.aiMessageUserReply,
                ),
                _buildMessage(
                  context: context,
                  isUser: false,
                  content: context.l10n.aiMessageLoanDetails,
                  hasAction: true,
                ),
              ],
            ),
          ),
          _buildInputArea(context),
        ],
      ),
    );
  }

  Widget _buildMessage({
    required BuildContext context,
    required bool isUser,
    required String content,
    bool hasAction = false,
  }) {
    final tokens = context.appTokens;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: tokens.brandBlue,
              radius: 16,
              child: const Icon(
                LucideIcons.sparkles,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUser ? tokens.brandBlue : tokens.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: isUser
                          ? const Radius.circular(20)
                          : const Radius.circular(4),
                      bottomRight: isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(20),
                    ),
                    boxShadow: isUser ? [] : tokens.shadowSm,
                  ),
                  child: AppText(
                    content,
                    style: AppTextStyle.bodyMedium,
                    color: isUser ? Colors.white : tokens.textPrimary,
                  ),
                ),
                if (hasAction && !isUser) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      AppButton(
                        text: context.l10n.aiActionApplyNow,
                        onPressed: () {},
                        variant: AppButtonVariant.outline,
                        foregroundColor: tokens.brandBlue,
                        backgroundColor: tokens.brandBlue,
                        width: null,
                        height: 40,
                      ),
                      AppButton(
                        text: context.l10n.aiActionCompare,
                        onPressed: () {},
                        variant: AppButtonVariant.outline,
                        foregroundColor: tokens.textSecondary,
                        backgroundColor: tokens.outline,
                        width: null,
                        height: 40,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    final tokens = context.appTokens;
    return Container(
      padding: const EdgeInsets.all(16),
      color: tokens.surface,
      child: Row(
        children: [
          Expanded(
            child: AppTextField(hintText: context.l10n.aiAssistantInputHint),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: tokens.brandBlue,
            radius: 24,
            child: IconButton(
              icon: const Icon(LucideIcons.send, color: Colors.white, size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
