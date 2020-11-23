import 'package:formz/formz.dart';

enum EmailInputValidationError { invalid }

class EmailInputModel extends FormzInput<String, EmailInputValidationError> {
  const EmailInputModel.pure() : super.pure('');
  const EmailInputModel.dirty([String value = '']) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailInputValidationError validator(String value) {
    return _emailRegExp.hasMatch(value)
        ? null
        : EmailInputValidationError.invalid;
  }
}
