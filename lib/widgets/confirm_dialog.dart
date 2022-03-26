import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_finder/import.dart';

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
          builder: _buildCupertinoDialog(title, content, ok, cancel),
        )
      : await showDialog(
          context: context,
          builder: _buildDialog(title, content, ok, cancel),
        );
  return result ?? false;
}

WidgetBuilder _buildDialog(
    String title, String content, String ok, String cancel) {
  return (BuildContext context) {
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
  };
}

WidgetBuilder _buildCupertinoDialog(
    String title, String content, String ok, String cancel) {
  return (BuildContext context) {
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
  };
}
