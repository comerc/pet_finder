import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutterfire_ui/auth.dart';
import 'package:pet_finder/imports.dart';

// TODO: ScaffoldMessenger.of(context).showSnackBar(snackBar);
// TODO: для тестирования https://github.com/invertase/spec
// TODO: для монорепо https://github.com/invertase/melos
// TODO: адаптивность https://habr.com/ru/company/epam_systems/blog/546114/

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
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
      home: HomeScreen(),
      navigatorKey: navigatorKey,
      // navigatorObservers: <NavigatorObserver>[
      //   FirebaseAnalyticsObserver(analytics: analytics),
      //   BotToastNavigatorObserver(),
      // ],
    );
  }
}

// class AuthGate extends StatelessWidget {
//   const AuthGate({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         // User is not signed in
//         // if (!snapshot.hasData) {
//         //   return const SignInScreen(providerConfigs: [
//         //     EmailProviderConfiguration(),
//         //   ]);
//         // }
//         // Render your application if authenticated
//         return const HomeScreen();
//       },
//     );
//   }
// }
