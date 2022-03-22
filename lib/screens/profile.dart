import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_finder/imports.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile'),
      ),
      body: Column(
        children: [
          UserAvatar(url: DatabaseRepository().member.imageUrl!),
          Avatar(
            url: DatabaseRepository().member.imageUrl!,
            onTap: () {
              // TODO: загрузка аватарки
              // TODO: распознование лица и обрезание картинки
              // TODO: в телеге можно кликнуть по аватарке, и посмотреть галерею участника (но усложняет модерацию)
              // showDialog(
              //   context: context,
              //   child: AlertDialog(
              //     content: Text(
              //         'Поменять аватарку можно будет в следующей версии.'),
              //     actions: <Widget>[
              //       FlatButton(
              //         child: Text('ОК'),
              //         onPressed: () {
              //           navigator.pop();
              //         },
              //       ),
              //     ],
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}
