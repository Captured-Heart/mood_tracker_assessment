import 'package:flutter/material.dart';
import 'package:mood_tracker_assessment/constants/button_state.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/spacings.dart';

import 'package:mood_tracker_assessment/constants/typedefs.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/animations/toggle_animation.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class MoodOutlineButton extends StatefulWidget {
  final String title;
  final OnPressedButton onPressed;
  final bool dotted;
  final BorderRadius? borderRadius;
  final TextStyle? titleStyle;
  final Widget? trailing;
  final bool centerText;
  final ButtonState state;
  final double height;
  final double? width;

  final Widget? icon;
  final Color? color, bgColor;
  final Color? textColor;
  final double? strokeWidth;
  final OutlinedBorder? shape;

  const MoodOutlineButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.dotted = false,
    this.borderRadius,
    this.titleStyle,
    this.state = ButtonState.initial,
    this.height = 50,
    this.width,
    this.icon,
    this.color,
    this.bgColor,
    this.textColor,
    this.strokeWidth,
    this.centerText = true,
    this.trailing,
    this.shape,
  });

  @override
  State<MoodOutlineButton> createState() => _MoodOutlineButtonButtonState();
}

class _MoodOutlineButtonButtonState extends State<MoodOutlineButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final bool disable = [ButtonState.disabled, ButtonState.loading].contains(widget.state);
    final bool isLoading = [ButtonState.loading].contains(widget.state);

    return ToggleAnimation(
      onTap: disable ? null : widget.onPressed,
      borderRadius: widget.borderRadius ?? AppSpacings.defaultBorderRadius,
      child: SizedBox(
        width: widget.width ?? context.deviceWidth(0.9),
        height: widget.height,
        child: OutlinedButton(
          onPressed: widget.onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: widget.bgColor,
            foregroundColor: widget.color ?? context.colorScheme.primary,
            side: widget.shape != null ? null : BorderSide(color: widget.textColor ?? context.colorScheme.primary),
            shape: widget.shape,
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
          child: Center(
            child:
                isLoading
                    ? Transform.scale(
                      scale: 0.8,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(widget.textColor ?? context.colorScheme.primary),
                      ),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          IconTheme(data: context.theme.iconTheme, child: widget.icon!),
                          const SizedBox(width: AppSpacings.k4),
                        ],
                        Flexible(
                          child: MoodText.text(
                            context: context,
                            textStyle: widget.titleStyle,
                            text: widget.title,
                            isCenter: widget.centerText,
                            color: widget.textColor ?? context.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.trailing != null) ...[
                          const SizedBox(width: AppSpacings.k4),
                          IconTheme(data: context.theme.iconTheme.copyWith(), child: widget.trailing!),
                        ],
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
