import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:bot_toast/bot_toast.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_finder/import.dart';

void main() {
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
    // await Firebase.initializeApp();
    EquatableConfig.stringify = kDebugMode;
    // Bloc.observer = SimpleBlocObserver();
    HydratedBloc.storage = await HydratedStorage.build();
    runApp(
      App(
        // authenticationRepository: AuthenticationRepository(),
        databaseRepository: DatabaseRepository(),
      ),
    );
  }, (error, stackTrace) {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    // _reportError(error, stackTrace);
  });
}

final navigatorKey = GlobalKey<NavigatorState>();

NavigatorState get navigator => navigatorKey.currentState;

class App extends StatelessWidget {
  App({
    Key key,
    // @required this.authenticationRepository,
    @required this.databaseRepository,
  })  :
        // assert(authenticationRepository != null),
        assert(databaseRepository != null),
        super(key: key);

  // final AuthenticationRepository authenticationRepository;
  final DatabaseRepository databaseRepository;

  @override
  Widget build(BuildContext context) {
    Widget result = AppView();
    result = MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create: (BuildContext context) =>
        //       AuthenticationCubit(authenticationRepository),
        // ),
        BlocProvider(
          create: (BuildContext context) => AppCubit(databaseRepository),
        ),
      ],
      child: result,
    );
    result = MultiRepositoryProvider(
      providers: [
        // RepositoryProvider.value(
        //   value: authenticationRepository,
        // ),
        RepositoryProvider.value(
          value: databaseRepository,
        ),
      ],
      child: result,
    );
    return result;
  }
}

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.montserratTextTheme(),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.grey[800], // Color(0xff575757), // primaryColor
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      navigatorObservers: [
        BotToastNavigatorObserver(),
      ],
      builder: (BuildContext context, Widget child) {
        Widget result = child;
        // result = BlocListener<AuthenticationCubit, AuthenticationState>(
        //   listener: (BuildContext context, AuthenticationState state) {
        //     final cases = {
        //       AuthenticationStatus.authenticated: () {
        //         navigator.pushAndRemoveUntil<void>(
        //           HomeScreen().getRoute(),
        //           (Route route) => false,
        //         );
        //       },
        //       AuthenticationStatus.unauthenticated: () {
        //         navigator.pushAndRemoveUntil<void>(
        //           LoginScreen().getRoute(),
        //           (Route route) => false,
        //         );
        //       },
        //       AuthenticationStatus.unknown: () {},
        //     };
        //     assert(cases.length == AuthenticationStatus.values.length);
        //     cases[state.status]();
        //   },
        //   child: result,
        // );
        result = BotToastInit()(context, result);
        return result;
      },
      home: HomeScreen(),
      // home: AddUnitScreen(
      //   category: CategoryModel(
      //     id: 'dog',
      //     name: 'Dogs',
      //     totalOf: 210,
      //     color: '#90caf9',
      //     breeds: [],
      //   ),
      // ),
      // onGenerateRoute: (_) => SplashScreen().getRoute(),
    );
  }
}
