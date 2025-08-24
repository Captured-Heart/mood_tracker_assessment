import 'package:flutter/material.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/button_state.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/spacings.dart';
import 'package:mood_tracker_assessment/constants/typedefs.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/animations/toggle_animation.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class MoodPrimaryButton extends StatefulWidget {
  final String title;
  final OnPressedButton onPressed;
  final OnPressedButton? onDisabledPressed;
  final ButtonState state;
  final BorderRadius? borderRadius;
  final double height, textScaleFactor;
  final double? width;
  final Widget? icon;
  final Widget? trailing;
  final bool centerText;

  final Color? bGcolor;
  final Color? textColor;
  final bool isTitleShrinked;
  final TextStyle? textStyle;
  final EdgeInsets? padding;

  const MoodPrimaryButton({
    super.key,
    required this.onPressed,
    this.state = ButtonState.initial,
    this.height = 50,
    this.width,
    this.textScaleFactor = 1.0,
    required this.title,
    this.icon,
    this.bGcolor,
    this.textColor = AppColors.kWhite,
    this.borderRadius,
    this.onDisabledPressed,
    this.trailing,
    this.centerText = false,
    this.isTitleShrinked = false,
    this.textStyle,
    this.padding,
  });

  @override
  State<MoodPrimaryButton> createState() => _MoodPrimaryButtonState();
}

class _MoodPrimaryButtonState extends State<MoodPrimaryButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final bool disable = [ButtonState.disabled, ButtonState.loading].contains(widget.state);
    final bool isLoading = [ButtonState.loading].contains(widget.state);

    return ToggleAnimation(
      onTap:
          // onTapBTN,
          isLoading ? null : (disable && !isLoading ? widget.onDisabledPressed : widget.onPressed),
      borderRadius: widget.borderRadius ?? AppSpacings.defaultBorderRadius,

      child: SizedBox(
        width: widget.width,
        // ?? context.deviceWidth(0.9),
        height: widget.height,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: disable ? AppColors.kWhiteFade : widget.bGcolor,
            elevation: 0,
            padding: widget.padding,
            shape: RoundedRectangleBorder(borderRadius: widget.borderRadius ?? AppSpacings.defaultBorderRadius),
          ),
          onPressed: isLoading ? null : (disable && !isLoading ? widget.onDisabledPressed : widget.onPressed),
          child: Center(
            child:
                isLoading
                    ? Transform.scale(
                      scale: 0.8,
                      child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.kWhite)),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          IconTheme(data: context.theme.iconTheme, child: widget.icon!),
                          const SizedBox(width: AppSpacings.elementSpacing * 0.5),
                        ],
                        Flexible(
                          child: MoodText.text(
                            context: context,
                            text: widget.title,
                            isCenter: widget.centerText,
                            maxLines: 1,
                            textScaleFactor: widget.textScaleFactor,
                            overflow: TextOverflow.ellipsis,
                            color: widget.textColor ?? AppColors.kWhite,
                            textStyle: widget.textStyle,
                          ),
                        ),
                        if (widget.trailing != null) ...[
                          const SizedBox(width: AppSpacings.elementSpacing),
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
