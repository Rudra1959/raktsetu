import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

class LandingHeader extends StatelessWidget implements PreferredSizeWidget {
  const LandingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      title: Text(
        'RaktSetu',
        style: GoogleFonts.inter(
          color: RaktSetuTheme.primaryRed,
          fontWeight: FontWeight.w900,
          fontSize: 24,
        ),
      ),
      actions: [
        _NavButton(title: 'Home', onPressed: () {}),
        _NavButton(title: 'Request', onPressed: () {}),
        _NavButton(title: 'Donate', onPressed: () {}),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NavButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _NavButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
