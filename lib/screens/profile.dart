import 'package:flutter/material.dart';
import 'package:pet_finder/imports.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100.0,
          child: Container(
            child: Text("1234"),
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
