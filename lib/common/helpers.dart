import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bot_toast/bot_toast.dart';
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
  // TODO: перенести все картинки из assets, тогда можно удалить эту функцию
  if (url.startsWith('http')) {
    return ExtendedImage.network(url).image;
  }
  return ExtendedImage.asset(url).image;
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
        onLongPress: () {}, // чтобы сократить время для splashColor
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
        onLongPress: () {}, // чтобы сократить время для splashColor
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
