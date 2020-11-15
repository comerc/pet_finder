import 'package:formz/formz.dart';

class AddressInputModel extends FormzInput<String, String> {
  const AddressInputModel.pure() : super.pure('');
  AddressInputModel.dirty(String value) : super.dirty(value.trim());

  @override
  String validator(String value) {
    if (value.isEmpty) {
      return 'Invalid input';
    }
    return null;
  }
}
