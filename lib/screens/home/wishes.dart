import 'package:flutter/material.dart';
import 'package:pet_finder/imports.dart';

class Wishes extends StatefulWidget {
  const Wishes({Key? key}) : super(key: key);

  @override
  State<Wishes> createState() => _WishesState();
}

class _WishesState extends State<Wishes> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Text("wishes"),
    );
  }
}
