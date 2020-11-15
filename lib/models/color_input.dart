import 'package:formz/formz.dart';
import 'package:characters/characters.dart';

class ColorInputModel extends FormzInput<String, String> {
  const ColorInputModel.pure() : super.pure('');
  ColorInputModel.dirty(String value) : super.dirty(value.trim());

  @override
  String validator(String value) {
    if (value.isEmpty) {
      return 'Invalid input';
    }
    return null;
  }
}
