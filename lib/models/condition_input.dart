import 'package:formz/formz.dart';
import 'package:pet_finder/models/unit.dart';

class ConditionInputModel extends FormzInput<ConditionValue, String> {
  const ConditionInputModel.pure() : super.pure(ConditionValue.none);
  ConditionInputModel.dirty(ConditionValue value) : super.dirty(value);

  @override
  String validator(ConditionValue value) {
    if (value == ConditionValue.none) {
      return 'Invalid input';
    }
    return null;
  }
}
