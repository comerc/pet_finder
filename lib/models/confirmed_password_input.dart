import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';

enum ConfirmedPasswordInputValidationError { invalid }

class ConfirmedPasswordInputModel
    extends FormzInput<String, ConfirmedPasswordInputValidationError> {
  const ConfirmedPasswordInputModel.pure({this.password = ''}) : super.pure('');
  const ConfirmedPasswordInputModel.dirty(
      {@required this.password, String value = ''})
      : super.dirty(value);

  final String password;

  @override
  ConfirmedPasswordInputValidationError validator(String value) {
    return password == value
        ? null
        : ConfirmedPasswordInputValidationError.invalid;
  }
}
