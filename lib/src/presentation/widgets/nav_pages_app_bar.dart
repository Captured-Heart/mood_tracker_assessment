import 'package:flutter/material.dart';
import 'package:mood_tracker_assessment/constants/extension.dart';
import 'package:mood_tracker_assessment/src/presentation/widgets/texts/texts_widget.dart';

class NavBarPagesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBarPagesAppBar({super.key, required this.title, this.automaticallyImplyLeading = false});
  final String title;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: MoodText.text(context: context, text: title, textStyle: context.textTheme.titleLarge),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
