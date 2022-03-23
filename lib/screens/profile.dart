import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_finder/imports.dart';

class ProfileScreen extends StatefulWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/profile',
      builder: (_) => this,
      fullscreenDialog: false,
    );
  }

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final url = DatabaseRepository().member.imageUrl!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16),
          _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    const kRadius = 80;
    const kButtonRadius = 24;
    return Center(
      child: Container(
        width: kRadius * 2,
        height: kRadius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: getImageProvider(url),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.only(bottom: 4, right: 4),
          child: Tooltip(
            message: 'Upload Avatar',
            child: SizedBox(
              height: kButtonRadius * 2,
              width: kButtonRadius * 2,
              child: Material(
                elevation: 2.0,
                type: MaterialType.circle,
                clipBehavior: Clip.antiAlias,
                color: Theme.of(context).primaryColor,
                child: Ink(
                  child: InkWell(
                    child: Icon(
                      Platform.isIOS ? CupertinoIcons.camera : Icons.camera,
                      color: Theme.of(context).primaryIconTheme.color,
                    ),
                    onTap: () {
                      print('pressed');
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
