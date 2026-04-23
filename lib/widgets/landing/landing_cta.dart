import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingFooter extends StatelessWidget {
  final VoidCallback onOpenLogin;
  final VoidCallback onOpenRegister;
  final VoidCallback onOpenRequest;

  const LandingFooter({
    super.key,
    required this.onOpenLogin,
    required this.onOpenRegister,
    required this.onOpenRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF151111),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 900;
              final brand = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RaktSetu',
                    style: GoogleFonts.cormorantGaramond(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Text(
                      'Bridging the gap between donors, hospitals, blood banks, and patients across India, one coordinated response at a time.',
                      style: GoogleFonts.manrope(
                        color: Colors.white70,
                        height: 1.7,
                      ),
                    ),
                  ),
                ],
              );

              final links = Wrap(
                spacing: 36,
                runSpacing: 20,
                children: [
                  _FooterColumn(
                    title: 'About',
                    links: [
                      _FooterLinkData('Our Mission', onOpenLogin),
                      _FooterLinkData('How It Works', onOpenRequest),
                      _FooterLinkData('Team', onOpenLogin),
                    ],
                  ),
                  _FooterColumn(
                    title: 'Services',
                    links: [
                      _FooterLinkData('Find Blood', onOpenRequest),
                      _FooterLinkData('Donate Blood', onOpenRegister),
                      _FooterLinkData('Emergency SOS', onOpenRequest),
                    ],
                  ),
                  _FooterColumn(
                    title: 'Contact',
                    links: [
                      _FooterLinkData('1800-00-RAKT', onOpenLogin),
                      _FooterLinkData('hello@raktsetu.in', onOpenLogin),
                      _FooterLinkData('Privacy Policy', onOpenLogin),
                    ],
                  ),
                ],
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (compact) ...[
                    brand,
                    const SizedBox(height: 28),
                    links,
                  ] else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 4, child: brand),
                        Expanded(flex: 6, child: links),
                      ],
                    ),
                  const SizedBox(height: 28),
                  Text(
                    '© 2026 RaktSetu. Made with care for faster blood access across India.',
                    style: GoogleFonts.manrope(
                      color: Colors.white38,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<_FooterLinkData> links;

  const _FooterColumn({
    required this.title,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.manrope(
            color: Colors.white54,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: link.onTap,
              child: Text(
                link.label,
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterLinkData {
  final String label;
  final VoidCallback onTap;

  const _FooterLinkData(this.label, this.onTap);
}
