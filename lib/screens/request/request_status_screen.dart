import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../providers/request_provider.dart';
import '../../models/request_model.dart';
import '../../widgets/status_tracker.dart';

class RequestStatusScreen extends StatelessWidget {
  const RequestStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context);
    final RequestModel? request = requestProvider.activeRequest;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Request Status',
          style: GoogleFonts.cormorantGaramond(fontSize: 28, fontWeight: FontWeight.bold, color: RaktSetuTheme.ink),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [RaktSetuTheme.primaryRed.withValues(alpha: 0.1), Colors.transparent]),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30), child: const SizedBox()),
          ),
          SafeArea(
            child: request == null
                ? _buildEmptyState(context)
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
                                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 20, offset: const Offset(0, 10))],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tracking Progress',
                                    style: GoogleFonts.cormorantGaramond(fontSize: 42, fontWeight: FontWeight.bold, height: 1.1),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _statusMessage(request.status),
                                    style: GoogleFonts.manrope(color: RaktSetuTheme.textSoft, fontSize: 16),
                                  ),
                                  const SizedBox(height: 40),
                                  StatusTracker(
                                    steps: const ['Sent', 'Matching', 'Found', 'En Route', 'Done'],
                                    currentStep: request.statusIndex,
                                    eta: request.etaMinutes,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildQuickStats(request),
                            const SizedBox(height: 24),
                            _buildDetailsCard(request),
                            const SizedBox(height: 32),
                            if (request.isActive)
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: requestProvider.isLoading
                                      ? null
                                      : () async {
                                          await requestProvider.cancelActiveRequest();
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request cancelled.')));
                                        },
                                  child: Text(
                                    requestProvider.isLoading ? 'Cancelling...' : 'Cancel Request',
                                    style: GoogleFonts.manrope(color: RaktSetuTheme.primaryRed, fontWeight: FontWeight.bold),
                                  ),
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.track_changes_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            Text(
              'No active request',
              style: GoogleFonts.cormorantGaramond(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Create a request to start live matching and status tracking.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(color: RaktSetuTheme.textSoft),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: RaktSetuTheme.primaryRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.createRequest),
              child: const Text('Create Request'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(RequestModel request) {
    return Row(
      children: [
        Expanded(child: _buildStatTile('Patient', request.patientName)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatTile('Type', request.bloodGroup, color: RaktSetuTheme.bloodGroupColors[request.bloodGroup])),
        const SizedBox(width: 16),
        Expanded(child: _buildStatTile('Units', '${request.units}')),
      ],
    );
  }

  Widget _buildStatTile(String label, String value, {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.bold, color: RaktSetuTheme.primaryRed, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.cormorantGaramond(fontSize: 24, fontWeight: FontWeight.bold, color: color ?? RaktSetuTheme.ink)),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(RequestModel request) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.local_hospital_outlined, 'Hospital', request.hospital.name),
          const Divider(height: 32),
          _buildInfoRow(Icons.location_on_outlined, 'Address', request.hospital.address.isEmpty ? 'Not provided' : request.hospital.address),
          const Divider(height: 32),
          _buildInfoRow(Icons.speed_outlined, 'Urgency Score', '${request.urgencyScore}/100'),
          if (request.surgeryTime != null) ...[
            const Divider(height: 32),
            _buildInfoRow(Icons.calendar_month_outlined, 'Surgery Date', '${request.surgeryTime!.day}/${request.surgeryTime!.month}/${request.surgeryTime!.year}'),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: RaktSetuTheme.textSoft),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold, color: RaktSetuTheme.textSoft)),
              Text(value, style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600, color: RaktSetuTheme.ink)),
            ],
          ),
        ),
      ],
    );
  }

  String _statusMessage(String status) {
    switch (status) {
      case 'pending': return 'Submitted and waiting to begin matching.';
      case 'matching': return 'Searching for donors and inventory nearby.';
      case 'matched': return 'A suitable donor has been identified.';
      case 'en_route': return 'Delivery is currently on the way.';
      case 'fulfilled': return 'Request successfully fulfilled.';
      case 'cancelled': return 'This request was cancelled.';
      default: return 'Processing your request.';
    }
  }
}
