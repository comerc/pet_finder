import 'package:formz/formz.dart';

class WeightInputModel extends FormzInput<String, String> {
  const WeightInputModel.pure() : super.pure('');
  WeightInputModel.dirty(String value) : super.dirty(value.trim());

  @override
  String validator(String value) {
    if (value.isEmpty) {
      return 'Invalid input';
    }
    return null;
  }
}
