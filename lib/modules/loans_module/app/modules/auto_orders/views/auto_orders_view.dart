import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auto_orders_controller.dart';

class AutoOrdersView extends GetView<AutoOrdersController> {
  const AutoOrdersView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoOrdersView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AutoOrdersView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
