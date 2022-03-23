import 'package:flutter/material.dart';
import 'package:pet_finder/imports.dart';

class Showcase extends StatefulWidget {
  const Showcase({Key? key}) : super(key: key);

  @override
  State<Showcase> createState() => _ShowcaseState();
}

class _ShowcaseState extends State<Showcase>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<UnitModel> data = [];
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
    Widget result = data.isEmpty ? Center(child: Progress()) : _buildListView();
    // result =
    //     Padding(child: result, padding: EdgeInsets.symmetric(vertical: 16));
    result = NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: result,
    );
    result = RefreshIndicator(
      child: result,
      onRefresh: () async {
        return _loadData();
      },
    );
    return result;
  }

  Widget _buildListView() {
    return ListView.builder(
      // cacheExtent: width * 4, // TODO: добавить cacheExtent
      itemCount: data.length + 1,
      itemBuilder: (context, index) {
        if (index == data.length) {
          return SizedBox(
            height: 120.0,
            child: isLoading
                ? Progress()
                : Center(
                    child: ElevatedButton(
                      onLongPress:
                          () {}, // чтобы сократить время для splashColor
                      onPressed: () {
                        _loadData(isMore: true);
                      },
                      child: Text("Load More"),
                    ),
                  ),
          );
        }
        return Unit(unit: data[index]);
      },
    );
  }

  Future<void> _loadData({isMore = false}) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    List<UnitModel> newData = [];
    try {
      newData = await DatabaseRepository().load(isMore: isMore);
    } finally {
      setState(() {
        if (isMore) {
          data = [...data, ...newData];
        } else {
          data = [...newData];
        }
        isLoading = false;
      });
    }
  }
}
