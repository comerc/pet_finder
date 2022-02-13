import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;
// import 'package:google_fonts/google_fonts.dart';
import 'package:pet_finder/import.dart';

// TODO: выставить лимиты на все таблицы
// TODO: нужно ли это сделать? https://flutter.dev/docs/deployment/android#configure-signing-in-gradle
// TODO: выкинуть модели email_input, password_input, confirmed_password_input
// TODO: прикрутить json_serializable_immutable_collections & built_collection (смотри minsk8)

void main() {
  // TODO: https://docs.flutter.dev/testing/errors
  // TODO: https://docs.flutter.dev/cookbook/maintenance/error-reporting

  // timeDilation = 10.0; // Will slow down animations by a factor of two
  // debugPaintSizeEnabled = true;
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   if (kDebugMode) {
  //     // In development mode, simply print to console.
  //     FlutterError.dumpErrorToConsole(details);
  //   } else {
  //     // In production mode, report to the application zone to report to
  //     // Sentry.
  //     Zone.current.handleUncaughtError(details.exception, details.stack);
  //   }
  // };
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    EquatableConfig.stringify = kDebugMode;
    // Bloc.observer = SimpleBlocObserver();
    // TODO: delete follow code after migrate
    // HydratedBloc.storage = await HydratedStorage.build();
    // runApp(
    //   App(
    //     authenticationRepository: AuthenticationRepository(),
    //     databaseRepository: DatabaseRepository(),
    //   ),
    // );
    final storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory(),
    );
    HydratedBlocOverrides.runZoned(
      () => runApp(
        App(
          authenticationRepository: AuthenticationRepository(),
          databaseRepository: DatabaseRepository(),
        ),
      ),
      storage: storage,
    );
  }, (error, stackTrace) {
    out('**** runZonedGuarded ****');
    out('$error');
    out('$stackTrace');
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    // _reportError(error, stackTrace);
  });
}

final navigatorKey = GlobalKey<NavigatorState>();

NavigatorState get navigator => navigatorKey.currentState!;

class App extends StatelessWidget {
  App({
    Key? key,
    required this.authenticationRepository,
    required this.databaseRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final DatabaseRepository databaseRepository;

  @override
  Widget build(BuildContext context) {
    Widget result = AppView();
    result = BlocProvider(
      create: (BuildContext context) {
        return ProfileCubit(databaseRepository);
      },
      child: result,
    );
    result = RepositoryProvider.value(
      value: databaseRepository,
      child: result,
    );
    result = BlocProvider.value(
      value: AuthenticationCubit(authenticationRepository),
      child: result,
    );
    result = RepositoryProvider.value(
      value: authenticationRepository,
      child: result,
    );
    return result;
  }
}

// final ButtonStyle flatButtonStyle = TextButton.styleFrom(
//   primary: Colors.black87,
//   minimumSize: Size(88, 36),
//   padding: EdgeInsets.symmetric(horizontal: 16.0),
//   shape: const RoundedRectangleBorder(
//     borderRadius: BorderRadius.all(Radius.circular(2.0)),
//   ),
// );

// final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
//   onPrimary: Colors.black87,
//   primary: Colors.grey[300],
//   minimumSize: Size(88, 36),
//   padding: EdgeInsets.symmetric(horizontal: 16),
//   shape: const RoundedRectangleBorder(
//     borderRadius: BorderRadius.all(Radius.circular(2)),
//   ),
// );

// final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
//   primary: Colors.black87,
//   minimumSize: Size(88, 36),
//   padding: EdgeInsets.symmetric(horizontal: 16),
//   shape: const RoundedRectangleBorder(
//     borderRadius: BorderRadius.all(Radius.circular(2)),
//   ),
// ).copyWith(
//   side: MaterialStateProperty.resolveWith<BorderSide>(
//     (Set<MaterialState> states) {
//       if (states.contains(MaterialState.pressed)) {
//         return BorderSide(
//           color: Theme.of(context).colorScheme.primary,
//         );
//       }
//       return null; // Defer to the widget's default.
//     },
//   ),
// );

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Finder',
      theme: ThemeData(
        // theme: ThemeData.from(colorScheme: ColorScheme.light()).copyWith(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // textTheme: GoogleFonts.montserratTextTheme(), // TODO: на Ubuntu не работает русский шрифт
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.grey.shade800, // Color(0xff575757), // primaryColor
            size: 24,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey.shade800,
          size: 24,
        ),
        // textButtonTheme: TextButtonThemeData(style: flatButtonStyle),
        // elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
        // outlinedButtonTheme: OutlinedButtonThemeData(style: outlineButtonStyle),
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      navigatorObservers: [
        BotToastNavigatorObserver(),
      ],
      builder: (BuildContext context, Widget? child) {
        Widget result = child!;
        result = BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (ProfileState previous, ProfileState current) {
            return previous.status != current.status &&
                current.status == ProfileStatus.ready;
          },
          listener: (BuildContext context, ProfileState state) {
            navigator.pushAndRemoveUntil<void>(
              HomeScreen().getRoute(),
              (Route route) => false,
            );
          },
          child: result,
        );
        result = BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (BuildContext context, AuthenticationState state) {
            final cases = {
              AuthenticationStatus.authenticated: () {
                navigator.pushAndRemoveUntil<void>(
                  LoadProfileScreen().getRoute(),
                  (Route route) => false,
                );
              },
              AuthenticationStatus.unauthenticated: () {
                navigator.pushAndRemoveUntil<void>(
                  LoginScreen().getRoute(),
                  (Route route) => false,
                );
              },
              AuthenticationStatus.unknown: () {},
            };
            assert(cases.length == AuthenticationStatus.values.length);
            cases[state.status]!();
          },
          child: result,
        );
        result = BotToastInit()(context, result);
        return result;
      },
      onGenerateRoute: (RouteSettings settings) => SplashScreen().getRoute(),
    );
  }
}
