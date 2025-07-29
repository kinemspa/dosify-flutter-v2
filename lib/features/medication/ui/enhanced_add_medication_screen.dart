import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/data/models/enhanced_medication.dart';
import '../../calculator/services/enhanced_reconstitution_calculator.dart';

class EnhancedAddMedicationScreen extends StatefulWidget {
  final String? medicationId; // For editing existing medication

  const EnhancedAddMedicationScreen({
    Key? key,
    this.medicationId,
  }) : super(key: key);

  @override
  State<EnhancedAddMedicationScreen> createState() => _EnhancedAddMedicationScreenState();
}

class _EnhancedAddMedicationScreenState extends State<EnhancedAddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _strengthController = TextEditingController();
  final _stockController = TextEditingController();
  final _lowStockController = TextEditingController();
  final _notesController = TextEditingController();
  final _syringeSizeController = TextEditingController();
  final _vialCapacityController = TextEditingController();

  MedicationType? _selectedType;
  InjectionSubType? _selectedInjectionSubType;
  StrengthUnit? _selectedStrengthUnit;
  VolumeUnit _selectedVolumeUnit = VolumeUnit.ml;
  StockUnit? _selectedStockUnit;
  DateTime? _expirationDate;
  ReconstitutionInfo? _reconstitutionInfo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.medicationId != null) {
      _loadExistingMedication();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _strengthController.dispose();
    _stockController.dispose();
    _lowStockController.dispose();
    _notesController.dispose();
    _syringeSizeController.dispose();
    _vialCapacityController.dispose();
    super.dispose();
  }

  void _loadExistingMedication() {
    // TODO: Load existing medication data for editing
    setState(() {
      _isLoading = true;
    });
    
    // Simulate loading
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _onTypeChanged(MedicationType? type) {
    setState(() {
      _selectedType = type;
      _selectedInjectionSubType = null;
      _selectedStrengthUnit = null;
      _selectedStockUnit = null;
      _reconstitutionInfo = null;
      
      // Set default values based on medication type
      if (type != null) {
        _setDefaultsForType(type);
      }
    });
  }

  void _onInjectionSubTypeChanged(InjectionSubType? subType) {
    setState(() {
      _selectedInjectionSubType = subType;
      _selectedStrengthUnit = null;
      _selectedStockUnit = null;
      
      if (subType != null) {
        _setDefaultsForInjectionSubType(subType);
      }
    });
  }

  void _setDefaultsForType(MedicationType type) {
    final mockMedication = EnhancedMedication(
      id: '',
      name: '',
      type: type,
      strength: const MedicationStrength(amount: 0, unit: StrengthUnit.mg),
      inventory: const MedicationInventory(
        currentStock: 0,
        stockUnit: StockUnit.tablets,
        lowStockThreshold: 10,
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final availableStrengthUnits = mockMedication.availableStrengthUnits;
    final availableStockUnits = mockMedication.availableStockUnits;

    if (availableStrengthUnits.isNotEmpty) {
      _selectedStrengthUnit = availableStrengthUnits.first;
    }
    if (availableStockUnits.isNotEmpty) {
      _selectedStockUnit = availableStockUnits.first;
    }
  }

  void _setDefaultsForInjectionSubType(InjectionSubType subType) {
    final mockMedication = EnhancedMedication(
      id: '',
      name: '',
      type: MedicationType.injection,
      injectionSubType: subType,
      strength: const MedicationStrength(amount: 0, unit: StrengthUnit.mg),
      inventory: const MedicationInventory(
        currentStock: 0,
        stockUnit: StockUnit.tablets,
        lowStockThreshold: 10,
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final availableStrengthUnits = mockMedication.availableStrengthUnits;
    final availableStockUnits = mockMedication.availableStockUnits;

    if (availableStrengthUnits.isNotEmpty) {
      _selectedStrengthUnit = availableStrengthUnits.first;
    }
    if (availableStockUnits.isNotEmpty) {
      _selectedStockUnit = availableStockUnits.first;
    }
  }

  Future<void> _openReconstitutionCalculator() async {
    if (_selectedType != MedicationType.injection || 
        _selectedInjectionSubType != InjectionSubType.lyophilizedPowder) {
      return;
    }

    final result = await showDialog<ReconstitutionInfo>(
      context: context,
      builder: (context) => ReconstitutionCalculatorDialog(
        powderAmount: double.tryParse(_strengthController.text) ?? 0,
        powderUnit: _selectedStrengthUnit ?? StrengthUnit.mg,
        maxVialCapacity: double.tryParse(_vialCapacityController.text) ?? 5.0,
        medicationName: _nameController.text.isEmpty ? 'Medication' : _nameController.text,
      ),
    );

    if (result != null) {
      setState(() {
        _reconstitutionInfo = result;
      });
    }
  }

  void _selectExpirationDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _expirationDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)), // 10 years
    );

    if (date != null) {
      setState(() {
        _expirationDate = date;
      });
    }
  }

  String _generateHelperText() {
    if (_selectedType == null) {
      return 'Select a medication type to see relevant fields and guidance.';
    }

    final strengthValue = double.tryParse(_strengthController.text) ?? 0;
    final strengthUnit = _selectedStrengthUnit;
    final stockValue = int.tryParse(_stockController.text) ?? 0;
    final stockUnit = _selectedStockUnit;

    String summary = '';

    switch (_selectedType!) {
      case MedicationType.tablet:
      case MedicationType.capsule:
        summary = 'Each ${_selectedType!.name} contains ';
        if (strengthValue > 0 && strengthUnit != null) {
          summary += '${strengthValue.toStringAsFixed(strengthValue == strengthValue.roundToDouble() ? 0 : 2)}';
          summary += _getStrengthUnitString(strengthUnit);
          if (stockValue > 0 && stockUnit != null) {
            summary += '. Current stock: ${stockValue} ${_getStockUnitString(stockUnit)}.';
            final estimatedDoses = stockValue; // 1:1 ratio for tablets
            summary += ' Estimated doses available: $estimatedDoses.';
          }
        } else {
          summary += '[Enter strength] of active ingredient.';
        }
        break;

      case MedicationType.injection:
        switch (_selectedInjectionSubType) {
          case InjectionSubType.preFilledSyringe:
            summary = 'Pre-filled syringe containing ';
            if (strengthValue > 0 && strengthUnit != null && strengthUnit.toString().contains('PerMl')) {
              final syringeSize = double.tryParse(_syringeSizeController.text) ?? 1.0;
              summary += '${strengthValue.toStringAsFixed(2)}${_getStrengthUnitString(strengthUnit)}';
              summary += ' in ${syringeSize}mL syringes.';
              if (stockValue > 0) {
                final totalVolume = stockValue * syringeSize;
                summary += ' Total available: ${totalVolume.toStringAsFixed(1)}mL in $stockValue syringes.';
              }
            } else {
              summary += '[Enter concentration] in each syringe.';
            }
            break;

          case InjectionSubType.readyToUseVial:
            summary = 'Ready-to-use vial with ';
            if (strengthValue > 0 && strengthUnit != null) {
              summary += '${strengthValue.toStringAsFixed(2)}${_getStrengthUnitString(strengthUnit)}';
              if (_selectedStrengthUnit.toString().contains('PerMl')) {
                summary += ' concentration.';
              } else {
                summary += ' total amount.';
              }
              if (stockValue > 0) {
                summary += ' Stock: $stockValue vials available.';
              }
            } else {
              summary += '[Enter strength/concentration].';
            }
            break;

          case InjectionSubType.lyophilizedPowder:
            summary = 'Lyophilized powder containing ';
            if (strengthValue > 0 && strengthUnit != null) {
              summary += '${strengthValue.toStringAsFixed(strengthValue == strengthValue.roundToDouble() ? 0 : 2)}';
              summary += _getStrengthUnitString(strengthUnit);
              summary += ' per vial. Requires reconstitution.';
              final vialCapacity = double.tryParse(_vialCapacityController.text) ?? 0;
              if (vialCapacity > 0) {
                summary += ' Maximum vial volume: ${vialCapacity}mL.';
              }
              if (_reconstitutionInfo != null) {
                summary += ' Reconstituted with ${_reconstitutionInfo!.displayString}.';
              } else {
                summary += ' Click calculator to determine reconstitution.';
              }
            } else {
              summary += '[Enter powder amount] requiring reconstitution.';
            }
            break;

          case InjectionSubType.injectionPen:
            summary = 'Injection pen device ';
            if (strengthValue > 0 && strengthUnit != null) {
              summary += 'with ${strengthValue.toStringAsFixed(2)}${_getStrengthUnitString(strengthUnit)}';
              summary += ' concentration.';
            } else {
              summary += 'for insulin or hormone delivery.';
            }
            break;

          case null:
            summary = 'Select injection subtype for specific guidance.';
            break;
        }
        break;

      case MedicationType.peptide:
        summary = 'Peptide medication containing ';
        if (strengthValue > 0 && strengthUnit != null) {
          summary += '${strengthValue.toStringAsFixed(strengthValue == strengthValue.roundToDouble() ? 0 : 2)}';
          summary += _getStrengthUnitString(strengthUnit);
          summary += ' per vial. Requires refrigerated storage.';
          if (!strengthUnit.toString().contains('PerMl')) {
            summary += ' Reconstitution typically required.';
          }
        } else {
          summary += '[Enter peptide amount]. Usually requires reconstitution.';
        }
        break;

      default:
        summary = '${_selectedType!.name.substring(0, 1).toUpperCase()}${_selectedType!.name.substring(1)} medication.';
        if (strengthValue > 0 && strengthUnit != null) {
          summary += ' Strength: ${strengthValue.toStringAsFixed(2)}${_getStrengthUnitString(strengthUnit)}.';
        }
        break;
    }

    return summary;
  }

  String _getStrengthUnitString(StrengthUnit unit) {
    switch (unit) {
      case StrengthUnit.mcg: return 'mcg';
      case StrengthUnit.mg: return 'mg';
      case StrengthUnit.g: return 'g';
      case StrengthUnit.mcgPerMl: return 'mcg/mL';
      case StrengthUnit.mgPerMl: return 'mg/mL';
      case StrengthUnit.gPerMl: return 'g/mL';
      case StrengthUnit.iu: return 'IU';
      case StrengthUnit.iuPerMl: return 'IU/mL';
      case StrengthUnit.percent: return '%';
      case StrengthUnit.units: return 'U';
      case StrengthUnit.unitsPerMl: return 'U/mL';
    }
  }

  String _getStockUnitString(StockUnit unit) {
    switch (unit) {
      case StockUnit.tablets: return 'tablets';
      case StockUnit.syringes: return 'syringes';
      case StockUnit.vials: return 'vials';
      case StockUnit.pens: return 'pens';
      case StockUnit.cartridges: return 'cartridges';
      case StockUnit.tubes: return 'tubes';
      case StockUnit.patches: return 'patches';
      case StockUnit.bottles: return 'bottles';
      case StockUnit.milliliters: return 'mL';
    }
  }

  Widget _buildHelperTextCard() {
    return Card(
      margin: const EdgeInsets.all(16),
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
                  'Medication Summary',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _generateHelperText(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (_selectedType == MedicationType.injection &&
                _selectedInjectionSubType == InjectionSubType.lyophilizedPowder &&
                _reconstitutionInfo == null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _openReconstitutionCalculator,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Open Reconstitution Calculator'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSpecificFields() {
    if (_selectedType == null) return const SizedBox.shrink();

    final widgets = <Widget>[];

    // Medication Name (always shown)
    widgets.add(_buildTextField(
      controller: _nameController,
      label: 'Medication Name',
      hint: 'Enter medication name',
      required: true,
      icon: Icons.medical_services,
    ));

    // Type-specific strength fields
    widgets.add(_buildStrengthFields());

    // Injection subtype selection
    if (_selectedType == MedicationType.injection) {
      widgets.add(_buildInjectionSubTypeField());
    }

    // Type-specific additional fields
    widgets.addAll(_buildAdditionalFields());

    // Stock management fields
    widgets.addAll(_buildStockFields());

    // Expiration date
    widgets.add(_buildExpirationDateField());

    // Notes
    widgets.add(_buildTextField(
      controller: _notesController,
      label: 'Notes (Optional)',
      hint: 'Add any additional notes',
      maxLines: 3,
      icon: Icons.note,
    ));

    return Column(children: widgets);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool required = false,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: const OutlineInputBorder(),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: required ? (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }
          return null;
        } : null,
        onChanged: (_) => setState(() {}), // Trigger helper text update
      ),
    );
  }

  Widget _buildStrengthFields() {
    if (_selectedType == null) return const SizedBox.shrink();

    final mockMedication = EnhancedMedication(
      id: '',
      name: '',
      type: _selectedType!,
      injectionSubType: _selectedInjectionSubType,
      strength: const MedicationStrength(amount: 0, unit: StrengthUnit.mg),
      inventory: const MedicationInventory(
        currentStock: 0,
        stockUnit: StockUnit.tablets,
        lowStockThreshold: 10,
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final availableUnits = mockMedication.availableStrengthUnits;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: _strengthController,
              decoration: const InputDecoration(
                labelText: 'Strength *',
                hintText: 'Enter amount',
                prefixIcon: Icon(Icons.medication),
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Strength is required';
                }
                if (double.tryParse(value) == null || double.parse(value) <= 0) {
                  return 'Enter valid strength';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: DropdownButtonFormField<StrengthUnit>(
              value: _selectedStrengthUnit,
              decoration: const InputDecoration(
                labelText: 'Unit *',
                border: OutlineInputBorder(),
              ),
              items: availableUnits.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(_getStrengthUnitString(unit)),
                );
              }).toList(),
              onChanged: (unit) {
                setState(() {
                  _selectedStrengthUnit = unit;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInjectionSubTypeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonFormField<InjectionSubType>(
        value: _selectedInjectionSubType,
        decoration: const InputDecoration(
          labelText: 'Injection Type *',
          hintText: 'Select injection type',
          prefixIcon: Icon(Icons.vaccines),
          border: OutlineInputBorder(),
        ),
        items: InjectionSubType.values.map((type) {
          String displayName;
          switch (type) {
            case InjectionSubType.preFilledSyringe:
              displayName = 'Pre-filled Syringe';
              break;
            case InjectionSubType.readyToUseVial:
              displayName = 'Ready-to-use Vial';
              break;
            case InjectionSubType.lyophilizedPowder:
              displayName = 'Lyophilized Powder';
              break;
            case InjectionSubType.injectionPen:
              displayName = 'Injection Pen';
              break;
          }
          return DropdownMenuItem(
            value: type,
            child: Text(displayName),
          );
        }).toList(),
        onChanged: _onInjectionSubTypeChanged,
        validator: (value) {
          if (value == null) {
            return 'Injection type is required';
          }
          return null;
        },
      ),
    );
  }

  List<Widget> _buildAdditionalFields() {
    final widgets = <Widget>[];

    if (_selectedType == MedicationType.injection) {
      switch (_selectedInjectionSubType) {
        case InjectionSubType.preFilledSyringe:
          widgets.add(_buildTextField(
            controller: _syringeSizeController,
            label: 'Syringe Size',
            hint: 'e.g., 0.3, 0.5, 1.0',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            icon: Icons.straighten,
          ));
          break;

        case InjectionSubType.lyophilizedPowder:
          widgets.add(_buildTextField(
            controller: _vialCapacityController,
            label: 'Max Vial Capacity (mL)',
            hint: 'e.g., 3, 5, 10',
            required: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            icon: Icons.science,
          ));
          break;

        default:
          break;
      }
    }

    return widgets;
  }

  List<Widget> _buildStockFields() {
    if (_selectedType == null) return [];

    final mockMedication = EnhancedMedication(
      id: '',
      name: '',
      type: _selectedType!,
      injectionSubType: _selectedInjectionSubType,
      strength: const MedicationStrength(amount: 0, unit: StrengthUnit.mg),
      inventory: const MedicationInventory(
        currentStock: 0,
        stockUnit: StockUnit.tablets,
        lowStockThreshold: 10,
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final availableStockUnits = mockMedication.availableStockUnits;

    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(
                  labelText: 'Current Stock *',
                  hintText: 'Enter quantity',
                  prefixIcon: Icon(Icons.inventory),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Stock is required';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return 'Enter valid stock';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<StockUnit>(
                value: _selectedStockUnit,
                decoration: const InputDecoration(
                  labelText: 'Unit *',
                  border: OutlineInputBorder(),
                ),
                items: availableStockUnits.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(_getStockUnitString(unit)),
                  );
                }).toList(),
                onChanged: (unit) {
                  setState(() {
                    _selectedStockUnit = unit;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
      _buildTextField(
        controller: _lowStockController,
        label: 'Low Stock Alert Threshold',
        hint: 'Alert when stock below this number',
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        icon: Icons.warning,
      ),
    ];
  }

  Widget _buildExpirationDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: _selectExpirationDate,
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Expiration Date',
            hintText: 'Select expiration date',
            prefixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(),
          ),
          child: Text(
            _expirationDate != null
                ? '${_expirationDate!.day}/${_expirationDate!.month}/${_expirationDate!.year}'
                : 'Select date',
            style: _expirationDate != null
                ? Theme.of(context).textTheme.bodyMedium
                : Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveMedication() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement medication saving logic
      await Future.delayed(const Duration(milliseconds: 1000)); // Simulate save

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.medicationId != null
                ? 'Medication updated successfully'
                : 'Medication added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving medication: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medicationId != null ? 'Edit Medication' : 'Add Medication'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Medication Type Selector
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: DropdownButtonFormField<MedicationType>(
                        value: _selectedType,
                        decoration: InputDecoration(
                          labelText: 'Medication Type *',
                          hintText: 'Select medication type',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.category),
                          suffixIcon: Tooltip(
                            message: 'Choose the type that best matches your medication form (tablet, injection, etc.)',
                            child: Icon(Icons.help_outline, color: Colors.grey[600]),
                          ),
                        ),
                        items: MedicationType.values.map((type) {
                          String displayName = type.name.substring(0, 1).toUpperCase() + 
                                              type.name.substring(1);
                          return DropdownMenuItem(
                            value: type,
                            child: Text(displayName),
                          );
                        }).toList(),
                        onChanged: _onTypeChanged,
                        validator: (value) {
                          if (value == null) {
                            return 'Medication type is required';
                          }
                          return null;
                        },
                      ),
                    ),

                    // Helper Text Card
                    _buildHelperTextCard(),

                    // Type-specific fields
                    _buildTypeSpecificFields(),

                    const SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _saveMedication,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save),
        label: Text(widget.medicationId != null ? 'Update' : 'Save'),
      ),
    );
  }
}

