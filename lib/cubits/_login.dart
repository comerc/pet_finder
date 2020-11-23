import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

class LoginCubit extends Cubit<void> {
  LoginCubit(this.repository)
      : assert(repository != null),
        super(null);

  final AuthenticationRepository repository;

  Future<void> logInWithGoogle() async {
    await repository.logInWithGoogle();
  }
}
