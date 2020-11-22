import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:recase/recase.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:age/age.dart';

T getBloc<T extends Cubit<Object>>(BuildContext context) =>
    BlocProvider.of<T>(context);

T getRepository<T>(BuildContext context) => RepositoryProvider.of<T>(context);

void out(dynamic value) {
  if (kDebugMode) debugPrint('$value');
}

String convertEnumToSnakeCase(dynamic value) {
  return ReCase(EnumToString.parse(value)).snakeCase;
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    var result = hexColor.toUpperCase().replaceAll("#", "");
    if (result.length == 6) {
      result = 'FF$result';
    }
    return int.parse(result, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class ValidationException implements Exception {
  ValidationException(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}

String formatAge(DateTime birthday) {
  final age = Age.dateDifference(
    fromDate: birthday,
    toDate: DateTime.now(),
    // includeToDate: false,
  );
  var result = '';
  if (age.years > 0) {
    result = '${age.years}';
    if (age.months > 0) {
      result += '.${age.months}';
    }
    result += age.years == 1 ? ' year' : ' years';
  } else if (age.months > 0) {
    result = '${age.months}';
    result += age.months == 1 ? ' month' : ' months';
  } else if (age.days > 0) {
    result = '${age.days}';
    result += age.days == 1 ? ' day' : ' days';
  }
  return result;
}

String formatWeight(int weight) {
  return (weight / 1000).toStringAsPrecision(2);
}

Future<void> load(Future<void> Function() future) async {
  try {
    await future();
  } catch (error) {
    BotToast.showNotification(
      crossPage: false,
      title: (_) => Text(
        '$error',
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
      trailing: (Function close) => FlatButton(
        onLongPress: () {}, // чтобы сократить время для splashColor
        onPressed: () {
          close();
          load(future);
        },
        child: Text('Repeat'.toUpperCase()),
      ),
    );
    return Future.error(error);
  }
}

Future<void> save(Future<void> Function() future) async {
  BotToast.showLoading();
  try {
    await future();
  } on ValidationException catch (error) {
    BotToast.showNotification(
      crossPage: false,
      title: (_) => Text(
        '$error',
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
    );
    return Future.error(error);
  } catch (error) {
    BotToast.showNotification(
      // crossPage: true, // by default - important value!!!
      title: (_) => Text(
        '$error',
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
      trailing: (Function close) => FlatButton(
        onLongPress: () {}, // чтобы сократить время для splashColor
        onPressed: () {
          close();
          save(future);
        },
        child: Text('Repeat'.toUpperCase()),
      ),
    );
    return Future.error(error);
  } finally {
    BotToast.closeAllLoading();
  }
}
