import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase cubit, Object error, StackTrace stackTrace) {
    out(error);
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onChange(BlocBase cubit, Change change) {
    out(change);
    super.onChange(cubit, change);
  }

  @override
  void onCreate(BlocBase cubit) {
    out('**** onCreate $cubit');
    super.onCreate(cubit);
  }

  @override
  void onClose(BlocBase cubit) {
    out('**** onClose $cubit');
    super.onClose(cubit);
  }
}
