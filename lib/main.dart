import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutterfire_ui/auth.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:pet_finder/import.dart';

// TODO: для тестирования https://github.com/invertase/spec
// TODO: для монорепо https://github.com/invertase/melos
// TODO: адаптивность https://habr.com/ru/company/epam_systems/blog/546114/
// TODO: Firebase Rules: if request.auth != null;
// TODO: добавить в About: "Robots lovingly delivered by Robohash.org"

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  EquatableConfig.stringify = kDebugMode;
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

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
      home: HomeScreen(),
      // home: SimpleImageEditor(),
      builder: BotToastInit(),
      navigatorKey: navigatorKey,
      navigatorObservers: <NavigatorObserver>[
        // FirebaseAnalyticsObserver(analytics: analytics),
        BotToastNavigatorObserver(),
      ],
      scrollBehavior: _AppScrollBehavior(),
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
