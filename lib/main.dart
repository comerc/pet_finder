import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:pet_finder/import.dart';

void main() {
  runApp(App(
    databaseRepository: DatabaseRepository(),
  ));
}

final navigatorKey = GlobalKey<NavigatorState>();

NavigatorState get navigator => navigatorKey.currentState;

class App extends StatelessWidget {
  App({
    Key key,
    @required this.databaseRepository,
  })  : assert(databaseRepository != null),
        super(key: key);

  final DatabaseRepository databaseRepository;

  @override
  Widget build(BuildContext context) {
    // databaseRepository
    //     .readUnits(categoryId: 'cat', limit: 4)
    //     .then((List<UnitModel> value) => out(value));
    // databaseRepository
    //     .readNewestUnits(limit: 4)
    //     .then((List<UnitModel> value) => out(value));
    // databaseRepository
    //     .readCategories()
    //     .then((List<CategoryModel> value) => out(value[0]));
    // databaseRepository
    //     .readProfile()
    //     .then((ProfileModel value) => out(value.wishes[1].unitId));
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
        result = BlocProvider(
          create: (BuildContext context) =>
              ProfileCubit(getRepository<DatabaseRepository>(context)),
          child: result,
        );
        result = RepositoryProvider(
          create: (BuildContext context) => databaseRepository,
          child: result,
        );
        result = BotToastInit()(context, result);
        return result;
      },
      home: HomeScreen(),
      initialRoute: '/start',
      routes: {
        '/start': (_) => StartScreen(),
      },
      // home: AddUnitScreen(
      //   category: CategoryModel(
      //     id: 'dog',
      //     name: 'Dogs',
      //     totalOf: 210,
      //     color: '#90caf9',
      //   ),
      // ),
    );
  }
}
