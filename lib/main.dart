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
    return RepositoryProvider(
      create: (BuildContext context) => databaseRepository,
      child: MaterialApp(
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
          var result = child;
          result = BotToastInit()(context, result);
          result = BlocProvider(
            create: (BuildContext context) {
              final cubit =
                  ProfileCubit(getRepository<DatabaseRepository>(context));
              cubit.load(); // TODO: будет ли срабатывать тут BotToast
              return cubit;
            },
            child: result,
          );
          return result;
        },
        home: HomeScreen(),
        // home: AddUnitScreen(
        //   category: CategoryModel(
        //     id: 'cat',
        //     name: 'Cats',
        //     totalOf: 210,
        //     color: '#90caf9',
        //   ),
        // ),
        // home: HomePage(),
      ),
    );
  }
}

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('DraggableScrollableSheet'),
//       ),
//       body: SizedBox.expand(
//         child: DraggableScrollableSheet(
//           builder: (BuildContext context, ScrollController scrollController) {
//             return Container(
//               color: Colors.blue[100],
//               child: ListView.builder(
//                 controller: scrollController,
//                 itemCount: 25,
//                 itemBuilder: (BuildContext context, int index) {
//                   return ListTile(title: Text('Item $index'));
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
