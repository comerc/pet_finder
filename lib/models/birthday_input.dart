import 'package:formz/formz.dart';

class BirthdayInputModel extends FormzInput<String, String> {
  const BirthdayInputModel.pure() : super.pure('');
  BirthdayInputModel.dirty(String value) : super.dirty(value);

  @override
  String validator(String value) {
    if (value.isEmpty) {
      return 'Invalid input';
    }
    return null;
  }
}
