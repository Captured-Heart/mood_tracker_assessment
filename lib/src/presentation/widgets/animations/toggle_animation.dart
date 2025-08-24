import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ToggleAnimation extends StatefulWidget {
  final Widget child;

  final void Function()? onTap;

  final Future<void> Function()? onLongStart;
  final Future<void> Function()? onLongEnd;

  final void Function(DragUpdateDetails)? onHorizontalDragUpdate;

  final BorderRadius? borderRadius;
  final VoidCallback? onLongPressed;
  final VoidCallback? onDoubleTap;

  const ToggleAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.onLongStart,
    this.onHorizontalDragUpdate,
    this.onLongEnd,
    this.borderRadius,
    this.onLongPressed,
    this.onDoubleTap,
  });

  @override
  State<ToggleAnimation> createState() => _TapToggleState();
}

class _TapToggleState extends State<ToggleAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    );

    _controller.addListener(() {
      setState(() {});
    });

    if (!mounted) {
      _controller.dispose();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: widget.onHorizontalDragUpdate,
      onTapDown: (v) {
        if (widget.onTap != null) {
          if (!kIsWeb && Platform.isIOS && widget.onLongStart == null) {
            HapticFeedback.selectionClick();
          }
          _controller.forward();
        }
      },
      onTapUp: (v) {
        if (widget.onTap != null) {
          _controller.reverse();
        }
      },
      onPanDown: (v) {
        if (widget.onTap != null) {
          _controller.forward();
        }
      },
      onPanCancel: () {
        if (widget.onTap != null) {
          _controller.reverse();
        }
      },
      onPanEnd: (v) {
        if (widget.onTap != null) {
          _controller.reverse();
        }
      },
      onLongPressStart: (details) async {
        if (widget.onLongStart == null) return;

        HapticFeedback.selectionClick();
        _controller.forward();

        await widget.onLongStart!();
      },
      onLongPressUp: () async {
        if (widget.onLongEnd != null) {
          HapticFeedback.selectionClick();
          _controller.reverse();

          await widget.onLongEnd!();
        }
      },
      onLongPress: widget.onLongPressed ?? () {},
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      child: Transform.scale(
        scale: 1 - _controller.value,
        child: DecoratedBox(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: widget.child,
        ),
      ),
    );
  }
}
