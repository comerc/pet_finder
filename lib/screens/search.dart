import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_finder/import.dart';

class SearchScreen extends StatefulWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/search',
      builder: (_) => this,
      fullscreenDialog: false,
    );
  }

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Search'),
      ),
      body: Center(
        child: Text('Search'),
      ),
    );
  }
}
