import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

part 'login.g.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(AuthenticationRepository repository)
      : _repository = repository,
        super(LoginState());

  final AuthenticationRepository _repository;

  void doEmailChanged(String value) {
    final emailInput = EmailInputModel.dirty(value);
    emit(
      state.copyWith(
        emailInput: emailInput,
        status: Formz.validate([emailInput, state.passwordInput]),
      ),
    );
  }

  void doPasswordChanged(String value) {
    final passwordInput = PasswordInputModel.dirty(value);
    emit(
      state.copyWith(
        passwordInput: passwordInput,
        status: Formz.validate([state.emailInput, passwordInput]),
      ),
    );
  }

  Future<void> logInWithCredentials() async {
    if (!state.status.isValidated) {
      throw ValidationException('Invalid form values');
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _repository.logInWithEmailAndPassword(
        email: state.emailInput.value,
        password: state.passwordInput.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
      rethrow;
    }
  }

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _repository.logInWithGoogle();
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
      rethrow;
      // ignore: avoid_catching_errors
    } on NoSuchMethodError {
      emit(state.copyWith(status: FormzStatus.pure));
    }
  }
}

@CopyWith()
class LoginState extends Equatable {
  const LoginState({
    this.emailInput = const EmailInputModel.pure(),
    this.passwordInput = const PasswordInputModel.pure(),
    this.status = FormzStatus.pure,
  });

  final EmailInputModel emailInput;
  final PasswordInputModel passwordInput;
  // https://github.com/numen31337/copy_with_extension/pull/23
  // TODO: @CopyWithField(required: true)
  final FormzStatus status;

  @override
  List<Object> get props => [emailInput, passwordInput, status];
}
