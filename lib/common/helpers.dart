import 'package:flutter/foundation.dart';

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
