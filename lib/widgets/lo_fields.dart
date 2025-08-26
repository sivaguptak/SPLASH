import 'package:flutter/material.dart';
import '../core/theme.dart';

InputDecoration loField(String label, {String? hint}) => InputDecoration(
  labelText: label,
  hintText: hint,
  filled: true,
  fillColor: LocsyColors.cream,
  labelStyle: const TextStyle(color: LocsyColors.navy),
  hintStyle: const TextStyle(color: LocsyColors.slate),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: LocsyColors.navy),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: LocsyColors.orange, width: 2),
  ),
);
