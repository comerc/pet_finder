import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_finder/imports.dart';

class LoadProfileScreen extends StatefulWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/load_profile',
      builder: (_) => this,
      fullscreenDialog: true,
    );
  }

  const LoadProfileScreen({Key? key}) : super(key: key);

  @override
  State<LoadProfileScreen> createState() => _LoadProfileScreenState();
}

class _LoadProfileScreenState extends State<LoadProfileScreen> {
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
            'Load Profile...',
            // style: TextStyle(
            //   color: Colors.grey.shade800,
            // ),
          ),
        ),
        body: Center(child: Text("...")));
  }
}
