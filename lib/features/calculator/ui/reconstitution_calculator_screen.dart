import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReconstitutionCalculatorScreen extends StatefulWidget {
  const ReconstitutionCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<ReconstitutionCalculatorScreen> createState() => _ReconstitutionCalculatorScreenState();
}

class _ReconstitutionCalculatorScreenState extends State<ReconstitutionCalculatorScreen> {
final _formKey = GlobalKey<FormState>();
  final _powderAmountController = TextEditingController();
  final _desiredDoseController = TextEditingController();
  final _solventVolumeController = TextEditingController();
  final _maxVolumeController = TextEditingController();

  String _selectedPowderUnit = 'mg';
  String _selectedDoseUnit = 'mg';
  String _selectedSyringeSize = '1mL';
  String? _selectedTargetVialSize;
  String _selectedSolventUnit = 'ml';
  String _selectedSolventType = 'Bacteriostatic Water';
  bool _showAdvanced = false;
  
  ReconstitutionResult? _result;
  
  final List<String> _powderUnits = ['mg', 'mcg', 'Units', 'IU'];
  final List<String> _syringeSizes = ['0.3mL', '0.5mL', '1mL', '3mL', '5mL'];
  final List<String> _targetVialSizes = ['1mL', '3mL', '5mL', '10mL', '20mL'];
  final List<String> _volumeUnits = ['ml', 'L'];
  final List<String> _solventTypes = ['Bacteriostatic Water', 'Sterile Water', 'Normal Saline', 'Custom Diluent'];

