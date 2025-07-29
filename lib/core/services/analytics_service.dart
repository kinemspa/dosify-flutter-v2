import 'dart:developer' as developer;
import 'dart:math';
import '../data/models/medication.dart';

/// Service for calculating medication adherence and health analytics
class AnalyticsService {
  static AnalyticsService? _instance;
  static AnalyticsService get instance => _instance ??= AnalyticsService._();
  
  AnalyticsService._();
  
  /// Calculate adherence rate for a medication over a specific period
  Future<AdherenceStats> calculateAdherenceRate({
    required String medicationId,
    required int days,
  }) async {
    try {
      developer.log('Calculating adherence rate for medication: $medicationId over $days days', 
          name: 'AnalyticsService');
      
      // TODO: Implement actual calculation from dose records
      // This is a placeholder implementation
      final random = Random();
      final adherenceRate = 75 + random.nextInt(20); // 75-95% range
      
      return AdherenceStats(
        medicationId: medicationId,
        period: Duration(days: days),
        totalScheduledDoses: days * 2, // Assuming twice daily
        takenDoses: ((days * 2) * adherenceRate / 100).round(),
        missedDoses: days * 2 - ((days * 2) * adherenceRate / 100).round(),
        adherenceRate: adherenceRate.toDouble(),
        consecutiveDays: random.nextInt(10) + 1,
        averageDelay: Duration(minutes: random.nextInt(30)),
      );
    } catch (e, stackTrace) {
      developer.log('Error calculating adherence rate: $e', 
          name: 'AnalyticsService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  /// Generate adherence trends over time
  Future<List<AdherenceTrend>> generateAdherenceTrends({
    required String medicationId,
    required int weeks,
  }) async {
    try {
      developer.log('Generating adherence trends for $weeks weeks', 
          name: 'AnalyticsService');
      
      final trends = <AdherenceTrend>[];
      final random = Random();
      
      for (int i = 0; i < weeks; i++) {
        final weekStart = DateTime.now().subtract(Duration(days: (weeks - i) * 7));
        final adherenceRate = 70 + random.nextInt(25); // 70-95% range
        
        trends.add(AdherenceTrend(
          weekStart: weekStart,
          weekEnd: weekStart.add(const Duration(days: 7)),
          adherenceRate: adherenceRate.toDouble(),
          totalDoses: 14, // Twice daily for 7 days
          takenDoses: (14 * adherenceRate / 100).round(),
        ));
      }
      
      return trends;
    } catch (e, stackTrace) {
      developer.log('Error generating adherence trends: $e', 
          name: 'AnalyticsService', error: e, stackTrace: stackTrace);
      return [];
    }
  }
  
  /// Calculate medication effectiveness metrics
  Future<EffectivenessMetrics> calculateEffectiveness({
    required String medicationId,
    required Duration period,
  }) async {
    try {
      developer.log('Calculating effectiveness metrics for medication: $medicationId', 
          name: 'AnalyticsService');
      
      // TODO: Implement actual effectiveness calculation
      final random = Random();
      
      return EffectivenessMetrics(
        medicationId: medicationId,
        period: period,
        averageEffectiveness: 7.5 + random.nextDouble() * 2, // 7.5-9.5 scale
        consistencyScore: 80 + random.nextInt(15), // 80-95%
        sideEffectFrequency: random.nextInt(10), // 0-10%
        qualityOfLifeImprovement: 15 + random.nextInt(10), // 15-25%
        recommendationScore: 8.0 + random.nextDouble() * 1.5, // 8.0-9.5
      );
    } catch (e, stackTrace) {
      developer.log('Error calculating effectiveness: $e', 
          name: 'AnalyticsService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  /// Generate cost analysis for medications
  Future<CostAnalysis> analyzeCosts({
    required List<Medication> medications,
    required Duration period,
  }) async {
    try {
      developer.log('Analyzing medication costs over period: ${period.inDays} days', 
          name: 'AnalyticsService');
      
      // TODO: Implement actual cost calculation from medication data
      final random = Random();
      double totalCost = 0;
      final medicationCosts = <String, double>{};
      
      for (final medication in medications) {
        final cost = (50 + random.nextInt(200)).toDouble(); // $50-$250 per medication
        medicationCosts[medication.id] = cost;
        totalCost += cost;
      }
      
      return CostAnalysis(
        period: period,
        totalCost: totalCost,
        averageCostPerDay: totalCost / period.inDays,
        medicationCosts: medicationCosts,
        potentialSavings: totalCost * 0.1, // 10% potential savings
        insuranceCoverage: totalCost * 0.7, // 70% coverage
        outOfPocketCost: totalCost * 0.3, // 30% out of pocket
      );
    } catch (e, stackTrace) {
      developer.log('Error analyzing costs: $e', 
          name: 'AnalyticsService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  
  /// Generate health insights based on medication data
  Future<List<HealthInsight>> generateHealthInsights({
    required List<Medication> medications,
    required List<AdherenceStats> adherenceStats,
  }) async {
    try {
      developer.log('Generating health insights for ${medications.length} medications', 
          name: 'AnalyticsService');
      
      final insights = <HealthInsight>[];
      
      // Adherence insights
      final lowAdherenceMeds = adherenceStats.where((stats) => stats.adherenceRate < 80).toList();
      if (lowAdherenceMeds.isNotEmpty) {
        insights.add(HealthInsight(
          type: InsightType.adherenceWarning,
          title: 'Low Adherence Detected',
          description: '${lowAdherenceMeds.length} medication(s) have adherence below 80%',
          severity: InsightSeverity.warning,
          actionable: true,
          recommendations: [
            'Set up medication reminders',
            'Consider pill organizers',
            'Consult with healthcare provider',
          ],
        ));
      }
      
      // Stock insights
      final lowStockMeds = medications.where((med) => med.isLowStock).toList();
      if (lowStockMeds.isNotEmpty) {
        insights.add(HealthInsight(
          type: InsightType.inventoryAlert,
          title: 'Low Stock Alert',
          description: '${lowStockMeds.length} medication(s) are running low',
          severity: InsightSeverity.high,
          actionable: true,
          recommendations: [
            'Refill prescriptions soon',
            'Contact pharmacy or doctor',
            'Update stock thresholds if needed',
          ],
        ));
      }
      
      // Expiration insights
      final expiringMeds = medications.where((med) => med.isExpiringSoon).toList();
      if (expiringMeds.isNotEmpty) {
        insights.add(HealthInsight(
          type: InsightType.expirationWarning,
          title: 'Medications Expiring Soon',
          description: '${expiringMeds.length} medication(s) will expire within 30 days',
          severity: InsightSeverity.medium,
          actionable: true,
          recommendations: [
            'Use older medications first',
            'Check with pharmacy for fresh stock',
            'Properly dispose of expired medications',
          ],
        ));
      }
      
      // Positive insights
      final highAdherenceMeds = adherenceStats.where((stats) => stats.adherenceRate >= 90).toList();
      if (highAdherenceMeds.isNotEmpty) {
        insights.add(HealthInsight(
          type: InsightType.positiveReinforcement,
          title: 'Excellent Adherence!',
          description: '${highAdherenceMeds.length} medication(s) have excellent adherence (≥90%)',
          severity: InsightSeverity.low,
          actionable: false,
          recommendations: [
            'Keep up the great work!',
            'Your consistency is beneficial for your health',
          ],
        ));
      }
      
      return insights;
    } catch (e, stackTrace) {
      developer.log('Error generating health insights: $e', 
          name: 'AnalyticsService', error: e, stackTrace: stackTrace);
      return [];
    }
  }
  
  /// Calculate overall health score based on multiple factors
  Future<HealthScore> calculateOverallHealthScore({
    required List<AdherenceStats> adherenceStats,
    required List<Medication> medications,
  }) async {
    try {
      developer.log('Calculating overall health score', name: 'AnalyticsService');
      
      if (adherenceStats.isEmpty) {
        return HealthScore(
          overallScore: 50,
          adherenceScore: 0,
          inventoryScore: 50,
          consistencyScore: 0,
          improvementAreas: ['Add medications and track adherence to get insights'],
        );
      }
      
      // Calculate adherence score (40% of total)
      final avgAdherence = adherenceStats.map((s) => s.adherenceRate).reduce((a, b) => a + b) / adherenceStats.length;
      final adherenceScore = (avgAdherence * 0.4).round();
      
      // Calculate inventory score (30% of total)
      final lowStockCount = medications.where((m) => m.isLowStock).length;
      final expiredCount = medications.where((m) => m.isExpired).length;
      final inventoryScore = ((medications.length - lowStockCount - expiredCount) / medications.length * 30).round();
      
      // Calculate consistency score (30% of total)
      final avgConsecutiveDays = adherenceStats.map((s) => s.consecutiveDays).reduce((a, b) => a + b) / adherenceStats.length;
      final consistencyScore = (min(avgConsecutiveDays / 30, 1.0) * 30).round();
      
      final overallScore = adherenceScore + inventoryScore + consistencyScore;
      
      final improvementAreas = <String>[];
      if (adherenceScore < 30) improvementAreas.add('Improve medication adherence');
      if (inventoryScore < 20) improvementAreas.add('Manage medication inventory better');
      if (consistencyScore < 20) improvementAreas.add('Take medications more consistently');
      
      return HealthScore(
        overallScore: overallScore,
        adherenceScore: adherenceScore,
        inventoryScore: inventoryScore,
        consistencyScore: consistencyScore,
        improvementAreas: improvementAreas,
      );
    } catch (e, stackTrace) {
      developer.log('Error calculating health score: $e', 
          name: 'AnalyticsService', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

// Data models for analytics

class AdherenceStats {
  final String medicationId;
  final Duration period;
  final int totalScheduledDoses;
  final int takenDoses;
  final int missedDoses;
  final double adherenceRate;
  final int consecutiveDays;
  final Duration averageDelay;
  
  AdherenceStats({
    required this.medicationId,
    required this.period,
    required this.totalScheduledDoses,
    required this.takenDoses,
    required this.missedDoses,
    required this.adherenceRate,
    required this.consecutiveDays,
    required this.averageDelay,
  });
  
  int get missedRate => ((missedDoses / totalScheduledDoses) * 100).round();
}

class AdherenceTrend {
  final DateTime weekStart;
  final DateTime weekEnd;
  final double adherenceRate;
  final int totalDoses;
  final int takenDoses;
  
  AdherenceTrend({
    required this.weekStart,
    required this.weekEnd,
    required this.adherenceRate,
    required this.totalDoses,
    required this.takenDoses,
  });
}

class EffectivenessMetrics {
  final String medicationId;
  final Duration period;
  final double averageEffectiveness; // 1-10 scale
  final int consistencyScore; // 0-100%
  final int sideEffectFrequency; // 0-100%
  final int qualityOfLifeImprovement; // 0-100%
  final double recommendationScore; // 1-10 scale
  
  EffectivenessMetrics({
    required this.medicationId,
    required this.period,
    required this.averageEffectiveness,
    required this.consistencyScore,
    required this.sideEffectFrequency,
    required this.qualityOfLifeImprovement,
    required this.recommendationScore,
  });
}

class CostAnalysis {
  final Duration period;
  final double totalCost;
  final double averageCostPerDay;
  final Map<String, double> medicationCosts;
  final double potentialSavings;
  final double insuranceCoverage;
  final double outOfPocketCost;
  
  CostAnalysis({
    required this.period,
    required this.totalCost,
    required this.averageCostPerDay,
    required this.medicationCosts,
    required this.potentialSavings,
    required this.insuranceCoverage,
    required this.outOfPocketCost,
  });
}

class HealthInsight {
  final InsightType type;
  final String title;
  final String description;
  final InsightSeverity severity;
  final bool actionable;
  final List<String> recommendations;
  
  HealthInsight({
    required this.type,
    required this.title,
    required this.description,
    required this.severity,
    required this.actionable,
    required this.recommendations,
  });
}

class HealthScore {
  final int overallScore; // 0-100
  final int adherenceScore; // 0-40
  final int inventoryScore; // 0-30
  final int consistencyScore; // 0-30
  final List<String> improvementAreas;
  
  HealthScore({
    required this.overallScore,
    required this.adherenceScore,
    required this.inventoryScore,
    required this.consistencyScore,
    required this.improvementAreas,
  });
  
  String get rating {
    if (overallScore >= 90) return 'Excellent';
    if (overallScore >= 80) return 'Very Good';
    if (overallScore >= 70) return 'Good';
    if (overallScore >= 60) return 'Fair';
    return 'Needs Improvement';
  }
}

enum InsightType {
  adherenceWarning,
  inventoryAlert,
  expirationWarning,
  positiveReinforcement,
  costOptimization,
  healthImprovement,
}

enum InsightSeverity {
  low,
  medium,
  warning,
  high,
  critical,
}
