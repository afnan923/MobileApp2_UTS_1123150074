import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;

  const AuthHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? Colors.amber; // 🔥 default biar hidup

    return Column(
      children: [
        // 🧊 ICON CONTAINER (GLASS)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Icon(
            icon,
            size: 48,
            color: color,
          ),
        ),

        const SizedBox(height: 20),

        // 🎯 TITLE
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white, // 🔥 biar kontras
          ),
        ),

        const SizedBox(height: 8),

        // 📄 SUBTITLE
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70, // 🔥 soft tapi tetap kebaca
          ),
        ),
      ],
    );
  }
}