import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/core/app/colors.dart';

class AppTheme {
  //
  AppTheme._();

  static ThemeData lightTheme({Color? color}) => ThemeData(
        useMaterial3: true,
        fontFamily: "Quicksand",
        primaryColor: color ?? AppColor.kPrimaryMain,
        colorScheme: ColorScheme.fromSeed(
            seedColor: color ?? AppColor.kPrimaryMain,
            outlineVariant: AppColor.kNeutral400),
        scaffoldBackgroundColor: Colors.white,
        dividerColor: AppColor.kNeutral100,
        dividerTheme: DividerThemeData(
          color: AppColor.kNeutral100,
        ),
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(backgroundColor: Colors.white),
        unselectedWidgetColor: Colors.black,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
        ),
        navigationBarTheme: const NavigationBarThemeData(),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
      );

  // static ThemeData darkTheme({Color? color}) => ThemeData(
  //       useMaterial3: true,
  //       primaryColor: color ?? primaryColor,
  //       colorScheme: ColorScheme.fromSeed(
  //           seedColor: color ?? primaryColor, outlineVariant: borderColor),
  //       appBarTheme: const AppBarTheme(
  //         systemOverlayStyle:
  //             SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
  //       ),
  //       scaffoldBackgroundColor: scaffoldColorDark,
  //       bottomNavigationBarTheme: const BottomNavigationBarThemeData(
  //           backgroundColor: scaffoldSecondaryDark),
  //       iconTheme: const IconThemeData(color: Colors.white),
  //       dialogBackgroundColor: scaffoldSecondaryDark,
  //       unselectedWidgetColor: Colors.white60,
  //       bottomSheetTheme: const BottomSheetThemeData(
  //         backgroundColor: scaffoldSecondaryDark,
  //       ),
  //       floatingActionButtonTheme: FloatingActionButtonThemeData(
  //           backgroundColor: color ?? primaryColor),
  //       cardColor: scaffoldSecondaryDark,
  //       navigationBarTheme: const NavigationBarThemeData(),
  //     ).copyWith(
  //       pageTransitionsTheme: const PageTransitionsTheme(
  //         builders: <TargetPlatform, PageTransitionsBuilder>{
  //           TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
  //           TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
  //           TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  //         },
  //       ),
  //     );
}
