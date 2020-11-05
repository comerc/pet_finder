// import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/import.dart';

class ShowcaseScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/showcase',
      builder: (_) => this,
      fullscreenDialog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // timeDilation = 2.0; // Will slow down animations by a factor of two
    return Scaffold(
      appBar: AppBar(title: Text('Showcase')),
      body: BlocProvider(
        create: (BuildContext context) =>
            ShowcaseCubit(getRepository<DatabaseRepository>(context))..load(),
        child: ShowcaseBody(),
      ),
    );
  }
}

class ShowcaseBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('showcase'));
  }
}
