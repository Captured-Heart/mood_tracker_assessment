// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mood_tracker_assessment/constants/app_colors.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/constants/spacings.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class MoodTextfield extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final double? hintHeight;

  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final List<String> autofillHints;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final dynamic Function(String)? onFieldSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? suffix, labelSuffix;

  final String? phonePrefix;

  final String? initialValue;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final bool readOnly;
  final bool obscureText;
  final bool enableSuggestions;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final bool? enabled;
  final bool autocorrect;
  final EdgeInsets? contentPadding;
  final bool filled, isDense;
  final Color? fillColor, cursorColor;
  final BorderRadius? borderRadius;
  final bool isUnderlineTextField, labelIconIsLeft;
  final TextStyle? labeltextStyle;

  final InputBorder? enabledBorder, focusedBorder, focusedErrorBorder, errorBorder, disabledBorder;

  const MoodTextfield({
    super.key,
    this.labelText,
    this.hintText,
    this.hintHeight,
    this.keyboardType,
    this.focusNode,
    this.autofillHints = const [],
    this.controller,
    this.inputFormatters,
    this.validator,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.suffix,
    this.labelSuffix,
    this.initialValue,
    this.textInputAction,
    this.style,
    this.readOnly = false,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.enabled,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.isDense = false,
    this.contentPadding = const EdgeInsets.only(
      left: AppSpacings.elementSpacing * 1.5,
      right: AppSpacings.elementSpacing * 1.5,
      bottom: AppSpacings.elementSpacing * 1.5,
      top: AppSpacings.elementSpacing * 1.2,
    ),
    this.phonePrefix,
    this.filled = false,
    this.fillColor,
    this.borderRadius,
    this.cursorColor,
    this.enabledBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.errorBorder,
    this.disabledBorder,
    this.isUnderlineTextField = false,
    this.labeltextStyle,
    this.labelIconIsLeft = false,
  });

  @override
  State<MoodTextfield> createState() => _MoodTextfieldState();
}

class _MoodTextfieldState extends State<MoodTextfield> {
  late FocusNode keyboardFocusNode;

  @override
  void initState() {
    super.initState();

    keyboardFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Row(
            mainAxisAlignment: widget.labelIconIsLeft ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: MoodText.text(
                  text: widget.labelText!,
                  context: context,
                  textScaleFactor: widget.labeltextStyle != null ? 0.7 : 1,
                  textStyle: widget.labeltextStyle,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacings.elementSpacing * 0.5),
              if (widget.labelSuffix != null) widget.labelSuffix!,
            ],
          ),
        ],
        KeyboardListener(
          focusNode: keyboardFocusNode,
          onKeyEvent: (key) {
            if (key.logicalKey.keyLabel == "Tab") {
              FocusScope.of(context).nextFocus();
            } else if (key.logicalKey.keyLabel == "Escape") {
              FocusScope.of(context).unfocus();
            }
          },
          child: TextFormField(
            keyboardType: widget.keyboardType,
            initialValue: widget.initialValue,
            focusNode: widget.focusNode,
            autofillHints: widget.autofillHints,
            controller: widget.controller,
            inputFormatters: widget.inputFormatters ?? [FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))],
            style: widget.style ?? context.textTheme.bodyLarge,
            autocorrect: widget.autocorrect,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            textCapitalization: widget.textCapitalization,
            validator: widget.validator,
            obscureText: widget.obscureText,
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            onTap: widget.onTap,
            enableSuggestions: widget.enableSuggestions,
            cursorColor: widget.cursorColor ?? AppColors.kWhiteFade,
            textAlignVertical: TextAlignVertical.bottom,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              isDense: widget.isDense,
              hintText: widget.hintText,
              errorStyle: context.theme.textTheme.bodySmall?.copyWith(
                fontSize: AppSpacings.k8 * 1.2,
                color: AppColors.moodRed,
              ),
              hintStyle: context.theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                // fontFamily: AppFonts.raleway,
                color: const Color(0xff7D7E8B),
                fontVariations: [const FontVariation.weight(400)],
                height: widget.hintHeight,
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              suffix: widget.suffix,
              contentPadding: widget.contentPadding,
              enabledBorder:
                  widget.isUnderlineTextField
                      ? AppSpacings.underlineEnabledBorder
                      : widget.enabledBorder ??
                          AppSpacings.disabledOutLineBorder.copyWith(borderRadius: widget.borderRadius),
              focusedBorder:
                  widget.isUnderlineTextField
                      ? AppSpacings.underlineEnabledBorder
                      : widget.focusedBorder ?? AppSpacings.outLineBorder.copyWith(borderRadius: widget.borderRadius),
              focusedErrorBorder:
                  widget.isUnderlineTextField
                      ? AppSpacings.underlineErrorFocusedBorder
                      : widget.focusedErrorBorder ??
                          AppSpacings.errorFocusedBorder.copyWith(borderRadius: widget.borderRadius),
              errorBorder:
                  widget.isUnderlineTextField
                      ? AppSpacings.errorBorder
                      : widget.errorBorder ?? AppSpacings.errorBorder.copyWith(borderRadius: widget.borderRadius),
              disabledBorder:
                  widget.isUnderlineTextField
                      ? AppSpacings.disabledUnderlineBorder
                      : widget.disabledBorder ??
                          AppSpacings.disabledOutLineBorder.copyWith(borderRadius: widget.borderRadius),
              filled: widget.filled,
              fillColor: widget.fillColor ?? context.theme.highlightColor.withOpacity(0.15),
            ),
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onFieldSubmitted,
          ),
        ),
      ],
    );
  }
}
