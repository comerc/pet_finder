// import 'package:bot_toast/bot_toast.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/import.dart';

// TODO: добавить Refresh

class ShowcaseScreen extends StatelessWidget {
  ShowcaseScreen({this.category, this.query});

  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/showcase?category_id=${category?.id}&query=$query',
      builder: (_) => this,
      // fullscreenDialog: true,
    );
  }

  final CategoryModel? category;
  final String? query;

  @override
  Widget build(BuildContext context) {
    // timeDilation = 2.0; // Will slow down animations by a factor of two
    return BlocProvider(
      create: (BuildContext context) => ShowcaseCubit(
        getRepository<DatabaseRepository>(context),
        categoryId: category?.id ?? '',
        query: query ?? '',
      ),
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            category == null
                ? 'Found for "$query"'
                : '${category!.name} Category',
            style: TextStyle(
              color: Colors.grey.shade800,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.more_horiz),
            ),
          ],
        ),
        body: ShowcaseBody(),
        floatingActionButton:
            category == null ? null : AddButton(category: category!),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({
    Key? key,
    required this.category,
  }) : super(key: key);

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final result = await navigator
            .push<bool>(AddUnitScreen(category: category).getRoute());
        if (result ?? false) {
          load(() => getBloc<ShowcaseCubit>(context).load());
        }
      },
      tooltip: 'Add your pet',
      child: Icon(Icons.add),
    );
  }
}

// TODO: добавить поле ввода для поиска (продублировать с HomeScreen)
// TODO: добавить выбор категории (продублировать с HomeScreen)

class ShowcaseBody extends StatefulWidget {
  @override
  _ShowcaseBodyState createState() => _ShowcaseBodyState();
}

class _ShowcaseBodyState extends State<ShowcaseBody> {
  @override
  void initState() {
    super.initState();
    load(() => getBloc<ShowcaseCubit>(context).load());
  }

  @override
  Widget build(BuildContext context) {
    Widget result;
    result = BlocBuilder<ShowcaseCubit, ShowcaseState>(
      buildWhen: (ShowcaseState previous, ShowcaseState current) {
        return previous.status != current.status;
      },
      builder: (BuildContext context, ShowcaseState state) {
        final cases = {
          ShowcaseStatus.initial: () => Container(),
          ShowcaseStatus.loading: () =>
              Center(child: CircularProgressIndicator()),
          ShowcaseStatus.error: () {
            return Center(
              child: FloatingActionButton(
                onPressed: () {
                  BotToast.cleanAll();
                  load(() => getBloc<ShowcaseCubit>(context).load());
                },
                child: Icon(Icons.replay),
              ),
            );
          },
          ShowcaseStatus.ready: () => ShowcaseView(),
        };
        assert(cases.length == ShowcaseStatus.values.length);
        return cases[state.status]!();
      },
    );
    result = RefreshIndicator(
      onRefresh: () async {
        load(() => getBloc<ShowcaseCubit>(context).load());
        return;
      },
      child: result,
    );
    return result;
  }
}

class ShowcaseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TODO: добавить фильт по ConditionValue
        // Material(
        //   child: Padding(
        //     padding:
        //         EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 32),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         buildFilter("Mating", false),
        //         buildFilter("Adoption", true),
        //         buildFilter("Disappear", true),
        //       ],
        //     ),
        //   ),
        //   // elevation: 2, // TODO: add elevation
        // ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<ShowcaseCubit, ShowcaseState>(
              buildWhen: (ShowcaseState previous, ShowcaseState current) {
                return previous.units != current.units;
              },
              builder: (BuildContext context, ShowcaseState state) {
                return GridView.count(
                  physics: BouncingScrollPhysics(),
                  childAspectRatio: 1 / 1.55,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  children: List.generate(
                    state.units.length,
                    (int index) => Unit(unit: state.units[index]),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// Widget buildFilter(String name, bool selected) {
//   return Container(
//     padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.all(
//         Radius.circular(20),
//       ),
//       border: Border.all(
//         width: 1,
//         color: selected ? Colors.transparent : Colors.grey.shade800,
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: selected ? Colors.blue.shade300.withOpacity(0.5) : Colors.white,
//           spreadRadius: 3,
//           blurRadius: 5,
//           offset: Offset(0, 0),
//         ),
//       ],
//       color: selected ? Colors.blue.shade300 : Colors.white,
//     ),
//     child: Row(
//       children: [
//         Text(
//           name,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             color: selected ? Colors.white : Colors.grey.shade800,
//           ),
//         ),
//         selected
//             ? Row(
//                 children: [
//                   SizedBox(
//                     width: 8,
//                   ),
//                   Icon(
//                     Icons.clear,
//                     color: Colors.white,
//                     size: 18,
//                   ),
//                 ],
//               )
//             : Container(),
//       ],
//     ),
//   );
// }
