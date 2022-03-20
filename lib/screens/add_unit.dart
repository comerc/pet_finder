import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_finder/imports.dart';

class AddUnitScreen extends StatefulWidget {
  const AddUnitScreen({Key? key}) : super(key: key);

  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/add_unit',
      builder: (_) => this,
      fullscreenDialog: true,
    );
  }

  @override
  State<AddUnitScreen> createState() => _AddUnitScreenState();
}

class _AddUnitScreenState extends State<AddUnitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          // systemOverlayStyle: SystemUiOverlayStyle.light,
          // backgroundColor: Colors.transparent,
          // elevation: 0,
          centerTitle: true,
          title: Text(
            'Add Your Pet',
            // style: TextStyle(
            //   color: Colors.grey.shade800,
            // ),
          ),
        ),
        body: Center(child: Text("Add Unit")));
  }
}
