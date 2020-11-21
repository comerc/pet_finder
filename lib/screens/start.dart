import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/import.dart';

// TODO: страница для вопроса о геолокации

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget result = Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(),
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StartBody(),
    );
    result = WillPopScope(
      onWillPop: _onWillPop,
      child: result,
    );
    return result;
  }

  Future<bool> _onWillPop() async {
    // ignore: unawaited_futures
    SystemNavigator.pop();
    return false;
  }
}

class StartBody extends StatefulWidget {
  @override
  _StartBodyState createState() => _StartBodyState();
}

class _StartBodyState extends State<StartBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Start'));
  }
}