  @override
  void dispose() {
    _powderAmountController.dispose();
    _desiredDoseController.dispose();
    _solventVolumeController.dispose();
    _maxVolumeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Modern Clinical Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.calculate_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calculator',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Precision reconstitution calculations',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _showAdvanced = !_showAdvanced;
                      });
                    },
                    icon: Icon(
                      _showAdvanced ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                      size: 24,
                    ),
                    tooltip: _showAdvanced ? 'Hide Advanced' : 'Show Advanced',
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: _clearAll,
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 24,
                    ),
                    tooltip: 'Clear All',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildInputSection(),
                    if (_showAdvanced) ...[
                      const SizedBox(height: 24),
                      _buildAdvancedSection(),
                    ],
                    const SizedBox(height: 24),
                    _buildCalculateButton(),
                    if (_result != null) ...[
                      const SizedBox(height: 24),
                      _buildResultsSection(),
                    ],
                    const SizedBox(height: 24),
                    _buildInstructionsSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science, color: Theme.of(context).primaryColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Professional Reconstitution',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Calculate precise volumes for injectable medications with capacity constraints.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calculation Parameters',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Powder Amount
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _powderAmountController,
                    decoration: const InputDecoration(
                      labelText: 'Powder Amount *',
                      hintText: 'e.g., 10',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _selectedPowderUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    items: _powderUnits.map((unit) => DropdownMenuItem(
                      value: unit,
                      child: Text(unit),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPowderUnit = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Solvent Volume
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _solventVolumeController,
                    decoration: const InputDecoration(
                      labelText: 'Solvent Volume *',
                      hintText: 'e.g., 2.0',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _selectedSolventUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    items: _volumeUnits.map((unit) => DropdownMenuItem(
                      value: unit,
                      child: Text(unit),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSolventUnit = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Desired Dose
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _desiredDoseController,
                    decoration: const InputDecoration(
                      labelText: 'Desired Dose *',
                      hintText: 'e.g., 2.5',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _selectedDoseUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    items: _powderUnits.map((unit) => DropdownMenuItem(
                      value: unit,
                      child: Text(unit),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDoseUnit = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Advanced Settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Max Volume Capacity
            TextFormField(
              controller: _maxVolumeController,
              decoration: const InputDecoration(
                labelText: 'Max Volume Capacity (ml)',
                hintText: 'e.g., 3.0',
                border: OutlineInputBorder(),
                helperText: 'Maximum vial capacity to prevent overfill',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
            ),
            const SizedBox(height: 16),
            // Solvent Type
            DropdownButtonFormField<String>(
              value: _selectedSolventType,
              decoration: const InputDecoration(
                labelText: 'Solvent Type',
                border: OutlineInputBorder(),
                helperText: 'Type of diluent for reconstitution',
              ),
              items: _solventTypes.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSolventType = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _calculate,
        icon: const Icon(Icons.calculate),
        label: const Text('Calculate Reconstitution'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    if (_result == null) return const SizedBox.shrink();

    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'Calculation Results',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildResultRow('Final Concentration:', '${_result!.concentration} $_selectedPowderUnit/$_selectedSolventUnit'),
            _buildResultRow('Volume to Draw:', '${_result!.volumeToDraw} $_selectedSolventUnit'),
            _buildResultRow('Total Reconstituted Volume:', '${_result!.totalVolume} $_selectedSolventUnit'),
            if (_result!.isWithinCapacity != null)
              _buildResultRow('Within Capacity:', _result!.isWithinCapacity! ? '✓ Yes' : '⚠ Exceeds limit', 
                color: _result!.isWithinCapacity! ? Colors.green : Colors.orange),
            if (_result!.doses != null)
              _buildResultRow('Available Doses:', '${_result!.doses}'),
            const SizedBox(height: 12),
            if (_result!.warnings.isNotEmpty) ...[
              Text(
                'Warnings:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
              const SizedBox(height: 4),
              ..._result!.warnings.map((warning) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber, size: 16, color: Colors.orange.shade700),
                    const SizedBox(width: 4),
                    Expanded(child: Text(warning, style: TextStyle(color: Colors.orange.shade700))),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Professional Guidelines',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInstructionPoint('Always use aseptic technique when reconstituting medications'),
            _buildInstructionPoint('Verify powder amount and expiration before use'),
            _buildInstructionPoint('Use appropriate diluent as specified in product guidelines'),
            _buildInstructionPoint('Check for particulates after reconstitution'),
            _buildInstructionPoint('Label reconstituted vials with date, time, and concentration'),
            _buildInstructionPoint('Store according to manufacturer recommendations'),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final powderAmount = double.parse(_powderAmountController.text);
    final solventVolume = double.parse(_solventVolumeController.text);
    final desiredDose = double.parse(_desiredDoseController.text);
    final maxVolume = _maxVolumeController.text.isNotEmpty 
        ? double.parse(_maxVolumeController.text) 
        : null;

    setState(() {
      _result = ReconstitutionCalculator.calculate(
        powderAmount: powderAmount,
        solventVolume: solventVolume,
        desiredDose: desiredDose,
        maxVolumeCapacity: maxVolume,
        powderUnit: _selectedPowderUnit,
        solventUnit: _selectedSolventUnit,
        doseUnit: _selectedDoseUnit,
        solventType: _selectedSolventType,
      );
    });

    // Scroll to results
    Future.delayed(const Duration(milliseconds: 100), () {
      Scrollable.ensureVisible(
        context,
        alignment: 0.0,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  void _clearAll() {
    _powderAmountController.clear();
    _solventVolumeController.clear();
    _desiredDoseController.clear();
    _maxVolumeController.clear();
    setState(() {
      _result = null;
      _selectedPowderUnit = 'mg';
      _selectedSolventUnit = 'ml';
      _selectedDoseUnit = 'mg';
      _selectedSolventType = 'Bacteriostatic Water';
    });
  }
}

// Updated Calculation Logic
class ReconstitutionOptions {
  final String concentratedOption;
  final String averageOption;
  final String dilutedOption;

  ReconstitutionOptions({
    required this.concentratedOption,
    required this.averageOption,
    required this.dilutedOption,
  });
}

ReconstitutionOptions calculateReconstitution({
  required double powderAmount,
  required String syringeSize,
  required double desiredDose,
  String? targetVialSize,
}) {
  double intendedDose = 1000.0;

  // Syringe to mL conversion
  double syringeMl = double.parse(syringeSize.replaceAll('mL', ''));

  // Target vial size logic
  if (targetVialSize != null) {
    double targetVialMl = double.parse(targetVialSize.replaceAll('mL', ''));
    return ReconstitutionOptions(
      concentratedOption: '1mL for 10IU on Syringe',
      averageOption: '3mL for 30IU on Syringe',
      dilutedOption: '5mL for 50IU on Syringe',
    );
  } else {
    return ReconstitutionOptions(
      concentratedOption: '1mL for 10IU on Syringe',
      averageOption: '5mL for 50IU on Syringe',
      dilutedOption: '9mL for 90IU on Syringe',
    );
  }
}
class ReconstitutionCalculator {
  static ReconstitutionResult calculate({
    required double powderAmount,
    required double solventVolume,
    required double desiredDose,
    double? maxVolumeCapacity,
    required String powderUnit,
    required String solventUnit,
    required String doseUnit,
    required String solventType,
  }) {
    // Convert units to standard (mg, ml)
    final standardPowderAmount = _convertToStandardMass(powderAmount, powderUnit);
    final standardSolventVolume = _convertToStandardVolume(solventVolume, solventUnit);
    final standardDesiredDose = _convertToStandardMass(desiredDose, doseUnit);
    final standardMaxVolume = maxVolumeCapacity != null 
        ? _convertToStandardVolume(maxVolumeCapacity, 'ml') 
        : null;

    // Calculate concentration (mg/ml)
    final concentration = standardPowderAmount / standardSolventVolume;
    
    // Calculate volume to draw for desired dose
    final volumeToDraw = standardDesiredDose / concentration;
    
    // Calculate total reconstituted volume (assuming powder adds minimal volume)
    final totalVolume = standardSolventVolume;
    
    // Calculate available doses
    final availableDoses = (standardPowderAmount / standardDesiredDose).floor();
    
    // Check capacity constraints
    bool? isWithinCapacity;
    if (standardMaxVolume != null) {
      isWithinCapacity = totalVolume <= standardMaxVolume;
    }
    
    // Generate warnings
    final warnings = <String>[];
    
    if (standardMaxVolume != null && totalVolume > standardMaxVolume) {
      warnings.add('Reconstituted volume exceeds vial capacity');
    }
    
    if (volumeToDraw > totalVolume) {
      warnings.add('Desired dose requires more volume than available');
    }
    
    if (volumeToDraw < 0.1) {
      warnings.add('Very small volume - use insulin syringe for accuracy');
    }
    
    if (concentration > 100) {
      warnings.add('High concentration - verify calculation and dosing');
    }
    
    return ReconstitutionResult(
      concentration: _roundToDecimal(concentration, 2),
      volumeToDraw: _roundToDecimal(volumeToDraw, 2),
      totalVolume: _roundToDecimal(totalVolume, 2),
      doses: availableDoses,
      isWithinCapacity: isWithinCapacity,
      warnings: warnings,
      solventType: solventType,
    );
  }
  
  static double _convertToStandardMass(double value, String unit) {
    switch (unit) {
      case 'g': return value * 1000; // g to mg
      case 'mcg': return value / 1000; // mcg to mg
      case 'IU': return value; // Keep as is for IU
      case 'mg':
      default: return value;
    }
  }
  
  static double _convertToStandardVolume(double value, String unit) {
    switch (unit) {
      case 'L': return value * 1000; // L to ml
      case 'ml':
      default: return value;
    }
  }
  
  static double _roundToDecimal(double value, int decimals) {
    final factor = pow(10, decimals);
    return (value * factor).round() / factor;
  }
}

class ReconstitutionResult {
  final double concentration;
  final double volumeToDraw;
  final double totalVolume;
  final int? doses;
  final bool? isWithinCapacity;
  final List<String> warnings;
  final String solventType;

  ReconstitutionResult({
    required this.concentration,
    required this.volumeToDraw,
    required this.totalVolume,
    this.doses,
    this.isWithinCapacity,
    required this.warnings,
    required this.solventType,
  });
}

// Content-only version for use in tabs
class ReconstitutionCalculatorContent extends StatefulWidget {
  const ReconstitutionCalculatorContent({Key? key}) : super(key: key);

  @override
  State<ReconstitutionCalculatorContent> createState() => _ReconstitutionCalculatorContentState();
}

class _ReconstitutionCalculatorContentState extends State<ReconstitutionCalculatorContent> {
  final _formKey = GlobalKey<FormState>();
  final _powderAmountController = TextEditingController();
  final _solventVolumeController = TextEditingController();
  final _desiredDoseController = TextEditingController();
  final _maxVolumeController = TextEditingController();
  
  String _selectedPowderUnit = 'mg';
  String _selectedDoseUnit = 'mg';
  String _selectedSolventUnit = 'ml';
  String _selectedSolventType = 'Bacteriostatic Water';
  bool _showAdvanced = false;
  
  ReconstitutionResult? _result;
  
  final List<String> _powderUnits = ['mg', 'mcg', 'g', 'IU'];
  final List<String> _volumeUnits = ['ml', 'L'];
  final List<String> _solventTypes = [
    'Bacteriostatic Water',
    'Sterile Water',
    'Normal Saline',
    'Custom Diluent'
  ];

  @override
  void dispose() {
    _powderAmountController.dispose();
    _solventVolumeController.dispose();
    _desiredDoseController.dispose();
    _maxVolumeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildInputSection(),
            if (_showAdvanced) ...[
              const SizedBox(height: 24),
              _buildAdvancedSection(),
            ],
            const SizedBox(height: 24),
            _buildCalculateButton(),
            if (_result != null) ...[
              const SizedBox(height: 24),
              _buildResultsSection(),
            ],
            const SizedBox(height: 24),
            _buildInstructionsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science, color: Theme.of(context).primaryColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Professional Reconstitution',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(_showAdvanced ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _showAdvanced = !_showAdvanced;
                    });
                  },
                  tooltip: _showAdvanced ? 'Hide Advanced' : 'Show Advanced',
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _clearAll,
                  tooltip: 'Clear All',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Calculate precise volumes for injectable medications with capacity constraints.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calculation Parameters',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Powder Amount
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _powderAmountController,
                    decoration: const InputDecoration(
                      labelText: 'Powder Amount *',
                      hintText: 'e.g., 10',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _selectedPowderUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    items: _powderUnits.map((unit) => DropdownMenuItem(
                      value: unit,
                      child: Text(unit),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPowderUnit = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Solvent Volume
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _solventVolumeController,
                    decoration: const InputDecoration(
                      labelText: 'Solvent Volume *',
                      hintText: 'e.g., 2.0',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _selectedSolventUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    items: _volumeUnits.map((unit) => DropdownMenuItem(
                      value: unit,
                      child: Text(unit),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSolventUnit = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Desired Dose
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _desiredDoseController,
                    decoration: const InputDecoration(
                      labelText: 'Desired Dose *',
                      hintText: 'e.g., 2.5',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _selectedDoseUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    items: _powderUnits.map((unit) => DropdownMenuItem(
                      value: unit,
                      child: Text(unit),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDoseUnit = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.tune, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Advanced Settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Max Volume Capacity
            TextFormField(
              controller: _maxVolumeController,
              decoration: const InputDecoration(
                labelText: 'Max Volume Capacity (ml)',
                hintText: 'e.g., 3.0',
                border: OutlineInputBorder(),
                helperText: 'Maximum vial capacity to prevent overfill',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
            ),
            const SizedBox(height: 16),
            // Solvent Type
            DropdownButtonFormField<String>(
              value: _selectedSolventType,
              decoration: const InputDecoration(
                labelText: 'Solvent Type',
                border: OutlineInputBorder(),
                helperText: 'Type of diluent for reconstitution',
              ),
              items: _solventTypes.map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSolventType = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _calculate,
        icon: const Icon(Icons.calculate),
        label: const Text('Calculate Reconstitution'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    if (_result == null) return const SizedBox.shrink();

    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'Calculation Results',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildResultRow('Final Concentration:', '${_result!.concentration} $_selectedPowderUnit/$_selectedSolventUnit'),
            _buildResultRow('Volume to Draw:', '${_result!.volumeToDraw} $_selectedSolventUnit'),
            _buildResultRow('Total Reconstituted Volume:', '${_result!.totalVolume} $_selectedSolventUnit'),
            if (_result!.isWithinCapacity != null)
              _buildResultRow('Within Capacity:', _result!.isWithinCapacity! ? '✓ Yes' : '⚠ Exceeds limit', 
                color: _result!.isWithinCapacity! ? Colors.green : Colors.orange),
            if (_result!.doses != null)
              _buildResultRow('Available Doses:', '${_result!.doses}'),
            const SizedBox(height: 12),
            if (_result!.warnings.isNotEmpty) ...[
              Text(
                'Warnings:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
              const SizedBox(height: 4),
              ..._result!.warnings.map((warning) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber, size: 16, color: Colors.orange.shade700),
                    const SizedBox(width: 4),
                    Expanded(child: Text(warning, style: TextStyle(color: Colors.orange.shade700))),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Professional Guidelines',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInstructionPoint('Always use aseptic technique when reconstituting medications'),
            _buildInstructionPoint('Verify powder amount and expiration before use'),
            _buildInstructionPoint('Use appropriate diluent as specified in product guidelines'),
            _buildInstructionPoint('Check for particulates after reconstitution'),
            _buildInstructionPoint('Label reconstituted vials with date, time, and concentration'),
            _buildInstructionPoint('Store according to manufacturer recommendations'),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final powderAmount = double.parse(_powderAmountController.text);
    final solventVolume = double.parse(_solventVolumeController.text);
    final desiredDose = double.parse(_desiredDoseController.text);
    final maxVolume = _maxVolumeController.text.isNotEmpty 
        ? double.parse(_maxVolumeController.text) 
        : null;

    setState(() {
      _result = ReconstitutionCalculator.calculate(
        powderAmount: powderAmount,
        solventVolume: solventVolume,
        desiredDose: desiredDose,
        maxVolumeCapacity: maxVolume,
        powderUnit: _selectedPowderUnit,
        solventUnit: _selectedSolventUnit,
        doseUnit: _selectedDoseUnit,
        solventType: _selectedSolventType,
      );
    });

    // Scroll to results
    Future.delayed(const Duration(milliseconds: 100), () {
      Scrollable.ensureVisible(
        context,
        alignment: 0.0,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  void _clearAll() {
    _powderAmountController.clear();
    _solventVolumeController.clear();
    _desiredDoseController.clear();
    _maxVolumeController.clear();
    setState(() {
      _result = null;
      _selectedPowderUnit = 'mg';
      _selectedSolventUnit = 'ml';
      _selectedDoseUnit = 'mg';
      _selectedSolventType = 'Bacteriostatic Water';
    });
  }
}
