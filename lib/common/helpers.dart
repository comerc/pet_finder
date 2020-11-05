import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:recase/recase.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

T getBloc<T extends Cubit<Object>>(BuildContext context) =>
    BlocProvider.of<T>(context);

T getRepository<T>(BuildContext context) => RepositoryProvider.of<T>(context);

void out(dynamic value) {
  if (kDebugMode) debugPrint('$value');
}

String convertEnumToSnakeCase(dynamic value) {
  return ReCase(EnumToString.parse(value)).snakeCase;
}
