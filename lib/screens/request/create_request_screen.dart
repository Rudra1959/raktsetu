import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../models/request_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/request_provider.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _hospitalNameController = TextEditingController();
  final _hospitalAddressController = TextEditingController();
  final _notesController = TextEditingController();

  String _bloodGroup = 'O+';
  int _units = 1;
  String _condition = 'standard';

  @override
  void initState() {
    super.initState();
    final auth = context.read<RaktSetuAuthProvider>();
    _patientNameController.text = auth.userProfile?.name ?? '';
    _bloodGroup = auth.userProfile?.bloodGroup ?? 'O+';
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _hospitalNameController.dispose();
    _hospitalAddressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context);

    return Scaffold(
      backgroundColor: RaktSetuTheme.paper,
      body: Stack(
        children: [
          // High-Fidelity Animated Background
          Positioned(top: -100, left: -100, child: _AnimatedOrb(color: RaktSetuTheme.primaryRed.withValues(alpha: 0.08), size: 500)),
          Positioned(bottom: -150, right: -50, child: _AnimatedOrb(color: RaktSetuTheme.infoBlue.withValues(alpha: 0.05), size: 600)),
          Positioned.fill(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120), child: Container(color: Colors.transparent))),
          
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: RaktSetuTheme.ink, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  'NETWORK REQUEST', 
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w900, 
                    color: RaktSetuTheme.ink, 
                    fontSize: 11, 
                    letterSpacing: 2.5,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dispatch Signal',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 64, 
                          fontWeight: FontWeight.w900, 
                          height: 0.9,
                        ),
                      ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 16),
                      Text(
                        'Initiate a high-priority blood request across our global donor network.',
                        style: GoogleFonts.manrope(
                          color: RaktSetuTheme.textSoft, 
                          fontSize: 18, 
                          fontWeight: FontWeight.w600,
                        ),
                      ).animate().fadeIn(delay: 100.ms),
                      const SizedBox(height: 56),
                      
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('BIOMETRIC TARGET'),
                            const SizedBox(height: 16),
                            _buildPremiumTextField(
                              controller: _patientNameController,
                              hint: 'Patient Full Identity',
                              icon: Icons.person_rounded,
                              validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 32),

                            _buildLabel('REQUIRED BLOOD GROUP'),
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: AppConstants.bloodGroups.map((group) {
                                final isSelected = _bloodGroup == group;
                                return GestureDetector(
                                  onTap: () => setState(() => _bloodGroup = group),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                    decoration: BoxDecoration(
                                      color: isSelected ? RaktSetuTheme.primaryRed : Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: isSelected ? [BoxShadow(color: RaktSetuTheme.primaryRed.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))] : [],
                                      border: Border.all(color: isSelected ? RaktSetuTheme.primaryRed : RaktSetuTheme.divider, width: 1.5),
                                    ),
                                    child: Text(
                                      group,
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w900, 
                                        fontSize: 16,
                                        color: isSelected ? Colors.white : RaktSetuTheme.ink,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 32),

                            _buildLabel('QUANTITY (UNITS)'),
                            const SizedBox(height: 20),
                            _buildUnitController(),
                            
                            const SizedBox(height: 56),
                            _buildLabel('EMERGENCY PROTOCOL'),
                            const SizedBox(height: 20),
                            ...['critical', 'urgent', 'standard'].map((condition) => _buildUrgencyCard(condition)),
                            
                            const SizedBox(height: 48),
                            _buildLabel('FACILITY LOGISTICS'),
                            const SizedBox(height: 20),
                            _buildPremiumTextField(
                              controller: _hospitalNameController,
                              hint: 'Hospital or Medical Center Name',
                              icon: Icons.local_hospital_rounded,
                              validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 24),
                            _buildPremiumTextField(
                              controller: _hospitalAddressController,
                              hint: 'Complete Logistic Address',
                              icon: Icons.radar_rounded,
                              maxLines: 2,
                            ),
                            
                            const SizedBox(height: 64),
                            SizedBox(
                              width: double.infinity,
                              height: 72,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: RaktSetuTheme.ink,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  elevation: 0,
                                ),
                                onPressed: requestProvider.isLoading ? null : _submitRequest,
                                child: requestProvider.isLoading
                                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                                    : Text(
                                        'INITIATE NETWORK DISPATCH', 
                                        style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 2),
                                      ),
                              ),
                            ).animate().fadeIn(delay: 400.ms).scale(curve: Curves.easeOutBack),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(left: 4),
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

  Widget _buildPremiumTextField({required TextEditingController controller, required String hint, required IconData icon, int maxLines = 1, String? Function(String?)? validator}) {
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
        maxLines: maxLines,
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

  Widget _buildUnitController() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: RaktSetuTheme.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () { if (_units > 1) setState(() => _units--); },
            icon: const Icon(Icons.remove_circle_outline_rounded, color: RaktSetuTheme.ink, size: 32),
          ),
          Text(
            '$_units', 
            style: GoogleFonts.cormorantGaramond(fontSize: 48, fontWeight: FontWeight.w900, color: RaktSetuTheme.primaryRed),
          ),
          IconButton(
            onPressed: () { if (_units < 10) setState(() => _units++); },
            icon: const Icon(Icons.add_circle_outline_rounded, color: RaktSetuTheme.ink, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgencyCard(String condition) {
    final isSelected = _condition == condition;
    final color = condition == 'critical' ? RaktSetuTheme.primaryRed : (condition == 'urgent' ? Colors.orange : RaktSetuTheme.infoBlue);
    
    return GestureDetector(
      onTap: () => setState(() => _condition = condition),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? RaktSetuTheme.ink : Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: isSelected ? [BoxShadow(color: RaktSetuTheme.ink.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))] : [],
          border: Border.all(color: isSelected ? RaktSetuTheme.ink : RaktSetuTheme.divider, width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.1) : color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? Icons.verified_rounded : Icons.radio_button_off_rounded, 
                color: isSelected ? Colors.white : color,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    condition.toUpperCase(), 
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w900, 
                      color: isSelected ? Colors.white : RaktSetuTheme.ink,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    _getConditionDesc(condition), 
                    style: GoogleFonts.manrope(
                      fontSize: 12, 
                      color: isSelected ? Colors.white70 : RaktSetuTheme.textSoft, 
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getConditionDesc(String condition) {
    switch (condition) {
      case 'critical': return 'Immediate surgical intervention required.';
      case 'urgent': return 'Required within a 6-hour window.';
      default: return 'Standard planned medical procedure.';
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<RaktSetuAuthProvider>();
    final requestProvider = context.read<RequestProvider>();
    final request = RequestModel(
      id: '',
      requesterId: auth.firebaseUser!.uid,
      patientName: _patientNameController.text.trim(),
      bloodGroup: _bloodGroup,
      units: _units,
      urgencyScore: _condition == 'critical' ? 95 : (_condition == 'urgent' ? 75 : 45),
      condition: _condition,
      hospital: HospitalInfo(name: _hospitalNameController.text.trim(), address: _hospitalAddressController.text.trim()),
      requestedAt: DateTime.now(),
    );
    final id = await requestProvider.createRequest(request);
    if (id != null && mounted) Navigator.pushReplacementNamed(context, AppRoutes.requestStatus);
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
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat();
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

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
