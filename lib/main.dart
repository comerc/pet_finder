import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:pet_finder/import.dart';

// TODO: для тестирования https://github.com/invertase/spec
// TODO: для монорепо https://github.com/invertase/melos
// TODO: адаптивность https://habr.com/ru/company/epam_systems/blog/546114/
// TODO: Firebase Rules: if request.auth != null;
// TODO: добавить в About: "Robots lovingly delivered by Robohash.org"
// TODO: выставить лимиты на все таблицы
// TODO: нужно ли это сделать? https://flutter.dev/docs/deployment/android#configure-signing-in-gradle
// TODO: "выбрать несколько фото" - не работает
// TODO: нельзя выбирать первую фотку в галерее - зависает загрузка

void main() async {
  // TODO: https://docs.flutter.dev/testing/errors
  // TODO: https://docs.flutter.dev/cookbook/maintenance/error-reporting
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    EquatableConfig.stringify = kDebugMode;
    // runApp(const App());
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
    // TODO: подключить Sentry
  });
}

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

class AppView extends StatelessWidget {
  const AppView({
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cats Home',
      theme: getTheme(context),
      // home: AuthGate(),
      // home: EditProfileScreen(),
      // home: EditUnitScreen(isNew: true),
      // home: HomeScreen(),
      // home: SimpleImageEditor(),
      // builder: BotToastInit(),
      navigatorKey: navigatorKey,
      navigatorObservers: <NavigatorObserver>[
        // FirebaseAnalyticsObserver(analytics: analytics),
        BotToastNavigatorObserver(),
      ],
      scrollBehavior: _AppScrollBehavior(),
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

class _AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

// class AuthGate extends StatelessWidget {
//   const AuthGate({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         // User is not signed in
//         if (!snapshot.hasData) {
//           return const SignInScreen(providerConfigs: [
//             EmailProviderConfiguration(),
//           ]);
//         }
//         // Render your application if authenticated
//         return const HomeScreen();
//       },
//     );
//   }
// }
