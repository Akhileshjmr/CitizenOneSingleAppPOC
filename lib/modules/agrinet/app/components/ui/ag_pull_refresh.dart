import 'package:flutter/material.dart';

class AgPullRefresh extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const AgPullRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Colors.black,
      strokeWidth: 2.5,
      child: child,
    );
  }
}
