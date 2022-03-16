import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';

ThemeData getTheme() {
  return ThemeData(
    // primarySwatch: Colors.blue,
    textTheme: TextTheme(
      bodyText1: TextStyle(),
      bodyText2: TextStyle(),
      caption: TextStyle(),
      headline1: TextStyle(),
      headline2: TextStyle(),
      headline3: TextStyle(),
      subtitle1: TextStyle(),
    ),
    appBarTheme: AppBarTheme(
        // actionsIconTheme: IconThemeData(size: 56.0, color: Colors.red),
        // backgroundColor: Colors.white,
        // titleTextStyle: TextStyle(
        //   color: Color(0xff333333),
        // ),
        // iconTheme: IconThemeData(
        //   color: Color(0xff00a468),
        // ),
        ),
    inputDecorationTheme: InputDecorationTheme(
        // prefixIconColor: const Color(0xff999999),
        // suffixIconColor: const Color(0xff00a468),
        // fillColor: const Color(0xfff2f2f2),
        // filled: true,
        // contentPadding: const EdgeInsets.only(bottom: 24.0),
        // border: OutlineInputBorder(
        //   borderSide: BorderSide.none,
        //   borderRadius: BorderRadius.circular(2.0),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide.none,
        //   borderRadius: BorderRadius.circular(2.0),
        // ),
        // hintStyle: const TextStyle(
        //   fontFamily: "PTRootUI",
        //   fontWeight: FontWeight.w400,
        //   fontSize: 16.0,
        //   color: Color(0xff999999),
        // ),
        ),
    textButtonTheme: TextButtonThemeData(
        // style: TextButton.styleFrom(
        //   textStyle: const TextStyle(
        //     fontFamily: "PTRootUI",
        //     fontWeight: FontWeight.w400,
        //     fontSize: 13.0,
        //     decoration: TextDecoration.underline,
        //   ),
        // ),
        ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        // style: ElevatedButton.styleFrom(
        //   minimumSize: const Size(0.0, 48.0),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(4.0),
        //   ),
        //   primary: const Color(0xff00a468),
        //   textStyle: const TextStyle(
        //     fontFamily: "PTRootUI",
        //     fontWeight: FontWeight.w500,
        //     fontSize: 16.0,
        //     color: Color(0xff333333),
        //   ),
        //   elevation: 0.0,
        // ),
        ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        // style: OutlinedButton.styleFrom(
        //   side: const BorderSide(
        //     color: Color(0xff00a468),
        //   ),
        //   minimumSize: const Size(0.0, 48.0),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(4.0),
        //   ),
        //   primary: const Color(0xff00a468),
        //   textStyle: const TextStyle(
        //     fontFamily: "PTRootUI",
        //     fontWeight: FontWeight.w500,
        //     fontSize: 16.0,
        //   ),
        // ),
        ),
  );
}

CupertinoThemeData getCupertinoTheme() {
  return CupertinoThemeData(
    primaryColor: Colors.blue,
  );
}
