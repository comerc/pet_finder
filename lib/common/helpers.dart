import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pet_finder/imports.dart';

bool get isInDebugMode {
  // Assume you're in production mode.
  var inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  // or
  // inDebugMode = kReleaseMode != null;

  return inDebugMode;
}

// TODO: add Sentry or Firebase "Bug-Log"?
void out(dynamic value) {
  if (isInDebugMode) debugPrint('$value');
}

String formatAge(UnitModel unit) {
  if (unit.age == Age.child) {
    return unit.sex == Sex.male ? "Kid" : "Baby";
  }

  if (unit.age == Age.aged) {
    return "Aged";
  }
  if (unit.birthday == null) {
    if (unit.age == Age.adult) {
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
  // if (url.startsWith('http')) {
  //   return ExtendedImage.network(url).image;
  // }
  return AssetImage(url);
}

var _random = Random();

int next(int min, int max) => min + _random.nextInt(max - min);
