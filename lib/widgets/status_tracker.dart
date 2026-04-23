import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

/// Step-by-step status tracker widget.
/// Shows the progress of a blood request through its lifecycle.
class StatusTracker extends StatelessWidget {
  final List<String> steps;
  final int currentStep;
  final int? eta;

  const StatusTracker({
    super.key,
    required this.steps,
    required this.currentStep,
    this.eta,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;
        final isPending = index > currentStep;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step indicator column
            Column(
              children: [
                // Circle
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? RaktSetuTheme.successGreen
                        : isCurrent
                            ? RaktSetuTheme.primaryRed
                            : Colors.grey.shade200,
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: RaktSetuTheme.primaryRed.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : isCurrent
                            ? const Icon(Icons.circle, color: Colors.white, size: 10)
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                  ),
                ),

                // Vertical line (except last)
                if (index < steps.length - 1)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted
                        ? RaktSetuTheme.successGreen
                        : Colors.grey.shade200,
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Step label
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      steps[index],
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight:
                            isCurrent ? FontWeight.w600 : FontWeight.w400,
                        color: isPending ? Colors.grey.shade400 : null,
                      ),
                    ),
                    if (isCurrent && eta != null)
                      Text(
                        'ETA: $eta minutes',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: RaktSetuTheme.primaryRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
