import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/medication.dart';
import '../../../core/data/repositories/medication_repository.dart';
import '../../../core/data/models/medication.dart' as CoreMedication;
import '../../../core/di/service_locator.dart';
import '../../../core/utils/responsive_utils.dart';
import '../providers/medication_providers.dart';
import 'package:go_router/go_router.dart';

class AddMedicationScreen extends ConsumerStatefulWidget {
  const AddMedicationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends ConsumerState<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = MedicationFormData();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medication'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/medications');
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveMedication,
            child: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Dynamic Helper Card
            Container(
              margin: ResponsiveUtils.getMargin(context),
              child: Card(
                elevation: ResponsiveUtils.getCardElevation(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.getBorderRadius(context)),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getBorderRadius(context)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primaryContainer,
                        Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: ResponsiveUtils.getPadding(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.medication_liquid,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Medication Summary',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formData.previewText,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  height: 1.5,
                                ),
                              ),
                              if (_formData.isValid) ...[
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _saveMedication,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: _isLoading
                                        ? const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                              ),
                                              SizedBox(width: 8),
                                              Text('Saving...'),
                                            ],
                                          )
                                        : const Text(
                                            'Save Medication',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: ResponsiveUtils.getPadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfoSection(),
                    const SizedBox(height: 24),
                    _buildStrengthSection(),
                    const SizedBox(height: 24),
                    _buildInventorySection(),
                    const SizedBox(height: 24),
                    _buildAdditionalInfoSection(),
                    const SizedBox(height: 60), // More space for better visibility
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      elevation: ResponsiveUtils.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveUtils.getBorderRadius(context)),
      ),
      child: Padding(
        padding: ResponsiveUtils.getPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Medication Name *',
                hintText: 'e.g., Panadol, Insulin, etc.',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Medication name is required';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _formData.name = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<MedicationType>(
              decoration: const InputDecoration(
                labelText: 'Medication Type *',
                border: OutlineInputBorder(),
              ),
              value: _formData.type,
              items: MedicationType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _formData.type = value;
                    _formData.injectionSubtype = null; // Reset injection subtype
                    // Update strength unit to available ones for this type
                    if (!_formData.availableStrengthUnits.contains(_formData.strengthUnit)) {
                      _formData.strengthUnit = _formData.availableStrengthUnits.first;
                    }
                  });
                }
              },
            ),
            if (_formData.type == MedicationType.injection) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<InjectionSubtype>(
                decoration: const InputDecoration(
                  labelText: 'Injection Subtype *',
                  border: OutlineInputBorder(),
                  helperText: 'Select the specific type of injectable medication',
                ),
                value: _formData.injectionSubtype,
                items: InjectionSubtype.values.map((subtype) {
                  return DropdownMenuItem(
                    value: subtype,
                    child: Tooltip(
                      message: _getSubtypeDescription(subtype),
                      child: Text(
                        subtype.displayName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                }).toList(),
                validator: (value) {
                  if (_formData.type == MedicationType.injection && value == null) {
                    return 'Injection subtype is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _formData.injectionSubtype = value;
                    // Reset strength unit to appropriate ones for this subtype
                    if (!_formData.availableStrengthUnits.contains(_formData.strengthUnit)) {
                      _formData.strengthUnit = _formData.availableStrengthUnits.first;
                    }
                  });
                },
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Manufacturer',
                hintText: 'e.g., GSK, Novo Nordisk',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _formData.manufacturer = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Strength Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ResponsiveUtils.buildResponsiveRow(
              context,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: _getStrengthLabel(),
                    hintText: _getStrengthHint(),
                    border: const OutlineInputBorder(),
                    helperText: _getStrengthHelperText(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Strength is required';
                    }
                    final strength = double.tryParse(value);
                    if (strength == null || strength <= 0) {
                      return 'Enter a valid strength';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _formData.strength = double.tryParse(value);
                    });
                  },
                ),
                DropdownButtonFormField<StrengthUnit>(
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    border: OutlineInputBorder(),
                  ),
                  value: _formData.strengthUnit,
                  items: _formData.availableStrengthUnits.map((unit) {
                    return DropdownMenuItem(
                      value: unit,
                      child: Text(unit.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _formData.strengthUnit = value;
                      });
                    }
                  },
                ),
              ],
            ),
            // Advanced injection fields
            if (_formData.type == MedicationType.injection) ..._buildAdvancedInjectionFields(),
          ],
        ),
      ),
    );
  }

  Widget _buildInventorySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventory Management',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '${_formData.stockLabel} *',
                      hintText: '30',
                      border: const OutlineInputBorder(),
                      helperText: _getStockHelperText(),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: _formData.currentStock.toString(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Current stock is required';
                      }
                      final stock = int.tryParse(value);
                      if (stock == null || stock < 0) {
                        return 'Enter a valid stock quantity';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _formData.currentStock = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Low Stock Alert',
                      hintText: '5',
                      border: OutlineInputBorder(),
                      helperText: 'Alert when stock falls below this amount',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _formData.minimumStock = int.tryParse(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Lot Number',
                hintText: 'ABC123',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _formData.lotNumber = value,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectExpirationDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Expiration Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _formData.expirationDate != null
                      ? DateFormat('MMM dd, yyyy').format(_formData.expirationDate!)
                      : 'Select expiration date',
                  style: TextStyle(
                    color: _formData.expirationDate != null
                        ? Theme.of(context).textTheme.bodyLarge?.color
                        : Theme.of(context).hintColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Brief description of the medication',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              onChanged: (value) => _formData.description = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Storage Instructions',
                hintText: 'Store in cool, dry place',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              onChanged: (value) => _formData.storageInstructions = value,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Requires Refrigeration'),
              subtitle: const Text('Check if this medication needs to be refrigerated'),
              value: _formData.requiresRefrigeration,
              onChanged: (value) {
                setState(() {
                  _formData.requiresRefrigeration = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Any additional notes or reminders',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) => _formData.notes = value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _saveMedication,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
            ? const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Saving...'),
                ],
              )
            : const Text(
                'Save Medication',
                style: TextStyle(fontSize: 16),
              ),
        ),
      ),
    );
  }

  Future<void> _selectExpirationDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _formData.expirationDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (date != null) {
      setState(() {
        _formData.expirationDate = date;
      });
    }
  }

  // Convert our feature medication model to core data model
  CoreMedication.Medication _convertToCoreMedication(Medication medication) {
    // Map MedicationType from feature to core
    CoreMedication.MedicationType coreType;
    switch (medication.type) {
      case MedicationType.tablet:
        coreType = CoreMedication.MedicationType.tablet;
        break;
      case MedicationType.capsule:
        coreType = CoreMedication.MedicationType.capsule;
        break;
      case MedicationType.injection:
        coreType = CoreMedication.MedicationType.injection;
        break;
      case MedicationType.topical:
        coreType = CoreMedication.MedicationType.cream;
        break;
      case MedicationType.liquid:
        coreType = CoreMedication.MedicationType.liquid;
        break;
    }

    return CoreMedication.Medication(
      id: medication.id,
      name: medication.name,
      type: coreType,
      strength: medication.strength,
      unit: medication.strengthUnit.displayName,
      currentStock: medication.currentStock,
      lowStockThreshold: medication.minimumStock ?? 5,
      expirationDate: medication.expirationDate,
      requiresReconstitution: medication.requiresRefrigeration,
      notes: [medication.description, medication.notes, medication.storageInstructions]
          .where((note) => note != null && note.isNotEmpty)
          .join('\n'),
      createdAt: medication.createdAt,
      updatedAt: medication.updatedAt,
    );
  }

  Future<void> _saveMedication() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_formData.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final medication = _formData.toMedication();
      final coreMedication = _convertToCoreMedication(medication);
      
      // Save using provider which will automatically refresh the list
      await ref.read(medicationListProvider.notifier).addMedication(coreMedication);
      
      print('Saved medication: ${medication.name}');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${medication.name} added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(true); // Return true to indicate success
      }
    } catch (e) {
      print('Error saving medication: $e');
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

  String _getStrengthLabel() {
    switch (_formData.type) {
      case MedicationType.tablet:
        return 'Strength Information *';
      case MedicationType.capsule:
        return 'Strength Information *';
      case MedicationType.injection:
        if (_formData.injectionSubtype == InjectionSubtype.prefilledSyringe) {
          return 'Strength per Pre Filled Syringe *';
        } else if (_formData.injectionSubtype == InjectionSubtype.preconstitutedVial) {
          return 'Strength per Pre Constituted Vial *';
        } else if (_formData.injectionSubtype == InjectionSubtype.lyophilizedVial) {
          return 'Strength per Lyophilized Vial *';
        }
        return 'Strength per Injection *';
      case MedicationType.topical:
        return 'Strength per Application *';
      case MedicationType.liquid:
        return 'Strength per mL *';
    }
  }

  String _getStrengthHelperText() {
    switch (_formData.type) {
      case MedicationType.tablet:
        return 'Amount of active ingredient per tablet';
      case MedicationType.capsule:
        return 'Amount of active ingredient per capsule';
      case MedicationType.injection:
        if (_formData.injectionSubtype == InjectionSubtype.prefilledSyringe) {
          return 'Total amount of active ingredient per syringe';
        } else if (_formData.injectionSubtype == InjectionSubtype.preconstitutedVial) {
          return 'Concentration of active ingredient per mL';
        } else if (_formData.injectionSubtype == InjectionSubtype.lyophilizedVial) {
          return 'Total amount after reconstitution';
        }
        return 'Amount of active ingredient per dose';
      case MedicationType.topical:
        return 'Concentration of active ingredient';
      case MedicationType.liquid:
        return 'Concentration per milliliter';
    }
  }

  String _getStockHelperText() {
    switch (_formData.type) {
      case MedicationType.tablet:
        return 'Number of individual tablets you have';
      case MedicationType.capsule:
        return 'Number of individual capsules you have';
      case MedicationType.injection:
        if (_formData.injectionSubtype == InjectionSubtype.prefilledSyringe) {
          return 'Number of pre-filled syringes you have';
        } else if (_formData.injectionSubtype == InjectionSubtype.preconstitutedVial ||
                   _formData.injectionSubtype == InjectionSubtype.lyophilizedVial) {
          return 'Volume in mL (for vials) or number of vials';
        }
        return 'Amount available for injection';
      case MedicationType.topical:
        return 'Number of tubes/containers you have';
      case MedicationType.liquid:
        return 'Number of bottles you have';
    }
  }

  String _getSubtypeDescription(InjectionSubtype subtype) {
    switch (subtype) {
      case InjectionSubtype.prefilledSyringe:
        return 'Ready-to-use syringe with pre-measured dose';
      case InjectionSubtype.preconstitutedVial:
        return 'Liquid medication ready for injection';
      case InjectionSubtype.injectionPenPrefilled:
        return 'Pre-filled pen injector (e.g., insulin pen)';
      case InjectionSubtype.injectionPenManual:
        return 'Refillable pen injector with cartridges';
      case InjectionSubtype.lyophilizedVial:
        return 'Powder requiring reconstitution before use';
    }
  }

  String _getStrengthHint() {
    switch (_formData.type) {
      case MedicationType.tablet:
      case MedicationType.capsule:
        return '500';
      case MedicationType.injection:
        if (_formData.injectionSubtype == InjectionSubtype.prefilledSyringe) {
          return '100';
        } else if (_formData.injectionSubtype == InjectionSubtype.lyophilizedVial) {
          return '50';
        }
        return '10.0';
      case MedicationType.topical:
        return '1.0';
      case MedicationType.liquid:
        return '25.0';
    }
  }

  List<Widget> _buildAdvancedInjectionFields() {
    if (_formData.injectionSubtype == null) return [];

    switch (_formData.injectionSubtype!) {
      case InjectionSubtype.lyophilizedVial:
        return _buildLyophilizedVialFields();
      case InjectionSubtype.preconstitutedVial:
      case InjectionSubtype.prefilledSyringe:
        return _buildVialFields();
      case InjectionSubtype.injectionPenPrefilled:
      case InjectionSubtype.injectionPenManual:
        return _buildPenFields();
    }
  }

  List<Widget> _buildLyophilizedVialFields() {
    return [
      const SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Reconstitution Required',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'This lyophilized powder requires reconstitution before use. The strength should reflect the final concentration after reconstitution.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.orange[700],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Reconstitution Volume (mL)',
                      hintText: '2.0',
                      border: OutlineInputBorder(),
                      helperText: 'Volume of diluent to add',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      // Store reconstitution volume - we'll add this to the model later
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Final Volume (mL)',
                      hintText: '2.1',
                      border: OutlineInputBorder(),
                      helperText: 'Total volume after reconstitution',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      // Store final volume
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildVialFields() {
    return [
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Vial Volume (mL)',
                hintText: '10.0',
                border: OutlineInputBorder(),
                helperText: 'Total volume per vial',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                // Store vial volume
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Doses per Vial',
                hintText: '10',
                border: OutlineInputBorder(),
                helperText: 'Number of doses in each vial',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Store doses per vial
              },
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildPenFields() {
    return [
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Units per Pen',
                hintText: '300',
                border: OutlineInputBorder(),
                helperText: 'Total units in each pen',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Store units per pen
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Dose Increment',
                hintText: '1',
                border: OutlineInputBorder(),
                helperText: 'Minimum dose increment',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Store dose increment
              },
            ),
          ),
        ],
      ),
    ];
  }
}
