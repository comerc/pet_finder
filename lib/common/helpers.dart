import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';

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

class Age {
  int years;
  int months;
  int days;
  Age({this.years = 0, this.months = 0, this.days = 0});
}

Age getAge({required DateTime fromDate, required DateTime toDate}) {
  int years = fromDate.year - toDate.year;
  int months = fromDate.month - toDate.month;
  int days = fromDate.day - toDate.day;
  if (months < 0 || (months == 0 && days < 0)) {
    years--;
    months += days < 0 ? 11 : 12;
  }
  if (days < 0) {
    final monthAgo = DateTime(fromDate.year, fromDate.month - 1, toDate.day);
    days = fromDate.difference(monthAgo).inDays + 1;
  }
  return Age(years: years, months: months, days: days);
}

String formatAge(DateTime birthday) {
  final age = getAge(
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

ImageProvider getImageProvider(String url) {
  // TODO: перенести все картинки из assets, тогда можно удалить эту функцию
  // if (url.startsWith('http')) {
  //   return ExtendedImage.network(url).image;
  // }
  return AssetImage(url);
}
