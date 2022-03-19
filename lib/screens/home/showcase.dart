import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
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

  List<WordPair> data = [];
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
      // cacheExtent: 400.0, // TODO: добавить cacheExtent
      itemExtent: 100.0,
      itemCount: data.length + 1,
      itemBuilder: (context, index) {
        if (index == data.length) {
          return SizedBox(
            height: 100.0,
            child: Align(
              alignment: Alignment.topCenter,
              child: isLoading ? Progress() : null,
            ),
          );
        }
        return ListTile(
          title: Text("$index ${data[index].asPascalCase}"),
        );
      },
    );
  }

  Future<void> _loadData({isMore = false}) async {
    if (isLoading) return;
    if (isMore) {
      setState(() {
        isLoading = true;
      });
    } else {
      isLoading = true;
    }
    List<WordPair> newData = [];
    try {
      newData = await _DataSource().load();
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

class _DataSource {
  _DataSource._();

  static final _DataSource _instance = _DataSource._();

  factory _DataSource() {
    return _instance;
  }

  Future<List<WordPair>> load({int size = 10, int delay = 2}) async {
    await Future.delayed(Duration(seconds: delay));
    return generateWordPairs().take(size).toList();
  }
}
