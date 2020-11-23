import 'package:formz/formz.dart';

enum PasswordInputValidationError { invalid }

class PasswordInputModel
    extends FormzInput<String, PasswordInputValidationError> {
  const PasswordInputModel.pure() : super.pure('');
  const PasswordInputModel.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordInputValidationError validator(String value) {
    return _passwordRegExp.hasMatch(value)
        ? null
        : PasswordInputValidationError.invalid;
  }
}
