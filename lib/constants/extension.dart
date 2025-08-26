import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/text_constants.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/animations/toggle_animation.dart';

extension ThemeExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Size get size => MediaQuery.sizeOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);
  double get totlaDeviceHeight => size.height;
  double deviceHeight(double h) => size.height * h;
  double deviceWidth(double w) => size.width * w;

  // show scnackBar
  void showSnackBar({required String message, bool isError = false, bool showAboveBottomSheet = false}) {
    final BuildContext scaffoldContext = showAboveBottomSheet ? Navigator.of(this, rootNavigator: true).context : this;
    // Remove any current SnackBar before showing a new one
    ScaffoldMessenger.of(scaffoldContext).removeCurrentSnackBar();
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.none,
        backgroundColor: isError ? AppColors.moodRed : AppColors.kGreen,
        content: Text(
          message,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400),
        ),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }
}

extension DebugBorderWidgetExtension on Widget {
  Widget debugBorder({Color? color}) {
    if (kDebugMode) {
      return DecoratedBox(
        decoration: BoxDecoration(border: Border.all(color: color ?? Colors.red, width: 4)),
        child: this,
      );
    } else {
      return this;
    }
  }
}

//! ------------- STRING EXTENSIONS ---------------
extension TimeOfDayStringExtension on String {
  String getTimeOfDay() {
    final now = DateTime.parse(this);
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return TextConstants.goodMorning.tr();
    } else if (hour >= 12 && hour < 17) {
      return TextConstants.goodAfternoon.tr();
    } else if (hour >= 17 && hour < 21) {
      return TextConstants.goodEvening.tr();
    } else {
      return TextConstants.goodNight.tr();
    }
  }

  String get formatToTimeString => DateFormat('h:mm a').format(DateTime.tryParse(this) ?? DateTime.now());
  String get formatToDateNumberString => DateFormat('d').format(DateTime.tryParse(this) ?? DateTime.now());
  String get formatToWeekdayString => DateFormat('E').format(DateTime.tryParse(this) ?? DateTime.now());

  bool get isToday {
    final now = DateTime.now();
    final date = DateTime.tryParse(this);
    return date != null && date.year == now.year && date.month == now.month && date.day == now.day;
  }
}

//! ------------- GESTURE EXTENSIONS -------------
extension GestureExtension on Widget {
  Widget onTap({
    required VoidCallback? onTap,
    required String tooltip,
    VoidCallback? onDoubleTap,
    VoidCallback? onLongPress,
  }) {
    return ToggleAnimation(
      onTap: onTap,
      onLongPressed: onLongPress,
      onDoubleTap: onDoubleTap,
      child: Tooltip(message: tooltip, child: this),
    );
  }

  Widget onTapWithoutAnimation({required VoidCallback? onTap, required String tooltip}) {
    return GestureDetector(onTap: onTap, child: Tooltip(message: tooltip, child: this));
  }
}

//!  -------------- PADDING EXTENSIONS --------------
extension PaddingExtension on Widget {
  Widget padAll(double padding) {
    return Padding(padding: EdgeInsets.all(padding), child: this);
  }

  Widget padSymmetric({double horizontal = 0.0, double vertical = 0.0}) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical), child: this);
  }

  Widget padOnly({double left = 0.0, double top = 0.0, double right = 0.0, double bottom = 0.0}) {
    return Padding(padding: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom), child: this);
  }
}

//! -------------------- ALIGNMENT EXTENSIONS -----------------
extension AlignmentExtension on Widget {
  Widget alignCenterLeft({double? widthFactor, double? heightFactor}) {
    return Align(alignment: Alignment.centerLeft, widthFactor: widthFactor, heightFactor: heightFactor);
  }

  Widget alignCenterRight({double? widthFactor, double? heightFactor}) {
    return Align(alignment: Alignment.centerRight, widthFactor: widthFactor, heightFactor: heightFactor);
  }

  Widget alignTopLeft({double? widthFactor, double? heightFactor}) {
    return Align(alignment: Alignment.topLeft, widthFactor: widthFactor, heightFactor: heightFactor);
  }

  Widget alignTopRight({double? widthFactor, double? heightFactor}) {
    return Align(alignment: Alignment.topRight, widthFactor: widthFactor, heightFactor: heightFactor);
  }

  Widget alignBottomLeft({double? widthFactor, double? heightFactor}) {
    return Align(alignment: Alignment.bottomLeft, widthFactor: widthFactor, heightFactor: heightFactor);
  }

  Widget alignBottomRight({double? widthFactor, double? heightFactor}) {
    return Align(alignment: Alignment.bottomRight, widthFactor: widthFactor, heightFactor: heightFactor);
  }
}

//! -------------------- NULLABLE EXTENSIONS -----------------
extension StringExtensionOnNull on String? {
  String makeStringEmptyIfNull() => isNotEmptyOrNull ? this! : '';
}

extension StringNullableExtension on String? {
  bool get isEmptyOrNull => this == null || this?.isEmpty == true;
  bool get isNotEmptyOrNull => this != null && !isEmptyOrNull;
}

