// // import 'package:bot_toast/bot_toast.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter/scheduler.dart' show timeDilation;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pet_finder/import.dart';

// class SearchScreen extends StatelessWidget {
//   SearchScreen(this.query);

//   Route<T> getRoute<T>() {
//     return buildRoute<T>(
//       '/search?q=${query}',
//       builder: (_) => this,
//       fullscreenDialog: true,
//     );
//   }

//   final String query;

//   @override
//   Widget build(BuildContext context) {
//     // timeDilation = 2.0; // Will slow down animations by a factor of two
//     return Scaffold(
//       appBar: AppBar(title: Text('Search by $query')),
//       body: BlocProvider(
//         create: (BuildContext context) =>
//             SearchCubit(getRepository<DatabaseRepository>(context))
//               ..load(query: query),
//         child: CategoryBody(),
//       ),
//     );
//   }
// }

// class CategoryBody extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(child: Text('category'));
//   }
// }
