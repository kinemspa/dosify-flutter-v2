/// Utility functions for number formatting
class NumberFormatter {
  /// Formats a double by removing trailing zeros and unnecessary decimal points
  static String formatNumber(double number) {
    if (number == number.roundToDouble()) {
      return number.toInt().toString();
    } else {
      return number.toString().replaceAll(RegExp(r'\.?0+$'), '');
    }
  }

  /// Formats a double with specific decimal places, removing trailing zeros
  static String formatDecimal(double number, int decimalPlaces) {
    String formatted = number.toStringAsFixed(decimalPlaces);
    return formatted.replaceAll(RegExp(r'\.?0+$'), '');
  }

  /// Formats strength display for medications
  static String formatStrength(double strength, String unit) {
    return '${formatNumber(strength)} $unit';
  }

  /// Formats stock quantities with proper pluralization
  static String formatStock(int quantity, String unit, String pluralUnit) {
    if (quantity == 1) {
      return '$quantity $unit';
    } else {
      return '$quantity $pluralUnit';
    }
  }
}