extension BoolNullableExtension on bool? {
  bool get isNotNullAndFalse => this != null && this == false;
  bool get isNotNullAndTrue => this != null && this == true;
}

extension ListIsNullExtension on List<dynamic>? {
  bool get isNullOrEmpty => this == null || this?.isEmpty == true;
  bool get isNotEmptyOrNull => this != null && !isNullOrEmpty;
}

//! -------------------- ANIMATE EXTENSIONS -----------------

extension WidgetAnimation on Widget {
  Animate fadeInFromTop({Duration? delay, Duration? animationDuration, Offset? offset}) =>
      animate(delay: delay ?? 300.ms)
          .move(duration: animationDuration ?? 300.ms, begin: offset ?? const Offset(0, -10))
          .fade(duration: animationDuration ?? 300.ms);

  Animate fadeInFromBottom({Duration? delay, Duration? animationDuration, Offset? offset}) =>
      animate(delay: delay ?? 300.ms)
          .move(duration: animationDuration ?? 300.ms, begin: offset ?? const Offset(0, 10))
          .fade(duration: animationDuration ?? 300.ms);

  // write fadeInFromRight

  Animate fadeInFromLeft({Duration? delay, Duration? animationDuration, Offset? offset}) =>
      animate(delay: delay ?? 300.ms)
          .move(duration: animationDuration ?? 300.ms, begin: offset ?? const Offset(-10, 0))
          .fade(duration: animationDuration ?? 300.ms);

  Animate fadeInFromRight({Duration? delay, Duration? animationDuration, Offset? offset}) =>
      animate(delay: delay ?? 300.ms)
          .move(duration: animationDuration ?? 300.ms, begin: offset ?? const Offset(10, 0))
          .fade(duration: animationDuration ?? 300.ms);

  Animate fadeIn({Duration? delay, Duration? animationDuration, Curve? curve}) =>
      animate(delay: delay ?? 300.ms).fade(duration: animationDuration ?? 300.ms, curve: curve ?? Curves.decelerate);

  Animate scale({Duration? delay, Duration? animationDuration, Curve? curve, bool? autoPlay = true}) => animate(
    delay: delay ?? 100.ms,
    autoPlay: autoPlay,
  ).scale(duration: animationDuration ?? 300.ms, curve: curve ?? Curves.easeOut);

  Animate scaleFromLeft({Duration? delay, Duration? animationDuration, Curve? curve}) =>
      animate(delay: delay ?? 300.ms).scale(
        duration: animationDuration ?? 3100.ms,
        curve: curve ?? Curves.easeOut,
        begin: const Offset(0, -20),
        // end: const Offset(0, 0),
        // alignment: Alignment.bottomLeft,
      );

  Animate slideInFromBottom({Duration? delay, Duration? animationDuration, Curve? curve, double? begin}) => animate(
    delay: delay ?? 300.ms,
  ).slideY(duration: animationDuration ?? 300.ms, begin: begin ?? 0.2, end: 0, curve: curve ?? Curves.linear);

  Animate shakeExtension({Duration? delay, Duration? animationDuration, Curve? curve}) =>
      animate(delay: delay ?? 300.ms, autoPlay: true).shake(
        duration: animationDuration ?? 1200.ms,
        curve: curve ?? Curves.easeOut,
        // end: const Offset(0, 0),
        // alignment: Alignment.bottomLeft,
      );
  Animate scaleUpDown({Duration? delay, Duration? animationDuration, Curve? curve, double? endScaleEnd}) =>
      animate(delay: delay ?? 300.ms, autoPlay: true)
          .scaleXY(begin: 0.6, end: 1.0, duration: animationDuration ?? 800.ms, curve: curve ?? Curves.easeInOut)
          .then()
          .scaleXY(begin: 1.2, end: endScaleEnd ?? 0.8, duration: animationDuration ?? 800.ms, curve: Curves.easeInOut);
}

// !------------- NAVIGATION EXTENSIONS -------------
extension NavigationExtension on BuildContext {
  Future<T?> push<T>(Widget page) {
    return Navigator.push<T>(this, MaterialPageRoute(builder: (_) => page));
  }

  // pushNamed
  Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(this, routeName, arguments: arguments);
  }

  Future<T?> pushReplacement<T, TO>(Widget page) {
    return Navigator.pushReplacement<T, TO>(this, MaterialPageRoute(builder: (_) => page));
  }

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(this, routeName, arguments: arguments, result: result);
  }

  void pop<T extends Object?>([T? result]) {
    return Navigator.pop<T>(this, result);
  }

  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return Navigator.pushAndRemoveUntil<T>(this, MaterialPageRoute(builder: (_) => page), (route) => false);
  }

  //popAllAndPushNamed
  Future<T?> popAllAndPushNamed<T extends Object?>(String routeName, {Object? arguments}) {
    return Navigator.pushNamedAndRemoveUntil<T>(this, routeName, (route) => false, arguments: arguments);
  }
}
