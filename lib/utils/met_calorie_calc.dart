// lib/utils/met_calorie_calc.dart

/// A simple MET calculator:
/// calories ≈ (MET × 3.5 × weight_kg ÷ 200) × duration_minutes
double caloriesFromMET({
  required double metValue,
  required double weightKg,
  required int durationSeconds,
}) {
  final double durationMinutes = durationSeconds / 60.0;
  return (metValue * 3.5 * weightKg / 200.0) * durationMinutes;
}
