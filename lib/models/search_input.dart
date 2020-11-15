import 'package:formz/formz.dart';
import 'package:characters/characters.dart';

class SearchInputModel extends FormzInput<String, String> {
  const SearchInputModel.pure() : super.pure('');
  SearchInputModel.dirty(String value) : super.dirty(value.trim());

  @override
  String validator(String value) {
    if (value.characters.length < 4) {
      return 'Invalid input < 4 characters';
    }
    return null;
  }
}
