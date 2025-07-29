import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../medication/providers/medication_providers.dart';
import '../../../../core/data/models/medication.dart';
import '../../providers/schedule_providers.dart';
import '../../models/medication_schedule.dart';

class AddScheduleScreen extends ConsumerStatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  ConsumerState<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends ConsumerState<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _doseAmountController = TextEditingController();
  final _doseUnitController = TextEditingController(text: 'mg');
  
  String? _selectedMedicationId;
  ScheduleType _scheduleType = ScheduleType.daily;
  ScheduleFrequency _frequency = ScheduleFrequency.onceDaily;
  CalculationMethod _calculationMethod = CalculationMethod.direct;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _isActive = true;
  List<TimeOfDay> _timeSlots = [const TimeOfDay(hour: 8, minute: 0)];
  
  // Cycling configuration
  bool _enableCycling = false;
  int _onDays = 5;
  int _offDays = 2;
  int _totalCycles = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _doseAmountController.dispose();
    _doseUnitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medicationsAsync = ref.watch(medicationListProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Schedule'),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveSchedule,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: medicationsAsync.when(
        data: (medications) {
          if (medications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.medication, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No medications available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please add a medication first before creating a schedule',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }
          
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildBasicInfoSection(medications),
                const SizedBox(height: 24),
                _buildDoseConfigurationSection(),
                const SizedBox(height: 24),
                _buildScheduleConfigurationSection(),
                const SizedBox(height: 24),
                _buildTimeSlotSection(),
                const SizedBox(height: 24),
                _buildCyclingSection(),
                const SizedBox(height: 24),
                _buildDatesSection(),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading medications: ${error.toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(medicationListProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(List<Medication> medications) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Schedule Name',
                hintText: 'e.g., Morning Dose, Evening Injection',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a schedule name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedMedicationId,
              decoration: const InputDecoration(
                labelText: 'Medication',
                border: OutlineInputBorder(),
              ),
              items: medications.map((medication) {
                return DropdownMenuItem(
                  value: medication.id,
                  child: Text('${medication.name} (${medication.displayStrength})'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMedicationId = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a medication';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Active Schedule'),
              subtitle: const Text('Schedule will be active immediately'),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoseConfigurationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dose Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _doseAmountController,
                    decoration: const InputDecoration(
                      labelText: 'Dose Amount',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter dose amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _doseUnitController,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter unit';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CalculationMethod>(
              value: _calculationMethod,
              decoration: const InputDecoration(
                labelText: 'Calculation Method',
                border: OutlineInputBorder(),
              ),
              items: CalculationMethod.values.map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Text(_getCalculationMethodText(method)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _calculationMethod = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleConfigurationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Schedule Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ScheduleType>(
              value: _scheduleType,
              decoration: const InputDecoration(
                labelText: 'Schedule Type',
                border: OutlineInputBorder(),
              ),
              items: ScheduleType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getScheduleTypeText(type)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _scheduleType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ScheduleFrequency>(
              value: _frequency,
              decoration: const InputDecoration(
                labelText: 'Frequency',
                border: OutlineInputBorder(),
              ),
              items: ScheduleFrequency.values.map((freq) {
                return DropdownMenuItem(
                  value: freq,
                  child: Text(_getFrequencyText(freq)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _frequency = value!;
                  _updateTimeSlotsForFrequency();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Time Slots',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: _addTimeSlot,
                  icon: const Icon(Icons.add),
                  tooltip: 'Add time slot',
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._timeSlots.asMap().entries.map((entry) {
              final index = entry.key;
              final timeSlot = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(index),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            timeSlot.format(context),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    if (_timeSlots.length > 1)
                      IconButton(
                        onPressed: () => _removeTimeSlot(index),
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCyclingSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cycling Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'For peptides and hormones that require cycling',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Cycling'),
              subtitle: const Text('Schedule will follow on/off cycles'),
              value: _enableCycling,
              onChanged: (value) {
                setState(() {
                  _enableCycling = value;
                  if (value) {
                    _scheduleType = ScheduleType.cycling;
                  }
                });
              },
            ),
            if (_enableCycling) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _onDays.toString(),
                      decoration: const InputDecoration(
                        labelText: 'On Days',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _onDays = int.tryParse(value) ?? _onDays;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      initialValue: _offDays.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Off Days',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _offDays = int.tryParse(value) ?? _offDays;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _totalCycles.toString(),
                decoration: const InputDecoration(
                  labelText: 'Total Cycles',
                  hintText: '0 for unlimited',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _totalCycles = int.tryParse(value) ?? _totalCycles;
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDatesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Schedule Dates',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Start Date'),
              subtitle: Text('${_startDate.day}/${_startDate.month}/${_startDate.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectStartDate(),
            ),
            const Divider(),
            ListTile(
              title: const Text('End Date (Optional)'),
              subtitle: Text(_endDate != null 
                  ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                  : 'No end date'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_endDate != null)
                    IconButton(
                      onPressed: () => setState(() => _endDate = null),
                      icon: const Icon(Icons.clear),
                    ),
                  const Icon(Icons.calendar_today),
                ],
              ),
              onTap: () => _selectEndDate(),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTimeSlotsForFrequency() {
    switch (_frequency) {
      case ScheduleFrequency.onceDaily:
        _timeSlots = [const TimeOfDay(hour: 8, minute: 0)];
        break;
      case ScheduleFrequency.twiceDaily:
        _timeSlots = [
          const TimeOfDay(hour: 8, minute: 0),
          const TimeOfDay(hour: 20, minute: 0),
        ];
        break;
      case ScheduleFrequency.threeTimes:
        _timeSlots = [
          const TimeOfDay(hour: 8, minute: 0),
          const TimeOfDay(hour: 14, minute: 0),
          const TimeOfDay(hour: 20, minute: 0),
        ];
        break;
      case ScheduleFrequency.fourTimes:
        _timeSlots = [
          const TimeOfDay(hour: 8, minute: 0),
          const TimeOfDay(hour: 12, minute: 0),
          const TimeOfDay(hour: 16, minute: 0),
          const TimeOfDay(hour: 20, minute: 0),
        ];
        break;
      default:
        // Keep current time slots for other frequencies
        break;
    }
  }

  void _addTimeSlot() {
    setState(() {
      _timeSlots.add(const TimeOfDay(hour: 12, minute: 0));
    });
  }

  void _removeTimeSlot(int index) {
    setState(() {
      _timeSlots.removeAt(index);
    });
  }

  Future<void> _selectTime(int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _timeSlots[index],
    );
    if (picked != null) {
      setState(() {
        _timeSlots[index] = picked;
      });
    }
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 30)),
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _saveSchedule() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedMedicationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a medication')),
      );
      return;
    }

    try {
      final doseAmount = double.parse(_doseAmountController.text);
      final doseUnit = _doseUnitController.text.trim();
      
      final doseConfig = DoseConfiguration(
        amount: doseAmount,
        unit: doseUnit,
        calculationMethod: _calculationMethod,
        calculationParams: {},
      );

      CyclingConfiguration? cyclingConfig;
      if (_enableCycling) {
        cyclingConfig = CyclingConfiguration(
          onDays: _onDays,
          offDays: _offDays,
          currentCycle: 1,
          totalCycles: _totalCycles,
          currentPhase: CyclePhase.on,
          cycleStartDate: _startDate,
          cycleNotes: {},
        );
      }

      final schedule = MedicationSchedule(
        id: const Uuid().v4(),
        medicationId: _selectedMedicationId!,
        name: _nameController.text.trim(),
        type: _enableCycling ? ScheduleType.cycling : _scheduleType,
        frequency: _frequency,
        doseConfig: doseConfig,
        cyclingConfig: cyclingConfig,
        startDate: _startDate,
        endDate: _endDate,
        isActive: _isActive,
        timeSlots: _timeSlots.map((time) => 
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
        ).toList(),
        customSettings: {},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await ref.read(scheduleListProvider.notifier).createSchedule(schedule);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule created successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating schedule: $e')),
      );
    }
  }

  String _getCalculationMethodText(CalculationMethod method) {
    switch (method) {
      case CalculationMethod.direct:
        return 'Direct Amount';
      case CalculationMethod.concentration:
        return 'By Concentration';
      case CalculationMethod.bodyWeight:
        return 'By Body Weight';
      case CalculationMethod.bodyArea:
        return 'By Body Surface Area';
      case CalculationMethod.reconstitution:
        return 'By Reconstitution';
      case CalculationMethod.custom:
        return 'Custom Method';
    }
  }

  String _getScheduleTypeText(ScheduleType type) {
    switch (type) {
      case ScheduleType.daily:
        return 'Daily';
      case ScheduleType.weekly:
        return 'Weekly';
      case ScheduleType.monthly:
        return 'Monthly';
      case ScheduleType.asNeeded:
        return 'As Needed';
      case ScheduleType.cycling:
        return 'Cycling';
      case ScheduleType.custom:
        return 'Custom';
    }
  }

  String _getFrequencyText(ScheduleFrequency frequency) {
    switch (frequency) {
      case ScheduleFrequency.onceDaily:
        return 'Once Daily';
      case ScheduleFrequency.twiceDaily:
        return 'Twice Daily';
      case ScheduleFrequency.threeTimes:
        return '3 Times Daily';
      case ScheduleFrequency.fourTimes:
        return '4 Times Daily';
      case ScheduleFrequency.everyOtherDay:
        return 'Every Other Day';
      case ScheduleFrequency.weekly:
        return 'Weekly';
      case ScheduleFrequency.biweekly:
        return 'Bi-weekly';
      case ScheduleFrequency.monthly:
        return 'Monthly';
      case ScheduleFrequency.asNeeded:
        return 'As Needed';
      case ScheduleFrequency.custom:
        return 'Custom';
    }
  }
}
