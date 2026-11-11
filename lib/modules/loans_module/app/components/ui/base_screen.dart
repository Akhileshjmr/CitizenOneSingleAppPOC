import 'package:flutter/material.dart';

import 'ag_loader.dart';

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

    return SafeArea(child: Container(child: child));
  }
}
