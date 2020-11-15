import 'package:formz/formz.dart';

class BreedInputModel extends FormzInput<String, String> {
  const BreedInputModel.pure() : super.pure('');
  BreedInputModel.dirty(String value) : super.dirty(value);

  @override
  String validator(String value) {
    if (value.isEmpty) {
      return 'Invalid input';
    }
    return null;
  }
}
