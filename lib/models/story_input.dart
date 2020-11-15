import 'package:formz/formz.dart';

class StoryInputModel extends FormzInput<String, String> {
  const StoryInputModel.pure() : super.pure('');
  StoryInputModel.dirty(String value) : super.dirty(value.trim());

  @override
  String validator(String value) {
    if (value.isEmpty) {
      return 'Invalid input';
    }
    return null;
  }
}
