import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

part 'add_unit.g.dart';

class AddUnitCubit extends Cubit<AddUnitState> {
  AddUnitCubit(this.repository)
      : assert(repository != null),
        super(AddUnitState());

  final DatabaseRepository repository;

  void doBreedChanged(String value) {
    final breedInput = BreedInputModel.dirty(value);
    emit(state.copyWith(
      breedInput: breedInput,
      status: Formz.validate([
        breedInput,
        state.colorInput,
        state.weightInput,
        state.storyInput,
        state.conditionInput,
        state.birthdayInput,
        state.addressInput,
      ]),
    ));
  }

  void doColorChanged(String value) {
    final colorInput = ColorInputModel.dirty(value);
    emit(state.copyWith(
      colorInput: colorInput,
      status: Formz.validate([
        state.breedInput,
        colorInput,
        state.weightInput,
        state.storyInput,
        state.conditionInput,
        state.birthdayInput,
        state.addressInput,
      ]),
    ));
  }

  void doWeightChanged(String value) {
    final weightInput = WeightInputModel.dirty(value);
    emit(state.copyWith(
      weightInput: weightInput,
      status: Formz.validate([
        state.breedInput,
        state.colorInput,
        weightInput,
        state.storyInput,
        state.conditionInput,
        state.birthdayInput,
        state.addressInput,
      ]),
    ));
  }

  void doStoryChanged(String value) {
    final storyInput = StoryInputModel.dirty(value);
    emit(state.copyWith(
      storyInput: storyInput,
      status: Formz.validate([
        state.breedInput,
        state.colorInput,
        state.weightInput,
        storyInput,
        state.conditionInput,
        state.birthdayInput,
        state.addressInput,
      ]),
    ));
  }

  void doConditionChanged(ConditionValue value) {
    final conditionInput = ConditionInputModel.dirty(value);
    emit(state.copyWith(
      conditionInput: conditionInput,
      status: Formz.validate([
        state.breedInput,
        state.colorInput,
        state.weightInput,
        state.storyInput,
        conditionInput,
        state.birthdayInput,
        state.addressInput,
      ]),
    ));
  }

  void doBirthdayChanged(String value) {
    final birthdayInput = BirthdayInputModel.dirty(value);
    emit(state.copyWith(
      birthdayInput: birthdayInput,
      status: Formz.validate([
        state.breedInput,
        state.colorInput,
        state.weightInput,
        state.storyInput,
        state.conditionInput,
        birthdayInput,
        state.addressInput,
      ]),
    ));
  }

  void doAddressChanged(String value) {
    final addressInput = AddressInputModel.dirty(value);
    emit(state.copyWith(
      addressInput: addressInput,
      status: Formz.validate([
        state.breedInput,
        state.colorInput,
        state.weightInput,
        state.storyInput,
        state.conditionInput,
        state.birthdayInput,
        addressInput,
      ]),
    ));
  }

  // Future<void> logInWithCredentials() async {
  //   if (!state.status.isValidated) return;
  //   emit(state.copyWith(status: FormzStatus.submissionInProgress));
  //   try {
  //     await repository.logInWithEmailAndPassword(
  //       email: state.emailInput.value,
  //       password: state.passwordInput.value,
  //     );
  //     emit(state.copyWith(status: FormzStatus.submissionSuccess));
  //   } on Exception {
  //     emit(state.copyWith(status: FormzStatus.submissionFailure));
  //   }
  // }
}

@CopyWith()
class AddUnitState extends Equatable {
  const AddUnitState({
    this.breedInput = const BreedInputModel.pure(),
    this.colorInput = const ColorInputModel.pure(),
    this.weightInput = const WeightInputModel.pure(),
    this.storyInput = const StoryInputModel.pure(),
    this.conditionInput = const ConditionInputModel.pure(),
    this.birthdayInput = const BirthdayInputModel.pure(),
    this.addressInput = const AddressInputModel.pure(),
    this.status = FormzStatus.pure,
  });

  final BreedInputModel breedInput;
  final ColorInputModel colorInput;
  final WeightInputModel weightInput;
  final StoryInputModel storyInput;
  final ConditionInputModel conditionInput;
  final BirthdayInputModel birthdayInput;
  final AddressInputModel addressInput;
  final FormzStatus status;

  @override
  List<Object> get props => [
        breedInput,
        colorInput,
        weightInput,
        storyInput,
        conditionInput,
        birthdayInput,
        addressInput,
        status
      ];
}
