import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../../../core/data/services/database_service.dart';
import '../../../scheduling/models/medication_schedule.dart';
import '../../../scheduling/models/dose_record.dart';
import 'schedule_repository.dart';

class SqliteScheduleRepository implements ScheduleRepository {
  final DatabaseService _databaseService;

  SqliteScheduleRepository(this._databaseService);

  // Schedule CRUD operations
  @override
  Future<List<MedicationSchedule>> getAllSchedules() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query('medication_schedules');
      
      return maps.map((map) => MedicationSchedule.fromJson(map)).toList();
    } catch (e) {
      print('Error getting all schedules: $e');
      return [];
    }
  }

  @override
  Future<List<MedicationSchedule>> getActiveSchedules() async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'medication_schedules',
        where: 'is_active = ?',
        whereArgs: [1],
      );
      
      return maps.map((map) => MedicationSchedule.fromJson(map)).toList();
    } catch (e) {
      print('Error getting active schedules: $e');
      return [];
    }
  }

  @override
  Future<List<MedicationSchedule>> getSchedulesForMedication(String medicationId) async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'medication_schedules',
        where: 'medication_id = ?',
        whereArgs: [medicationId],
      );
      
      return maps.map((map) => MedicationSchedule.fromJson(map)).toList();
    } catch (e) {
      print('Error getting schedules for medication: $e');
      return [];
    }
  }

  @override
  Future<MedicationSchedule?> getScheduleById(String id) async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'medication_schedules',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      if (maps.isNotEmpty) {
        return MedicationSchedule.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      print('Error getting schedule by id: $e');
      return null;
    }
  }

  @override
  Future<String> createSchedule(MedicationSchedule schedule) async {
    try {
      final db = await _databaseService.database;
      
      final scheduleData = {
        'id': schedule.id,
        'medication_id': schedule.medicationId,
        'name': schedule.name,
        'type': schedule.type.name,
        'frequency': schedule.frequency.name,
        'dose_config': jsonEncode(schedule.doseConfig.toJson()),
        'cycling_config': schedule.cyclingConfig != null 
            ? jsonEncode(schedule.cyclingConfig!.toJson()) 
            : null,
        'start_date': schedule.startDate.millisecondsSinceEpoch,
        'end_date': schedule.endDate?.millisecondsSinceEpoch,
        'is_active': schedule.isActive ? 1 : 0,
        'time_slots': jsonEncode(schedule.timeSlots),
        'custom_settings': jsonEncode(schedule.customSettings),
        'created_at': schedule.createdAt.millisecondsSinceEpoch,
        'updated_at': schedule.updatedAt.millisecondsSinceEpoch,
      };

      await db.insert('medication_schedules', scheduleData);
      
      // Generate initial dose records for the schedule
      await generateDoseRecords(schedule.id);
      
      return schedule.id;
    } catch (e) {
      print('Error creating schedule: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateSchedule(MedicationSchedule schedule) async {
    try {
      final db = await _databaseService.database;
      
      final scheduleData = {
        'medication_id': schedule.medicationId,
        'name': schedule.name,
        'type': schedule.type.name,
        'frequency': schedule.frequency.name,
        'dose_config': jsonEncode(schedule.doseConfig.toJson()),
        'cycling_config': schedule.cyclingConfig != null 
            ? jsonEncode(schedule.cyclingConfig!.toJson()) 
            : null,
        'start_date': schedule.startDate.millisecondsSinceEpoch,
        'end_date': schedule.endDate?.millisecondsSinceEpoch,
        'is_active': schedule.isActive ? 1 : 0,
        'time_slots': jsonEncode(schedule.timeSlots),
        'custom_settings': jsonEncode(schedule.customSettings),
        'updated_at': schedule.updatedAt.millisecondsSinceEpoch,
      };

      await db.update(
        'medication_schedules',
        scheduleData,
        where: 'id = ?',
        whereArgs: [schedule.id],
      );
    } catch (e) {
      print('Error updating schedule: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteSchedule(String id) async {
    try {
      final db = await _databaseService.database;
      
      // Delete related dose records first
      await db.delete(
        'dose_records',
        where: 'schedule_id = ?',
        whereArgs: [id],
      );
      
      // Delete the schedule
      await db.delete(
        'medication_schedules',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting schedule: $e');
      rethrow;
    }
  }

  @override
  Future<void> activateSchedule(String id) async {
    try {
      final db = await _databaseService.database;
      await db.update(
        'medication_schedules',
        {'is_active': 1, 'updated_at': DateTime.now().millisecondsSinceEpoch},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error activating schedule: $e');
      rethrow;
    }
  }

  @override
  Future<void> deactivateSchedule(String id) async {
    try {
      final db = await _databaseService.database;
      await db.update(
        'medication_schedules',
        {'is_active': 0, 'updated_at': DateTime.now().millisecondsSinceEpoch},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deactivating schedule: $e');
      rethrow;
    }
  }

  // Dose record operations
  @override
  Future<List<DoseRecord>> getDoseRecords({
    String? scheduleId,
    String? medicationId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final db = await _databaseService.database;
      
      String whereClause = '1=1';
      List<dynamic> whereArgs = [];
      
      if (scheduleId != null) {
        whereClause += ' AND schedule_id = ?';
        whereArgs.add(scheduleId);
      }
      
      if (medicationId != null) {
        whereClause += ' AND medication_id = ?';
        whereArgs.add(medicationId);
      }
      
      if (startDate != null) {
        whereClause += ' AND scheduled_time >= ?';
        whereArgs.add(startDate.millisecondsSinceEpoch);
      }
      
      if (endDate != null) {
        whereClause += ' AND scheduled_time <= ?';
        whereArgs.add(endDate.millisecondsSinceEpoch);
      }
      
      final List<Map<String, dynamic>> maps = await db.query(
        'dose_records',
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'scheduled_time ASC',
      );
      
      return maps.map((map) => DoseRecord.fromJson(map)).toList();
    } catch (e) {
      print('Error getting dose records: $e');
      return [];
    }
  }

  @override
  Future<List<DoseRecord>> getTodaysDoses() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return getDoseRecords(
      startDate: startOfDay,
      endDate: endOfDay,
    );
  }

  @override
  Future<List<DoseRecord>> getUpcomingDoses({int hoursAhead = 24}) async {
    final now = DateTime.now();
    final endTime = now.add(Duration(hours: hoursAhead));
    
    return getDoseRecords(
      startDate: now,
      endDate: endTime,
    );
  }

  @override
  Future<List<DoseRecord>> getOverdueDoses() async {
    try {
      final db = await _databaseService.database;
      final now = DateTime.now();
      
      final List<Map<String, dynamic>> maps = await db.query(
        'dose_records',
        where: 'status = ? AND scheduled_time < ?',
        whereArgs: [DoseStatus.scheduled.name, now.millisecondsSinceEpoch],
        orderBy: 'scheduled_time ASC',
      );
      
      return maps.map((map) => DoseRecord.fromJson(map)).toList();
    } catch (e) {
      print('Error getting overdue doses: $e');
      return [];
    }
  }

  @override
  Future<DoseRecord?> getDoseRecordById(String id) async {
    try {
      final db = await _databaseService.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'dose_records',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      if (maps.isNotEmpty) {
        return DoseRecord.fromJson(maps.first);
      }
      return null;
    } catch (e) {
      print('Error getting dose record by id: $e');
      return null;
    }
  }

  @override
  Future<String> createDoseRecord(DoseRecord doseRecord) async {
    try {
      final db = await _databaseService.database;
      
      final doseData = {
        'id': doseRecord.id,
        'schedule_id': doseRecord.scheduleId,
        'medication_id': doseRecord.medicationId,
        'scheduled_time': doseRecord.scheduledTime.millisecondsSinceEpoch,
        'taken_time': doseRecord.takenTime?.millisecondsSinceEpoch,
        'status': doseRecord.status.name,
        'actual_amount': doseRecord.actualAmount,
        'actual_unit': doseRecord.actualUnit,
        'volume_drawn': doseRecord.volumeDrawn,
        'notes': doseRecord.notes,
        'metadata': jsonEncode(doseRecord.metadata),
        'created_at': doseRecord.createdAt.millisecondsSinceEpoch,
        'updated_at': doseRecord.updatedAt.millisecondsSinceEpoch,
      };

      await db.insert('dose_records', doseData);
      return doseRecord.id;
    } catch (e) {
      print('Error creating dose record: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateDoseRecord(DoseRecord doseRecord) async {
    try {
      final db = await _databaseService.database;
      
      final doseData = {
        'schedule_id': doseRecord.scheduleId,
        'medication_id': doseRecord.medicationId,
        'scheduled_time': doseRecord.scheduledTime.millisecondsSinceEpoch,
        'taken_time': doseRecord.takenTime?.millisecondsSinceEpoch,
        'status': doseRecord.status.name,
        'actual_amount': doseRecord.actualAmount,
        'actual_unit': doseRecord.actualUnit,
        'volume_drawn': doseRecord.volumeDrawn,
        'notes': doseRecord.notes,
        'metadata': jsonEncode(doseRecord.metadata),
        'updated_at': doseRecord.updatedAt.millisecondsSinceEpoch,
      };

      await db.update(
        'dose_records',
        doseData,
        where: 'id = ?',
        whereArgs: [doseRecord.id],
      );
    } catch (e) {
      print('Error updating dose record: $e');
      rethrow;
    }
  }

  @override
  Future<void> markDoseAsTaken(String doseId, {
    DateTime? takenTime,
    double? actualAmount,
    String? actualUnit,
    double? volumeDrawn,
    String? notes,
  }) async {
    try {
      final db = await _databaseService.database;
      
      final updateData = {
        'status': DoseStatus.taken.name,
        'taken_time': (takenTime ?? DateTime.now()).millisecondsSinceEpoch,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      };
      
      if (actualAmount != null) updateData['actual_amount'] = actualAmount;
      if (actualUnit != null) updateData['actual_unit'] = actualUnit;
      if (volumeDrawn != null) updateData['volume_drawn'] = volumeDrawn;
      if (notes != null) updateData['notes'] = notes;

      await db.update(
        'dose_records',
        updateData,
        where: 'id = ?',
        whereArgs: [doseId],
      );
    } catch (e) {
      print('Error marking dose as taken: $e');
      rethrow;
    }
  }

  @override
  Future<void> markDoseAsMissed(String doseId, {String? reason}) async {
    try {
      final db = await _databaseService.database;
      
      final updateData = {
        'status': DoseStatus.missed.name,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      };
      
      if (reason != null) updateData['notes'] = reason;

      await db.update(
        'dose_records',
        updateData,
        where: 'id = ?',
        whereArgs: [doseId],
      );
    } catch (e) {
      print('Error marking dose as missed: $e');
      rethrow;
    }
  }

  @override
  Future<void> markDoseAsSkipped(String doseId, {String? reason}) async {
    try {
      final db = await _databaseService.database;
      
      final updateData = {
        'status': DoseStatus.skipped.name,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      };
      
      if (reason != null) updateData['notes'] = reason;

      await db.update(
        'dose_records',
        updateData,
        where: 'id = ?',
        whereArgs: [doseId],
      );
    } catch (e) {
      print('Error marking dose as skipped: $e');
      rethrow;
    }
  }

  // Adherence and statistics
  @override
  Future<AdherenceStats> calculateAdherenceStats({
    required String medicationId,
    String? scheduleId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final doseRecords = await getDoseRecords(
        medicationId: medicationId,
        scheduleId: scheduleId,
        startDate: startDate,
        endDate: endDate,
      );

      final totalDoses = doseRecords.length;
      final takenDoses = doseRecords.where((d) => d.wasTaken).length;
      final missedDoses = doseRecords.where((d) => d.wasMissed).length;
      final onTimeDoses = doseRecords.where((d) => d.isTakenOnTime).length;
      final lateDoses = takenDoses - onTimeDoses;

      final adherenceRate = totalDoses > 0 ? (takenDoses / totalDoses) * 100 : 0.0;
      final onTimeRate = totalDoses > 0 ? (onTimeDoses / totalDoses) * 100 : 0.0;

      // Calculate average delay
      final takenRecords = doseRecords.where((d) => d.wasTaken && d.timeDifference != null);
      final averageDelayMs = takenRecords.isNotEmpty
          ? takenRecords.map((d) => d.timeDifference!.inMilliseconds).reduce((a, b) => a + b) ~/ takenRecords.length
          : 0;

      return AdherenceStats(
        medicationId: medicationId,
        scheduleId: scheduleId,
        periodStart: startDate,
        periodEnd: endDate,
        totalDoses: totalDoses,
        takenDoses: takenDoses,
        missedDoses: missedDoses,
        onTimeDoses: onTimeDoses,
        lateDoses: lateDoses,
        adherenceRate: adherenceRate,
        onTimeRate: onTimeRate,
        averageDelay: Duration(milliseconds: averageDelayMs),
        missedReasons: {}, // TODO: Implement reason categorization
        calculatedAt: DateTime.now(),
      );
    } catch (e) {
      print('Error calculating adherence stats: $e');
      rethrow;
    }
  }

  @override
  Future<double> getAdherenceRate(String medicationId, {int days = 30}) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    
    final stats = await calculateAdherenceStats(
      medicationId: medicationId,
      startDate: startDate,
      endDate: endDate,
    );
    
    return stats.adherenceRate;
  }

  @override
  Future<List<DoseRecord>> getMissedDoses({
    String? medicationId,
    String? scheduleId,
    int days = 7,
  }) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    
    final allDoses = await getDoseRecords(
      medicationId: medicationId,
      scheduleId: scheduleId,
      startDate: startDate,
      endDate: endDate,
    );
    
    return allDoses.where((d) => d.wasMissed).toList();
  }

  // Schedule generation and automation
  @override
  Future<void> generateDoseRecords(String scheduleId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final schedule = await getScheduleById(scheduleId);
      if (schedule == null || !schedule.isActive) return;

      final now = DateTime.now();
      final genStartDate = startDate ?? schedule.startDate;
      final genEndDate = endDate ?? schedule.endDate ?? now.add(const Duration(days: 30));

      // Generate dose records based on schedule frequency and time slots
      final dosesToGenerate = _calculateDoseTimes(schedule, genStartDate, genEndDate);

      for (final doseTime in dosesToGenerate) {
        // Check if dose record already exists
        final existingDoses = await getDoseRecords(
          scheduleId: scheduleId,
          startDate: doseTime,
          endDate: doseTime.add(const Duration(minutes: 1)),
        );

        if (existingDoses.isEmpty) {
          final doseRecord = DoseRecord(
            id: '${scheduleId}_${doseTime.millisecondsSinceEpoch}',
            scheduleId: scheduleId,
            medicationId: schedule.medicationId,
            scheduledTime: doseTime,
            status: DoseStatus.scheduled,
            metadata: {},
            createdAt: now,
            updatedAt: now,
          );

          await createDoseRecord(doseRecord);
        }
      }
    } catch (e) {
      print('Error generating dose records: $e');
      rethrow;
    }
  }

  @override
  Future<int> generateMissingDoseRecords() async {
    try {
      final activeSchedules = await getActiveSchedules();
      int generated = 0;

      for (final schedule in activeSchedules) {
        await generateDoseRecords(schedule.id);
        generated++;
      }

      return generated;
    } catch (e) {
      print('Error generating missing dose records: $e');
      return 0;
    }
  }

  @override
  Future<void> updateCyclingSchedules() async {
    try {
      final cyclingSchedules = await getAllSchedules();
      final cyclingOnly = cyclingSchedules.where((s) => 
        s.type == ScheduleType.cycling && s.cyclingConfig != null
      ).toList();

      for (final schedule in cyclingOnly) {
        final cycling = schedule.cyclingConfig!;
        final now = DateTime.now();
        
        // Check if we need to update the cycle phase
        if (cycling.nextPhaseDate != null && now.isAfter(cycling.nextPhaseDate!)) {
          // TODO: Implement cycle phase transition logic
          // This would update the cycling configuration and potentially
          // deactivate/reactivate the schedule based on on/off periods
        }
      }
    } catch (e) {
      print('Error updating cycling schedules: $e');
    }
  }

  // Helper method to calculate dose times based on schedule
  List<DateTime> _calculateDoseTimes(MedicationSchedule schedule, DateTime startDate, DateTime endDate) {
    final doseTimes = <DateTime>[];
    final current = DateTime(startDate.year, startDate.month, startDate.day);

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      // Check if this day should have doses based on frequency
      if (_shouldHaveDoseOnDay(schedule, current)) {
        // Add doses for each time slot
        for (final timeSlot in schedule.timeSlots) {
          final timeParts = timeSlot.split(':');
          if (timeParts.length == 2) {
            final hour = int.tryParse(timeParts[0]) ?? 0;
            final minute = int.tryParse(timeParts[1]) ?? 0;
            
            final doseTime = DateTime(
              current.year,
              current.month,
              current.day,
              hour,
              minute,
            );
            
            if (doseTime.isAfter(startDate) && doseTime.isBefore(endDate)) {
              doseTimes.add(doseTime);
            }
          }
        }
      }
      
      current.add(const Duration(days: 1));
    }

    return doseTimes;
  }

  // Helper method to check if a day should have doses
  bool _shouldHaveDoseOnDay(MedicationSchedule schedule, DateTime day) {
    switch (schedule.frequency) {
      case ScheduleFrequency.onceDaily:
      case ScheduleFrequency.twiceDaily:
      case ScheduleFrequency.threeTimes:
      case ScheduleFrequency.fourTimes:
        return true;
      case ScheduleFrequency.everyOtherDay:
        final daysSinceStart = day.difference(schedule.startDate).inDays;
        return daysSinceStart % 2 == 0;
      case ScheduleFrequency.weekly:
        return day.weekday == schedule.startDate.weekday;
      case ScheduleFrequency.biweekly:
        final weeksSinceStart = day.difference(schedule.startDate).inDays ~/ 7;
        return weeksSinceStart % 2 == 0 && day.weekday == schedule.startDate.weekday;
      case ScheduleFrequency.monthly:
        return day.day == schedule.startDate.day;
      case ScheduleFrequency.asNeeded:
        return false; // As-needed doses are not automatically scheduled
      case ScheduleFrequency.custom:
        // TODO: Implement custom frequency logic based on customSettings
        return true;
    }
  }
}
