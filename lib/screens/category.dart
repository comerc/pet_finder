// import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/import.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen(this.category);

  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/category?id=${category.id}',
      builder: (_) => this,
      fullscreenDialog: true,
    );
  }

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    // timeDilation = 2.0; // Will slow down animations by a factor of two
    return Scaffold(
      appBar: AppBar(title: Text('${category.name} Category')),
      body: BlocProvider(
        create: (BuildContext context) =>
            CategoryCubit(getRepository<DatabaseRepository>(context))
              ..load(categoryId: category.id),
        child: CategoryBody(),
      ),
    );
  }
}

class CategoryBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text('category'));
  }
}
