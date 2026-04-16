import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../models/request_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/request_provider.dart';

/// Screen to create a new blood request with hospital details and urgency.
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
  DateTime? _surgeryTime;

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Request Blood')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient name
              TextFormField(
                controller: _patientNameController,
                decoration: const InputDecoration(
                  labelText: 'Patient Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),

              // Blood group selector
              _SectionTitle(title: 'Blood Group Required'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.bloodGroups.map((g) {
                  final selected = _bloodGroup == g;
                  final color = RaktSetuTheme.bloodGroupColors[g]!;
                  return ChoiceChip(
                    label: Text(g),
                    selected: selected,
                    selectedColor: color,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : color,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => setState(() => _bloodGroup = g),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Units required
              _SectionTitle(title: 'Units Required'),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: _units > 1
                        ? () => setState(() => _units--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Container(
                    width: 48,
                    alignment: Alignment.center,
                    child: Text(
                      '$_units',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _units < 10
                        ? () => setState(() => _units++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'unit${_units > 1 ? 's' : ''} of blood',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Urgency level
              _SectionTitle(title: 'Urgency Level'),
              const SizedBox(height: 8),
              ...['critical', 'urgent', 'standard'].map((c) {
                return RadioListTile<String>(
                  value: c,
                  groupValue: _condition,
                  onChanged: (v) => setState(() => _condition = v!),
                  title: Text(
                    c[0].toUpperCase() + c.substring(1),
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(_conditionDesc(c)),
                  activeColor: RaktSetuTheme.primaryRed,
                  contentPadding: EdgeInsets.zero,
                );
              }),
              const SizedBox(height: 20),

              // Hospital details
              TextFormField(
                controller: _hospitalNameController,
                decoration: const InputDecoration(
                  labelText: 'Hospital Name',
                  prefixIcon: Icon(Icons.local_hospital),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hospitalAddressController,
                decoration: const InputDecoration(
                  labelText: 'Hospital Address',
                  prefixIcon: Icon(Icons.location_on),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Surgery time (optional)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.schedule),
                title: Text(
                  _surgeryTime != null
                      ? 'Surgery: ${_surgeryTime!.day}/${_surgeryTime!.month} at ${_surgeryTime!.hour}:${_surgeryTime!.minute.toString().padLeft(2, '0')}'
                      : 'Set surgery time (optional)',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickSurgeryTime,
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Additional Notes',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Submit button
              ElevatedButton(
                onPressed: requestProvider.isLoading ? null : _submitRequest,
                child: requestProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _conditionDesc(String c) {
    switch (c) {
      case 'critical':
        return 'Life-threatening — immediate blood needed';
      case 'urgent':
        return 'Surgery scheduled — blood needed within hours';
      default:
        return 'Planned procedure — flexible timeline';
    }
  }

  Future<void> _pickSurgeryTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 4)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      _surgeryTime = DateTime(
        date.year, date.month, date.day, time.hour, time.minute,
      );
    });
  }

  void _submitRequest() {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<RaktSetuAuthProvider>(context, listen: false);
    final requestProvider =
        Provider.of<RequestProvider>(context, listen: false);

    final request = RequestModel(
      id: '',
      requesterId: auth.firebaseUser?.uid ?? '',
      patientName: _patientNameController.text.trim(),
      bloodGroup: _bloodGroup,
      units: _units,
      condition: _condition,
      hospital: HospitalInfo(
        name: _hospitalNameController.text.trim(),
        address: _hospitalAddressController.text.trim(),
      ),
      surgeryTime: _surgeryTime,
      notes: _notesController.text.trim(),
      requestedAt: DateTime.now(),
    );

    requestProvider.createRequest(request).then((id) {
      if (id != null && mounted) {
        Navigator.pushReplacementNamed(context, '/request/status');
      }
    });
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _hospitalNameController.dispose();
    _hospitalAddressController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}
