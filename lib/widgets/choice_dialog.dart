import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_finder/imports.dart';

Future<T?> showChoiceDialog<T>({
  required BuildContext context,
  required List<T> values,
  String title = '',
  String close = 'Close',
}) async {
  return Platform.isIOS
      ? await showCupertinoDialog(
          barrierDismissible: true,
          context: context,
          builder: _buildCupertinoDialog(title, values, close),
        )
      : await showDialog(
          context: context,
          builder: _buildDialog(title, values, close),
        );
}

WidgetBuilder _buildCupertinoDialog(
    String title, List<dynamic> values, String close) {
  return (BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      actions: [
        ...values.map((value) {
          return CupertinoDialogAction(
            onPressed: () {
              navigator.pop(value);
            },
            child: Text(value.toString()),
          );
        }),
        CupertinoDialogAction(
          onPressed: () {
            navigator.pop();
          },
          child: Text(close),
          isDestructiveAction: true,
        )
      ],
    );
  };
}

WidgetBuilder _buildDialog(String title, List<dynamic> values, String close) {
  return (BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(values.length, (int index) {
          final value = values[index];
          return Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                navigator.pop(value);
              },
              child: ListTile(
                title: Text(value.toString()),
              ),
            ),
          );
        }),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            navigator.pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  };
}
