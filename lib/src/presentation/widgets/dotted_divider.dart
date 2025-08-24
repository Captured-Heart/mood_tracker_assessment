import 'package:flutter/material.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';

class DottedLineDividerWidget extends StatelessWidget {
  const DottedLineDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: DottedLinePainter(context: context, strokeWidthDouble: 0.4, dashLength: context.deviceWidth(0.01)));
  }
}

class DottedLinePainter extends CustomPainter {
  final BuildContext context;
  final double? dashSpacing;
  final double? dashLength;
  final double? strokeWidthDouble;

  DottedLinePainter({required this.context, this.dashSpacing, this.dashLength, this.strokeWidthDouble});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = context.colorScheme.onSurface.withOpacity(0.7)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidthDouble ?? 1.0;

    double dashWidth = dashLength ?? 5.0;
    double dashSpace = dashSpacing ?? 8.0;

    double currentX = 0.0;

    while (currentX < size.width) {
      canvas.drawLine(Offset(currentX, 0.0), Offset(currentX + dashWidth, 0.0), paint);
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DottedBorderPainter extends CustomPainter {
  final BuildContext context;
  final Color? color;

  DottedBorderPainter(this.context, {this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color ?? context.theme.primaryColor
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    // Define the spacing between the dots
    const double dashWidth = 5.0;
    const double dashSpace = 5.0;

    // Calculate the number of dots in each dimension
    final double dotsInWidth = size.width / (dashWidth + dashSpace);
    final double dotsInHeight = size.height / (dashWidth + dashSpace);

    // Draw horizontal dashed line at the top
    for (int i = 0; i < dotsInWidth; i++) {
      final double xPos = i * (dashWidth + dashSpace);
      canvas.drawLine(Offset(xPos, 0), Offset(xPos + dashWidth, 0), paint);
    }

    // Draw horizontal dashed line at the bottom
    for (int i = 0; i < dotsInWidth; i++) {
      final double xPos = i * (dashWidth + dashSpace);
      canvas.drawLine(Offset(xPos, size.height), Offset(xPos + dashWidth, size.height), paint);
    }

    // Draw vertical dashed line at the left
    for (int i = 0; i < dotsInHeight; i++) {
      final double yPos = i * (dashWidth + dashSpace);
      canvas.drawLine(Offset(0, yPos), Offset(0, yPos + dashWidth), paint);
    }

    // Draw vertical dashed line at the right
    for (int i = 0; i < dotsInHeight; i++) {
      final double yPos = i * (dashWidth + dashSpace);
      canvas.drawLine(Offset(size.width, yPos), Offset(size.width, yPos + dashWidth), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
