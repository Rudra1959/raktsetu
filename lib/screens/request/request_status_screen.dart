import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/request_provider.dart';
import '../../widgets/status_tracker.dart';

/// Real-time request status tracking screen.
/// Uses Firestore real-time listener — no polling, no refresh.
class RequestStatusScreen extends StatelessWidget {
  const RequestStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context);
    final request = requestProvider.activeRequest;

    return Scaffold(
      appBar: AppBar(title: const Text('Request Status')),
      body: request == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Status tracker
                  StatusTracker(
                    steps: const [
                      'Request Sent',
                      'Finding Donors',
                      'Donor Found',
                      'Donor En Route',
                      'Confirmed',
                    ],
                    currentStep: request.statusIndex,
                  ),
                  const SizedBox(height: 32),

                  // Request summary card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _InfoRow(
                            label: 'Patient',
                            value: request.patientName,
                          ),
                          _InfoRow(
                            label: 'Blood Group',
                            value: request.bloodGroup,
                            valueColor: RaktSetuTheme.bloodGroupColors[
                                request.bloodGroup],
                          ),
                          _InfoRow(
                            label: 'Units',
                            value: '${request.units}',
                          ),
                          _InfoRow(
                            label: 'Hospital',
                            value: request.hospital.name,
                          ),
                          _InfoRow(
                            label: 'Urgency',
                            value: '${request.urgencyScore}/100',
                            valueColor: request.isEmergency
                                ? RaktSetuTheme.emergencyRed
                                : null,
                          ),
                          if (request.etaMinutes != null)
                            _InfoRow(
                              label: 'ETA',
                              value: '${request.etaMinutes} min',
                              valueColor: RaktSetuTheme.successGreen,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Live status message
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _statusColor(request.status).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _statusColor(request.status).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _statusIcon(request.status),
                          color: _statusColor(request.status),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _statusMessage(request.status),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: _statusColor(request.status),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Cancel button (only if active)
                  if (request.isActive) ...[
                    const SizedBox(height: 32),
                    OutlinedButton(
                      onPressed: () {
                        // Cancel request logic
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade600,
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text('Cancel Request'),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'fulfilled':
        return RaktSetuTheme.successGreen;
      case 'en_route':
        return const Color(0xFF1E88E5);
      case 'matched':
        return RaktSetuTheme.warningOrange;
      case 'no_match':
      case 'cancelled':
        return Colors.grey;
      default:
        return RaktSetuTheme.primaryRed;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'fulfilled':
        return Icons.check_circle;
      case 'en_route':
        return Icons.directions_car;
      case 'matched':
        return Icons.person_pin;
      case 'no_match':
        return Icons.search_off;
      default:
        return Icons.hourglass_top;
    }
  }

  String _statusMessage(String status) {
    switch (status) {
      case 'pending':
        return 'Your request has been submitted. Finding donors...';
      case 'matching':
        return 'Searching for compatible donors near the hospital...';
      case 'matched':
        return 'A donor has been found! Waiting for confirmation...';
      case 'en_route':
        return 'Donor is on the way to the hospital.';
      case 'fulfilled':
        return 'Blood has been delivered successfully! 🎉';
      case 'no_match':
        return 'No donors found. Escalating to blood banks...';
      case 'cancelled':
        return 'This request has been cancelled.';
      default:
        return 'Processing your request...';
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(
            value,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
