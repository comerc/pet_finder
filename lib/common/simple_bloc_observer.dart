import 'package:bloc/bloc.dart';
import 'package:pet_finder/import.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    out(error);
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    out(change);
    super.onChange(cubit, change);
  }

  @override
  void onCreate(Cubit cubit) {
    out('**** onCreate $cubit');
    super.onCreate(cubit);
  }

  @override
  void onClose(Cubit cubit) {
    out('**** onClose $cubit');
    super.onClose(cubit);
  }
}
