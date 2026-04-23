import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

class LandingFeatures extends StatelessWidget {
  final GlobalKey processKey;
  final GlobalKey facilitiesKey;
  final GlobalKey problemKey;
  final GlobalKey donorKey;
  final VoidCallback onRequestBlood;
  final VoidCallback onBecomeDonor;

  const LandingFeatures({
    super.key,
    required this.processKey,
    required this.facilitiesKey,
    required this.problemKey,
    required this.donorKey,
    required this.onRequestBlood,
    required this.onBecomeDonor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionLabel('Network at a glance'),
              const SizedBox(height: 10),
              const _SectionHeadline('A living network,\nsaving lives in real time'),
              const SizedBox(height: 26),
              LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 860;
                  const cards = [
                    _MetricCard(
                      value: '1,284',
                      label: 'connected centres across India',
                      icon: Icons.apartment_rounded,
                    ),
                    _MetricCard(
                      value: '628',
                      label: 'blood banks registered and active',
                      icon: Icons.local_hospital_outlined,
                    ),
                    _MetricCard(
                      value: '2,340',
                      label: 'units available of needed blood now',
                      icon: Icons.water_drop_outlined,
                      emphasized: true,
                    ),
                    _MetricCard(
                      value: '54K+',
                      label: 'registered donors ready to serve',
                      icon: Icons.favorite_border,
                    ),
                  ];

                  if (compact) {
                    return Column(
                      children: cards
                          .map((card) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: SizedBox(width: double.infinity, child: card),
                              ),)
                          .toList(),
                    );
                  }

                  return Row(
                    children: List.generate(cards.length, (index) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: index == cards.length - 1 ? 0 : 18),
                          child: cards[index],
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          key: processKey,
          child: _SectionShell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionLabel('The process'),
                const SizedBox(height: 10),
                const _SectionHeadline('From donor to patient,\nin four seamless steps'),
                const SizedBox(height: 28),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 900;
                    final steps = [
                      const _StepData(
                        title: 'Donor Registers',
                        description:
                            'Donors sign up with their blood type, location, and availability on RaktSetu.',
                        icon: Icons.person_outline_rounded,
                      ),
                      const _StepData(
                        title: 'Blood Bank Collects',
                        description:
                            'Nearby blood banks are notified, triaged, and kept live in sync.',
                        icon: Icons.inventory_2_outlined,
                      ),
                      const _StepData(
                        title: 'Hospital Requests',
                        description:
                            'Hospitals submit live inventory and place verified requests in seconds.',
                        icon: Icons.local_hospital_outlined,
                      ),
                      const _StepData(
                        title: 'Patient Receives',
                        description:
                            'Matched blood reaches the patient on time, with end-to-end tracking.',
                        icon: Icons.favorite_outline,
                      ),
                    ];

                    return compact
                        ? Column(
                            children: steps
                                .map((step) => Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: _ProcessCard(step: step),
                                    ),)
                                .toList(),
                          )
                        : Row(
                            children: [
                              Expanded(child: _ProcessCard(step: steps[0])),
                              _ProcessArrow(),
                              Expanded(child: _ProcessCard(step: steps[1])),
                              _ProcessArrow(),
                              Expanded(child: _ProcessCard(step: steps[2])),
                              _ProcessArrow(),
                              Expanded(child: _ProcessCard(step: steps[3])),
                            ],
                          );
                  },
                ),
              ],
            ),
          ),
        ),
        Container(
          key: facilitiesKey,
          child: _SectionShell(
            shaded: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionLabel('Live directory'),
                const SizedBox(height: 10),
                const _SectionHeadline('Find blood near you,\nright when you need it'),
                const SizedBox(height: 26),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 980;
                    const mapPanel = _FacilityMapPanel();
                    const listPanel = _FacilityListPanel();

                    if (compact) {
                      return const Column(
                        children: [
                          mapPanel,
                          SizedBox(height: 18),
                          listPanel,
                        ],
                      );
                    }

                    return const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: _FacilityMapPanel()),
                        SizedBox(width: 18),
                        Expanded(flex: 5, child: _FacilityListPanel()),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Container(
          key: problemKey,
          child: _SectionShell(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 980;
                const left = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel('The problem'),
                    SizedBox(height: 10),
                    _SectionHeadline('India\'s blood crisis is\na distribution problem'),
                    SizedBox(height: 24),
                    _ProblemPoint(
                      title: '40 million units short every year',
                      body: 'India needs real-time visibility, not delayed phone trees and static spreadsheets.',
                    ),
                    SizedBox(height: 18),
                    _ProblemPoint(
                      title: 'No unified geography of supply',
                      body: 'Patients cannot see which bank has stock or which donor is ready nearby.',
                    ),
                    SizedBox(height: 18),
                    _ProblemPoint(
                      title: 'Wastage from poor coordination',
                      body: 'Blood expires when hospitals, camps, and donors are disconnected from the same signal.',
                    ),
                  ],
                );

                const right = Column(
                  children: [
                    _ChartCard(
                      title: 'Blood availability vs late demand',
                    ),
                    SizedBox(height: 18),
                    _DemandDistributionCard(),
                  ],
                );

                if (compact) {
                  return const Column(
                    children: [
                      left,
                      SizedBox(height: 24),
                      right,
                    ],
                  );
                }

                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: left),
                    SizedBox(width: 28),
                    Expanded(flex: 6, child: right),
                  ],
                );
              },
            ),
          ),
        ),
        Container(
          key: donorKey,
          child: _SectionShell(
            shaded: true,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 980;
                final left = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionLabel('Become a donor'),
                    const SizedBox(height: 10),
                    const _SectionHeadline('Your blood.\nSomeone\'s life tomorrow.'),
                    const SizedBox(height: 24),
                    const _ProblemPoint(
                      title: 'One donation, three lives',
                      body: 'A single donation can support red cells, plasma, and platelets for different patients.',
                    ),
                    const SizedBox(height: 18),
                    const _ProblemPoint(
                      title: 'Safe and monitored',
                      body: 'Every donor goes through eligibility screening and post-donation guidance.',
                    ),
                    const SizedBox(height: 18),
                    const _ProblemPoint(
                      title: 'Donate every 3 months',
                      body: 'Healthy donors can return on a medically safe cadence and build long-term impact.',
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE3E1),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Text(
                        '54,000+ donors have already joined the RaktSetu network. Every new donor expands the radius of hope.',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                          color: RaktSetuTheme.primaryDark,
                        ),
                      ),
                    ),
                  ],
                );

                final right = _DonorFormCard(onBecomeDonor: onBecomeDonor);

                if (compact) {
                  return Column(
                    children: [
                      left,
                      const SizedBox(height: 24),
                      right,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: left),
                    const SizedBox(width: 28),
                    Expanded(flex: 6, child: right),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionShell extends StatelessWidget {
  final Widget child;
  final bool shaded;

  const _SectionShell({
    required this.child,
    this.shaded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: shaded ? const Color(0xFFF4ECE4) : RaktSetuTheme.paper,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 54),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: child,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: RaktSetuTheme.primaryRed,
        letterSpacing: 2.0,
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0);
  }
}

class _SectionHeadline extends StatelessWidget {
  final String text;

  const _SectionHeadline(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.cormorantGaramond(
        fontSize: 62,
        height: 0.94,
        fontWeight: FontWeight.w900,
        color: RaktSetuTheme.ink,
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 800.ms).slideY(begin: 0.1, end: 0);
  }
}

class _MetricCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final bool emphasized;

  const _MetricCard({
    required this.value,
    required this.label,
    required this.icon,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: emphasized ? RaktSetuTheme.primaryRed : Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: emphasized 
              ? RaktSetuTheme.primaryRed.withValues(alpha: 0.3) 
              : Colors.black.withValues(alpha: 0.04),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: emphasized ? Colors.white.withValues(alpha: 0.2) : RaktSetuTheme.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: emphasized ? Colors.white : RaktSetuTheme.primaryRed,
              size: 28,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            value,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: emphasized ? Colors.white : RaktSetuTheme.ink,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 14,
              height: 1.5,
              color: emphasized ? Colors.white70 : RaktSetuTheme.textSoft,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }
}

class _StepData {
  final String title;
  final String description;
  final IconData icon;

  const _StepData({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class _ProcessCard extends StatelessWidget {
  final _StepData step;

  const _ProcessCard({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: RaktSetuTheme.line),
      ),
      child: Column(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: const BoxDecoration(
              color: RaktSetuTheme.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(step.icon, color: RaktSetuTheme.primaryRed, size: 34),
          ),
          const SizedBox(height: 18),
          Text(
            step.title,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: RaktSetuTheme.ink,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            step.description,
            style: GoogleFonts.manrope(
              color: RaktSetuTheme.textSoft,
              height: 1.55,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProcessArrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Icon(
        Icons.arrow_forward_rounded,
        color: RaktSetuTheme.accentRose.withValues(alpha: 0.75),
      ),
    );
  }
}

class _FacilityMapPanel extends StatelessWidget {
  const _FacilityMapPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: RaktSetuTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Facility Map',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              const _MapPill(label: 'Blood Banks'),
              const SizedBox(width: 8),
              const _MapPill(label: 'Hospitals'),
              const SizedBox(width: 8),
              const _MapPill(label: 'Camps'),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            height: 338,
            decoration: BoxDecoration(
              color: const Color(0xFFF6EBDD),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MapBackdropPainter(),
                  ),
                ),
                const Positioned(top: 90, left: 210, child: _MapDot(color: Color(0xFFE53935))),
                const Positioned(top: 120, left: 180, child: _MapDot(color: Color(0xFF1E88E5))),
                const Positioned(top: 142, left: 222, child: _MapDot(color: Color(0xFF43A047))),
                const Positioned(top: 182, left: 170, child: _MapDot(color: Color(0xFFE53935))),
                const Positioned(top: 210, left: 240, child: _MapDot(color: Color(0xFF1E88E5))),
                const Positioned(top: 162, left: 286, child: _MapDot(color: Color(0xFFE53935))),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _Legend(label: 'Blood Bank', color: Color(0xFFE53935)),
              _Legend(label: 'Hospital', color: Color(0xFF1E88E5)),
              _Legend(label: 'Donor Camp', color: Color(0xFF43A047)),
            ],
          ),
        ],
      ),
    );
  }
}

