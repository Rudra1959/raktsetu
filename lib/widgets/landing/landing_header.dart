import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

enum LandingSection { hero, process, facilities, problem, donate }

class LandingHeader extends StatelessWidget implements PreferredSizeWidget {
  final ValueChanged<LandingSection> onNavigate;
  final VoidCallback onRequestBlood;
  final VoidCallback onBecomeDonor;

  const LandingHeader({
    super.key,
    required this.onNavigate,
    required this.onRequestBlood,
    required this.onBecomeDonor,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 920;
    
    return PreferredSize(
      preferredSize: const Size.fromHeight(86),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 86,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              border: Border(bottom: BorderSide(color: RaktSetuTheme.line.withValues(alpha: 0.2))),
            ),
            child: Row(
              children: [
                _HeaderLogo(),
                const Spacer(),
                if (!isCompact) ...[
                  _HeaderLink(
                    label: 'How it works',
                    onTap: () => onNavigate(LandingSection.process),
                  ),
                  _HeaderLink(
                    label: 'Facilities',
                    onTap: () => onNavigate(LandingSection.facilities),
                  ),
                  _HeaderLink(
                    label: 'The Problem',
                    onTap: () => onNavigate(LandingSection.problem),
                  ),
                  _HeaderLink(
                    label: 'Donate',
                    onTap: () => onNavigate(LandingSection.donate),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    height: 48,
                    width: 156,
                    child: OutlinedButton(
                      onPressed: onRequestBlood,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('REQUEST BLOOD'),
                    ),
                  ),
                ],
                const SizedBox(width: 12),
                SizedBox(
                  height: 48,
                  width: isCompact ? 164 : 164,
                  child: ElevatedButton(
                    onPressed: onBecomeDonor,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('JOIN NETWORK'),
                  ),
                ),
                if (isCompact) ...[
                  const SizedBox(width: 8),
                  PopupMenuButton<LandingSection>(
                    icon: const Icon(Icons.menu_rounded),
                    tooltip: 'Sections',
                    onSelected: onNavigate,
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: LandingSection.process,
                        child: Text('How it works'),
                      ),
                      PopupMenuItem(
                        value: LandingSection.facilities,
                        child: Text('Facilities'),
                      ),
                      PopupMenuItem(
                        value: LandingSection.problem,
                        child: Text('The Problem'),
                      ),
                      PopupMenuItem(
                        value: LandingSection.donate,
                        child: Text('Donate'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(86);
}

class _HeaderLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: RaktSetuTheme.primaryRed,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          'RaktSetu',
          style: GoogleFonts.cormorantGaramond(
            color: RaktSetuTheme.ink,
            fontWeight: FontWeight.w900,
            fontSize: 30,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}


class _HeaderLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _HeaderLink({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: RaktSetuTheme.textSoft,
        ),
      ),
    );
  }
}
