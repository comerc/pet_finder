import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormSwitch extends StatefulWidget {
  const FormSwitch({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  State<FormSwitch> createState() => FormSwitchState();
}

class FormSwitchState extends State<FormSwitch> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTile(
        title: Text(widget.label),
        trailing: Platform.isIOS
            ? CupertinoSwitch(
                value: value,
                onChanged: (bool value) {
                  setState(() {
                    this.value = value;
                  });
                },
              )
            : Switch(
                value: value,
                onChanged: (bool value) {
                  setState(() {
                    this.value = value;
                  });
                },
              ),
        onTap: () {
          setState(() {
            value = !value;
          });
        },
      ),
    );
  }
}
