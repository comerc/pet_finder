import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:pet_finder/import.dart';

class ShowcaseBody extends StatefulWidget {
  const ShowcaseBody({Key? key}) : super(key: key);

  @override
  State<ShowcaseBody> createState() => _ShowcaseBodyState();
}

class _ShowcaseBodyState extends State<ShowcaseBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // List<UnitModel> data = [];
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        notification.metrics.extentAfter == 0) {
      _loadData(isMore: true);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget result;
    result = BlocBuilder<ShowcaseCubit, ShowcaseState>(
      buildWhen: (ShowcaseState previous, ShowcaseState current) {
        return previous.status != current.status;
      },
      builder: (BuildContext context, ShowcaseState state) {
        // final cases = {
        //   ShowcaseStatus.initial: () => Container(),
        //   // ShowcaseStatus.loading: () => Center(child: Progress()),
        //   ShowcaseStatus.error: () {
        //     return Center(
        //       child: FloatingActionButton(
        //         onPressed: () {
        //           BotToast.cleanAll();
        //           _loadData();
        //         },
        //         child: Icon(Icons.replay),
        //       ),
        //     );
        //   },
        //   ShowcaseStatus.loading: () => _buildListView(),
        //   ShowcaseStatus.ready: () => _buildListView(),
        // };
        // assert(cases.length == ShowcaseStatus.values.length);
        // return cases[state.status]!();
        return _buildListView();
      },
    );
    // Widget result = data.isEmpty ? Center(child: Progress()) : _buildListView();
    // // result =
    // //     Padding(child: result, padding: EdgeInsets.symmetric(vertical: 16));
    // result = NotificationListener<ScrollNotification>(
    //   onNotification: _handleScrollNotification,
    //   child: result,
    // );
    result = RefreshIndicator(
      child: result,
      onRefresh: () async {
        return _loadData();
      },
    );
    return result;
  }

  Widget _buildListView() {
    return BlocBuilder<ShowcaseCubit, ShowcaseState>(
        buildWhen: (ShowcaseState previous, ShowcaseState current) {
      return previous.units != current.units;
    }, builder: (BuildContext context, ShowcaseState state) {
      return ListView.builder(
        // cacheExtent: width * 4, // TODO: добавить cacheExtent
        itemCount: state.units.length + 1,
        itemBuilder: (context, index) {
          if (index == state.units.length) {
            return SizedBox(
              height: 120.0,
              child: isLoading
                  ? Progress()
                  : Center(
                      child: OutlinedButton(
                        onPressed: () {
                          _loadData(isMore: true);
                        },
                        child: Text("Load More"),
                      ),
                    ),
            );
          }
          return Unit(unit: state.units[index]);
        },
      );
    });
  }

  Future<void> _loadData({isMore = false}) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    // List<UnitModel> newData = [];
    try {
      await getBloc<ShowcaseCubit>(context).load();
      // TODO: newData = await DatabaseRepository().load(isMore: isMore);
    } finally {
      setState(() {
        // if (isMore) {
        //   data = [...data, ...newData];
        // } else {
        //   data = [...newData];
        // }
        isLoading = false;
      });
    }
  }
}
