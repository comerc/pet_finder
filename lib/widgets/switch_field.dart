import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchField extends StatefulWidget {
  const SwitchField({
    Key? key,
    required this.label,
    this.initialValue,
  }) : super(key: key);

  final String label;
  final bool? initialValue;

  @override
  State<SwitchField> createState() => SwitchFieldState();
}

class SwitchFieldState extends State<SwitchField> {
  bool _value = false;

  bool get value => _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTile(
        title: Text(widget.label),
        trailing: Platform.isIOS
            ? CupertinoSwitch(
                value: _value,
                onChanged: (bool value) {
                  setState(() {
                    _value = value;
                  });
                },
              )
            : Switch(
                value: _value,
                onChanged: (bool value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
        onTap: () {
          setState(() {
            _value = !_value;
          });
        },
      ),
    );
  }
}
