import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/principal.dart';
import 'package:pet_finder/import.dart';

void main() {
  runApp(App(
    databaseRepository: DatabaseRepository(),
  ));
}

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
    //     .readUnits(categoryId: CategoryKey.cat)
    //     .then((List<UnitModel> value) => out(value[0].member.name));

    return RepositoryProvider(
        create: (BuildContext context) => databaseRepository,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.montserratTextTheme(),
          ),
          debugShowCheckedModeBanner: false,
          home: Principal(),
        ));
  }
}
