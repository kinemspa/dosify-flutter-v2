import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/medication.dart';
import '../../../core/data/repositories/medication_repository.dart';
import '../../../core/data/models/medication.dart' as CoreMedication;
import '../../../core/di/service_locator.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({Key? key}) : super(key: key);

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = MedicationFormData();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medication'),
        centerTitle: true,
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
              margin: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
                    padding: const EdgeInsets.all(20.0),
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
                          child: Text(
                            _formData.previewText,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              height: 1.5,
                            ),
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
                padding: const EdgeInsets.all(16.0),
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
                    const SizedBox(height: 32),
                    _buildSaveButton(),
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                ),
                value: _formData.injectionSubtype,
                items: InjectionSubtype.values.map((subtype) {
                  return DropdownMenuItem(
                    value: subtype,
                    child: Text(subtype.displayName),
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
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Strength *',
                      hintText: '500',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
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
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<StrengthUnit>(
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
                ),
              ],
            ),
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
                      labelText: 'Minimum Stock',
                      hintText: '5',
                      border: OutlineInputBorder(),
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveMedication,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
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
      
      // Save to repository
      final repository = getIt<MedicationRepository>();
      await repository.addMedication(coreMedication);
      
      print('Saved medication: ${medication.name}');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${medication.name} added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
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
}
