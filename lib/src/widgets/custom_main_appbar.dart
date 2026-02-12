import 'package:flutter/material.dart';

class CustomMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomMainAppBar(
      {Key? key,
      required this.title,
      this.titleFontSize = 20,
      this.action,
      this.isAutomaticallyImplyLeading,
      this.bgColor,
      this.titleFontWeight = FontWeight.w500,
      this.centerTitle,
      this.alignTitleText,
      this.showAction = true,
      this.location,
      this.titleColor,
      this.leadingWidth,
      this.leading})
      : super(key: key);
  final Widget? title;
  final Widget? location;
  final double? titleFontSize;
  final double? leadingWidth;
  final FontWeight? titleFontWeight;
  final List<Widget>? action;
  final Color? bgColor;
  final bool? isAutomaticallyImplyLeading;
  final Alignment? alignTitleText;
  final bool? centerTitle;
  final Color? titleColor;
  final Widget? leading;
  final bool showAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton.filledTonal(
            color: Colors.purple,
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: const Icon(
              Icons.format_align_center_sharp,
            ),
          ),
        )
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}
