import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_finder/import.dart';

class UpsertMemberScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/upsert_member',
      builder: (_) => this,
      fullscreenDialog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   leading: Container(),
      //   brightness: Brightness.light,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: UpsertMemberBody(),
    );
  }
}

class UpsertMemberBody extends StatefulWidget {
  @override
  _UpsertMemberBodyState createState() => _UpsertMemberBodyState();
}

class _UpsertMemberBodyState extends State<UpsertMemberBody> {
  @override
  void initState() {
    super.initState();
    _run();
  }

  void _run() async {
    await Future.delayed(Duration.zero);
    final user = FirebaseAuth.instance.currentUser;
    final memberId = await _getMemberId(user);

    getBloc<AuthenticationCubit>(context).setMemberId(memberId);
    final data = MemberData(
      displayName: user.displayName,
      imageUrl: user.photoURL,
    );

    await save(() => getBloc<AppCubit>(context).upsertMember(data));
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }

  Future<String> _getMemberId(User user, [int retry = 0]) async {
    if (retry < 4) {
      await Future.delayed(Duration(milliseconds: 100));
    } else {
      await showDialog(
        context: context,
        child: AlertDialog(
          content: Text('Не удалось получить доступ, попробуйте ещё раз.'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                navigator.pop();
              },
              child: Text('ОК'),
            ),
          ],
        ),
      );
    }
    final idTokenResult = await user.getIdTokenResult(true);
    final customUserClaims =
        idTokenResult.claims['https://hasura.io/jwt/claims'];
    if (customUserClaims == null) {
      return _getMemberId(user, retry + 1);
    }
    return customUserClaims['x-hasura-user-id'] as String;
  }
}
