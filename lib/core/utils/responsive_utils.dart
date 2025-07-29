import 'package:flutter/material.dart';

class ResponsiveUtils {
  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 1024;
  static const double _desktopBreakpoint = 1440;

  /// Get the screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get the screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Check if device is mobile size
  static bool isMobile(BuildContext context) {
    return screenWidth(context) < _mobileBreakpoint;
  }

  /// Check if device is tablet size
  static bool isTablet(BuildContext context) {
    final width = screenWidth(context);
    return width >= _mobileBreakpoint && width < _tabletBreakpoint;
  }

  /// Check if device is desktop size
  static bool isDesktop(BuildContext context) {
    return screenWidth(context) >= _tabletBreakpoint;
  }

  /// Check if device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Check if device is in portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Get responsive font size based on screen size
  static double getFontSize(BuildContext context, {
    double mobile = 14.0,
    double tablet = 16.0,
    double desktop = 18.0,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getPadding(BuildContext context, {
    EdgeInsets mobile = const EdgeInsets.all(16.0),
    EdgeInsets tablet = const EdgeInsets.all(24.0),
    EdgeInsets desktop = const EdgeInsets.all(32.0),
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Get responsive margin based on screen size
  static EdgeInsets getMargin(BuildContext context, {
    EdgeInsets mobile = const EdgeInsets.all(8.0),
    EdgeInsets tablet = const EdgeInsets.all(12.0),
    EdgeInsets desktop = const EdgeInsets.all(16.0),
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Get responsive column count for grid layouts
  static int getGridColumns(BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Get responsive card elevation
  static double getCardElevation(BuildContext context, {
    double mobile = 2.0,
    double tablet = 4.0,
    double desktop = 6.0,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Get responsive border radius
  static double getBorderRadius(BuildContext context, {
    double mobile = 8.0,
    double tablet = 12.0,
    double desktop = 16.0,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Get responsive icon size
  static double getIconSize(BuildContext context, {
    double mobile = 24.0,
    double tablet = 28.0,
    double desktop = 32.0,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Get responsive app bar height
  static double getAppBarHeight(BuildContext context, {
    double mobile = 56.0,
    double tablet = 64.0,
    double desktop = 72.0,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Get responsive text scale factor
  static double getTextScaleFactor(BuildContext context, {
    double mobile = 1.0,
    double tablet = 1.1,
    double desktop = 1.2,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  /// Responsive layout helper for form fields
  static Widget buildResponsiveRow(
    BuildContext context, {
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    if (isMobile(context) && isPortrait(context)) {
      // Stack children vertically on mobile portrait
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children
            .expand((child) => [child, const SizedBox(height: 16)])
            .take(children.length * 2 - 1)
            .toList(),
      );
    } else {
      // Use row layout for tablet/desktop or mobile landscape
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children
            .expand((child) => [Expanded(child: child), const SizedBox(width: 16)])
            .take(children.length * 2 - 1)
            .toList(),
      );
    }
  }

  /// Get responsive cross axis count for grid view
  static int getCrossAxisCount(BuildContext context) {
    final width = screenWidth(context);
    if (width < 600) return 1;
    if (width < 900) return 2;
    if (width < 1200) return 3;
    return 4;
  }

  /// Get responsive child aspect ratio for grid items
  static double getChildAspectRatio(BuildContext context) {
    if (isMobile(context)) return 1.2;
    if (isTablet(context)) return 1.3;
    return 1.4;
  }

  /// Safe area padding considering screen size
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.padding;
  }

  /// Get responsive dialog width
  static double getDialogWidth(BuildContext context) {
    final width = screenWidth(context);
    if (isMobile(context)) return width * 0.9;
    if (isTablet(context)) return width * 0.7;
    return 600; // Fixed width for desktop
  }

  /// Get responsive bottom sheet height
  static double getBottomSheetHeight(BuildContext context) {
    final height = screenHeight(context);
    return height * (isMobile(context) ? 0.9 : 0.8);
  }
}
