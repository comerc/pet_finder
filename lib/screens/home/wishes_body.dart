import 'package:flutter/material.dart';
import 'package:pet_finder/import.dart';

class WishesBody extends StatefulWidget {
  const WishesBody({Key? key}) : super(key: key);

  @override
  State<WishesBody> createState() => _WishesBodyState();
}

class _WishesBodyState extends State<WishesBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    out("_WishesBodyState.initState");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Text("wishesBody"),
    );
  }
}
