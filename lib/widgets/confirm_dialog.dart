import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_finder/imports.dart';

Future<bool> showConfirmDialog({
  required BuildContext context,
  String title = '',
  String content = '',
  String ok = 'OK',
  String cancel = 'Cancel',
}) async {
  final result = Platform.isIOS
      ? await showCupertinoDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                CupertinoDialogAction(
                  onPressed: () {
                    navigator.pop(true);
                  },
                  child: Text(ok),
                  isDefaultAction: true,
                  isDestructiveAction: true,
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    navigator.pop(false);
                  },
                  child: Text(cancel),
                  isDefaultAction: false,
                  isDestructiveAction: false,
                )
              ],
            );
          },
        )
      : await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: () {
                    navigator.pop(true);
                  },
                  child: Text(ok),
                ),
                TextButton(
                  onPressed: () {
                    navigator.pop(false);
                  },
                  child: Text(cancel),
                ),
              ],
            );
          },
        );
  return result ?? false;
}
