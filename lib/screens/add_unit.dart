import 'package:flutter/material.dart';
import 'package:pet_finder/widgets/user_avatar.dart';
import 'package:pet_finder/import.dart';

// TODO: новая порода, если нет желанной

class AddUnitScreen extends StatelessWidget {
  AddUnitScreen({this.category});

  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/add_unit',
      builder: (_) => this,
      fullscreenDialog: true,
    );
  }

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Add your pet',
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
      ),

      body: Container(),
    );
  }
}
