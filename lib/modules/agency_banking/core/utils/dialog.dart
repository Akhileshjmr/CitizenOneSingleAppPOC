import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoginOptionsDialog(
      BuildContext context, {
        String? title,
        List<String>? loginOptions,
        Function(String)? onLoginSelected,
      }) {
    final screenSize = MediaQuery.of(context).size;
    final isWide = screenSize.width >= 900;

    final List<String> items = loginOptions ??
        ["Individual", "Corporate", "Business", "Agent", "Merchant"];

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black38,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Stack(
            children: [
              // 🔹 Full-screen transparent layer to detect outside taps
              GestureDetector(
                onTap: () => Navigator.of(context).pop(), // ✅ dismiss on outside tap
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),

              // 🔹 Actual top-aligned dialog content
              Align(
                alignment: isWide
                    ? const Alignment(1.0, -0.4)
                    : const Alignment(0.0, -0.4),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    width: isWide
                        ? screenSize.width * 0.3
                        : screenSize.width * 0.8,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (title != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Flexible(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: items.length,
                            padding:
                            const EdgeInsets.symmetric(vertical: 12),
                            separatorBuilder: (_, __) => const Divider(
                              indent: 18,
                              endIndent: 24,
                            ),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return ListTile(
                                title: Text(item),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    size: 14),
                                onTap: () {
                                  Navigator.pop(context); // close dialog
                                  if (onLoginSelected != null) {
                                    onLoginSelected(item);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => LoginScreen(),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}