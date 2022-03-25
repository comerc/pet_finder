import 'package:flutter/material.dart';
// import 'package:pet_finder/imports.dart';

class DropdownField<T> extends StatefulWidget {
  const DropdownField({
    Key? key,
    required this.hintText,
    required this.values,
    this.initialValue,
    required this.getValueTitle,
    required this.empty,
  }) : super(key: key);

  final String hintText;
  final List<T> values;
  final T? initialValue;
  final String Function(T value) getValueTitle;
  final String empty;

  @override
  State<DropdownField<T>> createState() => DropdownFieldState<T>();
}

class DropdownFieldState<T> extends State<DropdownField<T>> {
  T? _value;
  T? get value => _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        hintText: widget.hintText,
      ),
      value: _value,
      items: List.generate(widget.values.length, (int index) {
        final value = widget.values[index];
        return DropdownMenuItem(
          value: value,
          child: Text(widget.getValueTitle(value)),
        );
      }),
      onChanged: (T? value) {
        setState(() {
          _value = value;
        });
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (T? value) => (value == null) ? widget.empty : null,
    );
  }
}
