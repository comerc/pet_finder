import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cat_avatar_generator/cat_avatar_generator.dart';
import 'package:pet_finder/import.dart';

T getBloc<T extends Cubit>(BuildContext context) => BlocProvider.of<T>(context);

T getRepository<T>(BuildContext context) => RepositoryProvider.of<T>(context);

// TODO: add Sentry or Firebase "Bug-Log"?
void out(dynamic value) {
  if (kDebugMode) debugPrint('$value');
}

String formatAge(UnitModel unit) {
  if (unit.age == AgeValue.child) {
    return unit.sex == SexValue.male ? "Kid" : "Baby";
  }

  if (unit.age == AgeValue.aged) {
    return "Aged";
  }
  if (unit.birthday == null) {
    if (unit.age == AgeValue.adult) {
      return "Adult";
    }
    return "unknown";
  }
  DateDuration year = AgeCalculator.age(unit.birthday!);
  if (year.years >= 7) {
    return "Aged";
  }
  var result = '';
  if (year.years > 0) {
    result = '${year.years}';
    result += year.years == 1 ? ' year' : ' years';
    // if (year.months > 0) {
    //   result += ' ${year.months}';
    //   result += year.months == 1 ? ' month' : ' months';
    // }
  } else if (year.months > 0) {
    result = '${year.months}';
    result += year.months == 1 ? ' month' : ' months';
  } else if (year.days > 0) {
    result = '${year.days}';
    result += year.days == 1 ? ' day' : ' days';
  }
  return result;
}

String formatWeight(int weight) {
  return (weight / 1000).toStringAsPrecision(2);
}

ImageProvider getImageProvider(String url) {
  if (url.startsWith('http')) {
    return ExtendedImage.network(
      url,
      loadStateChanged: loadStateChanged,
    ).image;
  }
  return MeowatarImage.fromString(url);
  // return Image.asset(url).image;
}

final _random = Random();

int next(int min, int max) => min + _random.nextInt(max - min);

class SizeInt {
  SizeInt(this.width, this.height);

  final int width;
  final int height;
}

void load(Future<void> Function() future) async {
  await Future.delayed(Duration.zero); // for render initial state
  try {
    await future();
  } catch (error) {
    out(error);
    BotToast.showNotification(
      crossPage: false,
      title: (_) => Text('$error'),
      trailing: (CancelFunc cancel) => TextButton(
        onPressed: () {
          cancel();
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
      title: (_) => Text('$error'),
    );
  } catch (error) {
    out(error);
    BotToast.showNotification(
      // crossPage: true, // by default - important value!!!
      title: (_) => Text('$error'),
      trailing: (CancelFunc cancel) => TextButton(
        onPressed: () {
          cancel();
          save(future);
        },
        child: Text('Repeat'.toUpperCase()),
      ),
    );
  } finally {
    BotToast.closeAllLoading();
  }
}

Widget? loadStateChanged(ExtendedImageState state) {
  if (state.extendedImageLoadState != LoadState.loading) return null;
  return Builder(builder: (BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey.withOpacity(0.3),
      child: Progress(),
    );
  });
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
Map<String, dynamic> parseIdToken(String idToken) {
  final parts = idToken.split(r'.');
  assert(parts.length == 3);
  return jsonDecode(
    utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
  ) as Map<String, dynamic>;
}
