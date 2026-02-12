import 'package:flutter/material.dart';

class CustomTabbar extends StatelessWidget {
  const CustomTabbar({Key? key, required this.tabs, this.onTap})
      : super(key: key);

  final List<Tab> tabs;
  final Function(int val)? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        onTap: onTap != null ? (index) => onTap!(index) : null,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.black,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w400,
        ),
        tabs: tabs,
      ),
    );
  }
}