// Placeholder for Reconstitution Calculator Dialog
class ReconstitutionCalculatorDialog extends StatefulWidget {
  final double powderAmount;
  final StrengthUnit powderUnit;
  final double maxVialCapacity;
  final String medicationName;

  const ReconstitutionCalculatorDialog({
    Key? key,
    required this.powderAmount,
    required this.powderUnit,
    required this.maxVialCapacity,
    required this.medicationName,
  }) : super(key: key);

  @override
  State<ReconstitutionCalculatorDialog> createState() => _ReconstitutionCalculatorDialogState();
}

class _ReconstitutionCalculatorDialogState extends State<ReconstitutionCalculatorDialog> {
  final _targetDoseController = TextEditingController();
  StrengthUnit _targetDoseUnit = StrengthUnit.mg;
  SyringeSize _selectedSyringe = SyringeSize.insulin_1ml;
  List<ReconstitutionCalculationOption> _options = [];
  ReconstitutionCalculationOption? _selectedOption;

  @override
  void initState() {
    super.initState();
    _targetDoseController.text = (widget.powderAmount * 0.1).toString(); // Default to 10% of powder
    _calculateOptions();
  }

  void _calculateOptions() {
    if (widget.powderAmount <= 0 || _targetDoseController.text.isEmpty) {
      setState(() {
        _options = [];
      });
      return;
    }

    final targetDose = double.tryParse(_targetDoseController.text) ?? 0;
    if (targetDose <= 0) {
      setState(() {
        _options = [];
      });
      return;
    }

    final options = EnhancedReconstitutionCalculator.calculateOptions(
      powderAmount: widget.powderAmount,
      powderUnit: widget.powderUnit,
      targetDose: targetDose,
      targetDoseUnit: _targetDoseUnit,
      targetSyringe: _selectedSyringe,
      maxVialCapacity: widget.maxVialCapacity,
    );

    setState(() {
      _options = options;
      _selectedOption = options.isNotEmpty ? options.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reconstitution Calculator',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Text('Medication: ${widget.medicationName}'),
            Text('Powder: ${widget.powderAmount}${widget.powderUnit.name} per vial'),
            Text('Max Capacity: ${widget.maxVialCapacity}mL'),
            
            const SizedBox(height: 24),
            
            // Target dose input
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _targetDoseController,
                    decoration: const InputDecoration(
                      labelText: 'Target Dose',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => _calculateOptions(),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 80,
                  child: DropdownButtonFormField<StrengthUnit>(
                    value: _targetDoseUnit,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: [StrengthUnit.mcg, StrengthUnit.mg, StrengthUnit.g, StrengthUnit.iu]
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit.name),
                            ))
                        .toList(),
                    onChanged: (unit) {
                      if (unit != null) {
                        setState(() {
                          _targetDoseUnit = unit;
                        });
                        _calculateOptions();
                      }
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Syringe selection
            DropdownButtonFormField<SyringeSize>(
              value: _selectedSyringe,
              decoration: const InputDecoration(
                labelText: 'Syringe Size',
                border: OutlineInputBorder(),
              ),
              items: SyringeSize.values
                  .map((size) => DropdownMenuItem(
                        value: size,
                        child: Text(size.displayName),
                      ))
                  .toList(),
              onChanged: (size) {
                if (size != null) {
                  setState(() {
                    _selectedSyringe = size;
                  });
                  _calculateOptions();
                }
              },
            ),
            
            const SizedBox(height: 24),
            
            // Options
            if (_options.isNotEmpty) ...[
              Text(
                'Reconstitution Options:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _options.length,
                  itemBuilder: (context, index) {
                    final option = _options[index];
                    return RadioListTile<ReconstitutionCalculationOption>(
                      title: Text(option.name),
                      subtitle: Text(option.displayString),
                      value: option,
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value;
                        });
                      },
                    );
                  },
                ),
              ),
            ] else ...[
              const Text('Enter target dose to see reconstitution options.'),
            ],
            
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _selectedOption != null
                      ? () {
                          final reconstitutionInfo = EnhancedReconstitutionCalculator
                              .createReconstitutionInfo(
                            selectedOption: _selectedOption!,
                            stabilityDays: EnhancedReconstitutionCalculator
                                .getStabilityDays(MedicationType.injection),
                          );
                          Navigator.of(context).pop(reconstitutionInfo);
                        }
                      : null,
                  child: const Text('Use This Option'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