class _FacilityListPanel extends StatelessWidget {
  const _FacilityListPanel();

  @override
  Widget build(BuildContext context) {
    const entries = [
      ('Rotary Blood Bank', 'Open now • 2.3 km • Delhi', true),
      ('AIIMS New Delhi', 'Open 24/7 • 4.0 km • Delhi', false),
      ('Red Cross Camp, Delhi', 'Active till 8 PM • 4.9 km • Delhi', false),
      ('Lions Blood Bank', 'Open now • 7.1 km • Mumbai', false),
      ('Tata Memorial Hospital', 'Open 24/7 • 8.4 km • Mumbai', false),
      ('Indian Red Cross Kolkata', 'Open now • 11 km • Kolkata', false),
    ];

    return Column(
      children: entries
          .asMap()
          .entries
          .map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                  border: Border.all(
                    color: entry.value.$3 ? RaktSetuTheme.primaryRed.withValues(alpha: 0.3) : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: RaktSetuTheme.successGreen,
                          shape: BoxShape.circle,
                        ),
                      ).animate(onPlay: (c) => c.repeat()).scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.3, 1.3),
                            duration: 1.seconds,
                          ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.value.$1,
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w900,
                                fontSize: 17,
                                color: RaktSetuTheme.ink,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              entry.value.$2,
                              style: GoogleFonts.manrope(
                                color: RaktSetuTheme.textSoft,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: RaktSetuTheme.line),
                    ],
                  ),
                ).animate().fadeIn(delay: (entry.key * 100).ms).slideX(begin: 0.05, end: 0),
              ),)
          .toList(),
    );
  }
}

