import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:recase/recase.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:age/age.dart';
import 'package:crypto/crypto.dart';

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

void load(Future<void> Function() future) async {
  try {
    await future();
  } catch (error) {
    out(error);
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
  }
}

void save(Future<void> Function() future) async {
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
  } catch (error) {
    out(error);
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
  } finally {
    BotToast.closeAllLoading();
  }
}

// Map<String, dynamic> parseJwt(String token) {
//   final parts = token.split('.');
//   if (parts.length != 3) {
//     throw Exception('invalid token');
//   }
//   final payload = _decodeBase64(parts[1]);
//   final payloadMap = json.decode(payload);
//   if (payloadMap is! Map<String, dynamic>) {
//     throw Exception('invalid payload');
//   }
//   return payloadMap;
// }

// String _decodeBase64(String str) {
//   var output = str.replaceAll('-', '+').replaceAll('_', '/');
//   switch (output.length % 4) {
//     case 0:
//       break;
//     case 2:
//       output += '==';
//       break;
//     case 3:
//       output += '=';
//       break;
//     default:
//       throw Exception('Illegal base64url string!"');
//   }
//   return utf8.decode(base64Url.decode(output));
// }

// variant from auth0.com
// Map<String, dynamic> parseIdToken(String idToken) {
//   final parts = idToken.split(r'.');
//   assert(parts.length == 3);
//   return jsonDecode(
//           utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))))
//       as Map<String, dynamic>;
// }

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

class SizeInt {
  SizeInt(this.width, this.height);

  final int width;
  final int height;
}

// TODO: перенести все картинки из assets, тогда можно удалить эту функцию

ImageProvider getImageProvider(String url) {
  if (url.startsWith('http')) {
    return ExtendedImage.network(url).image;
  }
  return AssetImage(url);
}
