// home_menu_model.dart
import 'package:flutter/material.dart';

class MenuItemModel {
  final String title;
  final Widget image;
  final String? route;
  final dynamic arguments;

  const MenuItemModel({
    required this.title,
    required this.image,
    this.route,
    this.arguments,
  });
}

class SectionModel {
  final String title;
  final List<MenuItemModel> items;

  const SectionModel({required this.title, required this.items});
}