class _ProblemPoint extends StatelessWidget {
  final String title;
  final String body;

  const _ProblemPoint({
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          margin: const EdgeInsets.only(top: 4),
          decoration: const BoxDecoration(
            color: RaktSetuTheme.primaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.priority_high_rounded, color: RaktSetuTheme.primaryRed, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w800,
                  color: RaktSetuTheme.ink,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                body,
                style: GoogleFonts.manrope(
                  color: RaktSetuTheme.textSoft,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;

  const _ChartCard({required this.title});

  @override
  Widget build(BuildContext context) {
    final bars = [78, 54, 88, 52, 44, 38, 30];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: RaktSetuTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(bars.length, (index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: bars[index].toDouble(),
                          decoration: BoxDecoration(
                            color: index.isEven
                                ? RaktSetuTheme.primaryRed.withValues(alpha: 0.82)
                                : RaktSetuTheme.accentRose.withValues(alpha: 0.72),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+'][index],
                          style: GoogleFonts.manrope(
                            color: RaktSetuTheme.textSoft,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _DemandDistributionCard extends StatelessWidget {
  const _DemandDistributionCard();

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('O+', 0.37),
      ('A+', 0.28),
      ('B+', 0.20),
      ('AB+', 0.08),
      ('Others', 0.07),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: RaktSetuTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Blood type demand distribution',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 18),
          ...rows.map((row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: Text(
                      row.$1,
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        color: RaktSetuTheme.ink,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: row.$2,
                        minHeight: 8,
                        backgroundColor: RaktSetuTheme.paperWarm,
                        valueColor: const AlwaysStoppedAnimation(RaktSetuTheme.primaryRed),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${(row.$2 * 100).round()}%',
                    style: GoogleFonts.manrope(
                      color: RaktSetuTheme.textSoft,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DonorFormCard extends StatelessWidget {
  final VoidCallback onBecomeDonor;

  const _DonorFormCard({required this.onBecomeDonor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: RaktSetuTheme.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Donor Registration',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: RaktSetuTheme.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Takes less than 2 minutes. We\'ll match you with nearby needs.',
            style: GoogleFonts.manrope(
              color: RaktSetuTheme.textSoft,
            ),
          ),
          const SizedBox(height: 18),
          const _MockField(label: 'First Name', value: 'Rahul'),
          const SizedBox(height: 12),
          const _MockField(label: 'Last Name', value: 'Sharma'),
          const SizedBox(height: 12),
          const _MockField(label: 'Email Address', value: 'rahul@gmail.com'),
          const SizedBox(height: 12),
          const _MockField(label: 'Phone Number', value: '+91 XXXXX XXXXX'),
          const SizedBox(height: 12),
          const _MockField(label: 'City', value: 'Delhi'),
          const SizedBox(height: 12),
          const _MockField(label: 'Date of Birth', value: 'MM/DD/YYYY'),
          const SizedBox(height: 16),
          Text(
            'Blood Type',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w700,
              color: RaktSetuTheme.ink,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                .map((group) => _BloodChip(label: group))
                .toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'I confirm I am 18+ years old, weigh above 50 kg, and consent to be contacted for donation requests.',
            style: GoogleFonts.manrope(
              color: RaktSetuTheme.textSoft,
              fontSize: 12.5,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: onBecomeDonor,
            child: const Text('Register as Donor'),
          ),
        ],
      ),
    );
  }
}

class _MockField extends StatelessWidget {
  final String label;
  final String value;

  const _MockField({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            color: RaktSetuTheme.textSoft,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF9F6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: RaktSetuTheme.line),
          ),
          child: Text(
            value,
            style: GoogleFonts.manrope(
              color: RaktSetuTheme.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _MapPill extends StatelessWidget {
  final String label;

  const _MapPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F3ED),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: RaktSetuTheme.line),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 11,
          color: RaktSetuTheme.textSoft,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final String label;
  final Color color;

  const _Legend({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: RaktSetuTheme.textSoft,
          ),
        ),
      ],
    );
  }
}

class _MapDot extends StatelessWidget {
  final Color color;

  const _MapDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.24),
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
    );
  }
}

class _BloodChip extends StatelessWidget {
  final String label;

  const _BloodChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: RaktSetuTheme.line),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w700,
          color: RaktSetuTheme.primaryRed,
        ),
      ),
    );
  }
}

class _MapBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = const Color(0xFFE8DDCF);
    final outline = Paint()
      ..color = const Color(0xFFD7C6B3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final path = Path()
      ..moveTo(size.width * 0.24, size.height * 0.12)
      ..quadraticBezierTo(size.width * 0.42, size.height * 0.02, size.width * 0.72, size.height * 0.16)
      ..quadraticBezierTo(size.width * 0.9, size.height * 0.42, size.width * 0.74, size.height * 0.74)
      ..quadraticBezierTo(size.width * 0.56, size.height * 0.94, size.width * 0.34, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.08, size.height * 0.56, size.width * 0.14, size.height * 0.28)
      ..close();

    canvas.drawPath(path, fill);
    canvas.drawPath(path, outline);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
