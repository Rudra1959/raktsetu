import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../models/request_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/request_provider.dart';

class EmergencySOSScreen extends StatefulWidget {
  const EmergencySOSScreen({super.key});

  @override
  State<EmergencySOSScreen> createState() => _EmergencySOSScreenState();
}

class _EmergencySOSScreenState extends State<EmergencySOSScreen> with TickerProviderStateMixin {
  bool _isSending = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Intense Pulse
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        RaktSetuTheme.primaryRed.withValues(alpha: 0.4 * _pulseController.value),
                        Colors.black,
                      ],
                      radius: 0.8 + 0.4 * _pulseController.value,
                    ),
                  ),
                );
              },
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  foregroundColor: Colors.white,
                  centerTitle: true,
                  title: Text(
                    'CRITICAL DISPATCH',
                    style: GoogleFonts.manrope(fontWeight: FontWeight.w900, letterSpacing: 4, fontSize: 12, color: RaktSetuTheme.primaryRed),
                  ),
                ),
                
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: RaktSetuTheme.primaryRed.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: RaktSetuTheme.primaryRed, width: 2),
                          ),
                          child: const Icon(Icons.warning_rounded, color: RaktSetuTheme.primaryRed, size: 48),
                        ).animate(onPlay: (c) => c.repeat()).shake(duration: 800.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1)),
                        
                        const SizedBox(height: 48),
                        
                        Text(
                          'One tap starts\ninstant matching.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 64,
                            height: 0.9,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
                        
                        const SizedBox(height: 24),
                        
                        Text(
                          'We will alert every donor in your area and track your location for emergency dispatch.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 16,
                            height: 1.6,
                            fontWeight: FontWeight.w600,
                          ),
                        ).animate().fadeIn(delay: 400.ms),
                        
                        const SizedBox(height: 80),
                        
                        GestureDetector(
                          onTap: _isSending ? null : _sendSOS,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Ripple Layers
                              ...List.generate(3, (index) {
                                return AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, child) {
                                    final progress = (_pulseController.value + (index * 0.3)) % 1.0;
                                    return Container(
                                      width: 200 + (150 * progress),
                                      height: 200 + (150 * progress),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: RaktSetuTheme.primaryRed.withValues(alpha: 1 - progress),
                                          width: 2,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                              
                              // Main Button
                              Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Color(0xFFFF2D55), Color(0xFF8B0000)],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: RaktSetuTheme.primaryRed.withValues(alpha: 0.6),
                                      blurRadius: 50,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: _isSending
                                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 5)
                                      : Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.emergency_rounded, color: Colors.white, size: 48),
                                            const SizedBox(height: 8),
                                            Text(
                                              'SOS',
                                              style: GoogleFonts.manrope(
                                                color: Colors.white,
                                                fontSize: 56,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 4,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 80),
                        
                        Text(
                          'HOLD FOR 2 SECONDS TO CONFIRM',
                          style: GoogleFonts.manrope(
                            color: Colors.white.withValues(alpha: 0.3),
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 2,
                          ),
                        ).animate(onPlay: (c) => c.repeat()).fadeIn(duration: 1.seconds).fadeOut(duration: 1.seconds),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendSOS() async {
    final auth = context.read<RaktSetuAuthProvider>();
    final requests = context.read<RequestProvider>();
    final user = auth.userProfile;

    if (auth.firebaseUser == null) { Navigator.pushReplacementNamed(context, AppRoutes.login); return; }
    if (user == null || !auth.isProfileComplete) { Navigator.pushReplacementNamed(context, AppRoutes.register); return; }

    setState(() => _isSending = true);

    final request = RequestModel(
      id: '',
      requesterId: auth.firebaseUser!.uid,
      patientName: user.name.isEmpty ? 'Emergency Dispatch' : user.name,
      bloodGroup: user.bloodGroup,
      units: 1,
      urgencyScore: 98,
      condition: 'critical',
      hospital: const HospitalInfo(name: 'Auto-detecting Location...', address: 'Emergency Coordinator alert sent.'),
      requestedAt: DateTime.now(),
    );

    final requestId = await requests.createRequest(request);
    if (!mounted) return;
    setState(() => _isSending = false);
    if (requestId != null) Navigator.pushReplacementNamed(context, AppRoutes.requestStatus);
  }
}
