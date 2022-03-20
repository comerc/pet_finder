import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_finder/imports.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/profile',
      builder: (_) => this,
      fullscreenDialog: false,
    );
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile'),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: getImageProvider("assets/cats/0.jpg"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(19),
              topRight: Radius.circular(19),
            ),
          ),
        ),
      ),
    );
  }
}
