import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:pet_finder/import.dart';

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
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       backgroundColor: Theme.of(context).dialogBackgroundColor,
  //       // extendBodyBehindAppBar: true,
  //       appBar: AppBar(
  //         // systemOverlayStyle: SystemUiOverlayStyle.light,
  //         // backgroundColor: Colors.transparent,
  //         // elevation: 0,
  //         centerTitle: true,
  //         title: Text(
  //           'Load Profile...',
  //           // style: TextStyle(
  //           //   color: Colors.grey.shade800,
  //           // ),
  //         ),
  //       ),
  //       body: Center(child: Text("...")));
  // }

  late User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _run();
  }

  void _run() async {
    await waitCustomUserClaims();
    if (!mounted) return;
    getRepository<DatabaseRepository>(context).initializeService();
    _load();
  }

  void _load() {
    final data = MemberData(
      displayName: _user.displayName,
      imageUrl: _user.photoURL,
    );
    load(() => getBloc<ProfileCubit>(context).load(data));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (ProfileState previous, ProfileState current) {
        return previous.status != current.status;
      },
      builder: (BuildContext context, ProfileState state) {
        final cases = {
          ProfileStatus.initial: () => Container(),
          ProfileStatus.loading: () =>
              Center(child: CircularProgressIndicator()),
          ProfileStatus.error: () {
            return Center(
              child: FloatingActionButton(
                onPressed: () {
                  BotToast.cleanAll();
                  _load();
                },
                child: Icon(Icons.replay),
              ),
            );
          },
          ProfileStatus.ready: () => Container(),
        };
        assert(cases.length == ProfileStatus.values.length);
        return cases[state.status]!();
      },
    );
  }

  Future<bool> waitCustomUserClaims([int retry = 0]) async {
    // await Future.delayed(Duration(milliseconds: 100));
    // return true;
    if (retry < 4) {
      await Future.delayed(Duration(milliseconds: 100));
    } else {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Не удалось получить доступ, попробуйте ещё раз.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  navigator.pop();
                },
                child: Text('ОК'),
              ),
            ],
          );
        },
      );
    }
    final idTokenResult = await _user.getIdTokenResult(true);
    final customUserClaims =
        idTokenResult.claims!['https://hasura.io/jwt/claims'];
    if (customUserClaims == null) {
      return waitCustomUserClaims(retry + 1);
    }
    return true;
  }
}
