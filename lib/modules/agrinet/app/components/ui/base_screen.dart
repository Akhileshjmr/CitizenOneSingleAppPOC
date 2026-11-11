import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final double loaderSize;

  const BaseScreen({
    super.key,
    required this.isLoading,
    required this.child,
    this.loaderSize = 35,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: AgLoader());
    }

    return child;
  }
}
