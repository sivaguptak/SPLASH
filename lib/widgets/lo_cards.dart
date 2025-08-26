import 'package:flutter/material.dart';
import '../core/theme.dart';

class HeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  const HeaderCard({super.key, required this.title, required this.subtitle, this.trailing});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: LocsyColors.navy, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Colors.white70)),
        ])),
        if (trailing != null) trailing!,
      ]),
    );
  }
}
