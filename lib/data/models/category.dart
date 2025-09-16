import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<SubcategoryModel> subcategories;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.subcategories,
  });
}

class SubcategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  SubcategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}
