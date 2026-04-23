import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  String _selectedRole = 'donor';
  String _selectedBloodGroup = 'O+';

  @override
  void initState() {
    super.initState();
    final auth = context.read<RaktSetuAuthProvider>();
    _nameController.text = auth.userProfile?.name ?? auth.firebaseUser?.displayName ?? '';
    _cityController.text = auth.userProfile?.city ?? '';
    _selectedBloodGroup = auth.userProfile?.bloodGroup ?? 'O+';
    _selectedRole = auth.userProfile?.role == 'hospital_admin' ? 'patient' : (auth.userProfile?.role ?? 'donor');
  }

  @override
  void dispose() { _nameController.dispose(); _cityController.dispose(); super.dispose(); }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<RaktSetuAuthProvider>();
    final success = await auth.completeProfile(
      name: _nameController.text.trim(),
      role: _selectedRole,
      bloodGroup: _selectedBloodGroup,
      city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
    );
    if (!mounted || !success) return;
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<RaktSetuAuthProvider>(context);

    return Scaffold(
      backgroundColor: RaktSetuTheme.paper,
      body: Stack(
        children: [
          // Animated Organic Background
          Positioned(top: -150, right: -150, child: _AnimatedOrb(color: RaktSetuTheme.primaryRed.withValues(alpha: 0.12), size: 600)),
          Positioned(bottom: -200, left: -100, child: _AnimatedOrb(color: RaktSetuTheme.infoBlue.withValues(alpha: 0.08), size: 700)),
          Positioned.fill(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120), child: Container(color: Colors.transparent))),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Identity Setup', 
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 64, 
                          fontWeight: FontWeight.w900, 
                          color: RaktSetuTheme.ink, 
                          height: 0.9,
                        ),
                      ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 16),
                      Text(
                        'Connect your biological profile to the global life-saving grid.', 
                        style: GoogleFonts.manrope(
                          fontSize: 18, 
                          color: RaktSetuTheme.textSoft, 
                          fontWeight: FontWeight.w600,
                        ),
                      ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 56),

                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('OPERATIONAL ALIAS'),
                            _buildTextField(
                              controller: _nameController, 
                              icon: Icons.fingerprint_rounded, 
                              hint: 'Enter your full name',
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 32),

                            _buildLabel('SECTOR LOCATION'),
                            _buildTextField(
                              controller: _cityController, 
                              icon: Icons.radar_rounded,
                              hint: 'e.g. New Delhi, NCR',
                            ),
                            const SizedBox(height: 48),

                            _buildLabel('MISSION PROTOCOL'),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: _RoleCard(title: 'Life Donor', icon: Icons.favorite_rounded, isSelected: _selectedRole == 'donor', onTap: () => setState(() => _selectedRole = 'donor'))),
                                const SizedBox(width: 16),
                                Expanded(child: _RoleCard(title: 'Requestor', icon: Icons.emergency_rounded, isSelected: _selectedRole == 'patient', onTap: () => setState(() => _selectedRole = 'patient'))),
                              ],
                            ),
                            const SizedBox(height: 48),

                            _buildLabel('BIOMETRIC GROUP'),
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: AppConstants.bloodGroups.map((bg) {
                                final isSelected = _selectedBloodGroup == bg;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedBloodGroup = bg),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      color: isSelected ? RaktSetuTheme.primaryRed : Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: isSelected ? [BoxShadow(color: RaktSetuTheme.primaryRed.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))] : [],
                                      border: Border.all(color: isSelected ? RaktSetuTheme.primaryRed : RaktSetuTheme.divider, width: 1.5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        bg, 
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w900, 
                                          fontSize: 18, 
                                          color: isSelected ? Colors.white : RaktSetuTheme.ink,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 64),

                            SizedBox(
                              width: double.infinity,
                              height: 72,
                              child: ElevatedButton(
                                onPressed: auth.isLoading ? null : _submitProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: RaktSetuTheme.ink,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  elevation: 0,
                                ),
                                child: auth.isLoading 
                                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) 
                                  : Text(
                                      'INITIALIZE PROFILE',
                                      style: GoogleFonts.manrope(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 13),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12, left: 4), 
    child: Text(
      text, 
      style: GoogleFonts.manrope(
        fontWeight: FontWeight.w900, 
        fontSize: 11, 
        color: RaktSetuTheme.textSoft, 
        letterSpacing: 2,
      ),
    ),
  );

  Widget _buildTextField({required TextEditingController controller, required IconData icon, required String hint, String? Function(String?)? validator}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w900,
          fontSize: 17,
          color: RaktSetuTheme.ink,
          letterSpacing: -0.5,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.manrope(color: RaktSetuTheme.textSoft.withValues(alpha: 0.5), fontWeight: FontWeight.w700),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(icon, color: RaktSetuTheme.primaryRed, size: 24),
          ),
          filled: true, 
          fillColor: Colors.white, 
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none), 
          contentPadding: const EdgeInsets.symmetric(vertical: 24),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  const _RoleCard({required this.title, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: isSelected ? RaktSetuTheme.ink : Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: isSelected ? [BoxShadow(color: RaktSetuTheme.ink.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))] : [],
          border: Border.all(color: isSelected ? RaktSetuTheme.ink : RaktSetuTheme.divider, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: isSelected ? Colors.white : RaktSetuTheme.primaryRed),
            const SizedBox(height: 16),
            Text(
              title, 
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w900, 
                fontSize: 15, 
                color: isSelected ? Colors.white : RaktSetuTheme.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedOrb extends StatefulWidget {
  final Color color;
  final double size;
  const _AnimatedOrb({required this.color, required this.size});

  @override
  State<_AnimatedOrb> createState() => _AnimatedOrbState();
}

class _AnimatedOrbState extends State<_AnimatedOrb> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.rotate(
        angle: _controller.value * 2 * 3.14, 
        child: Container(
          width: widget.size, 
          height: widget.size * 1.1, 
          decoration: BoxDecoration(
            shape: BoxShape.circle, 
            gradient: RadialGradient(colors: [widget.color, Colors.transparent]),
          ),
        ),
      ),
    );
  }
}

