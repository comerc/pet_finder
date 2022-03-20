import 'package:flutter/material.dart';
import 'package:pet_finder/imports.dart';

class UnitScreen extends StatefulWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/unit?id=${unit.id}',
      builder: (_) => this,
      fullscreenDialog: true,
    );
  }

  const UnitScreen({
    Key? key,
    required this.unit,
  }) : super(key: key);

  final UnitModel unit;

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  @override
  Widget build(BuildContext context) {
    // Theme.of(context).textTheme.caption;
    // var captionTextStyle = Theme.of(context).textTheme.caption;
    // Theme.of(context).textTheme.caption!.getTextStyle();
    var style = Theme.of(context).textTheme.headline6;
    // Theme.of(context).appBarTheme.toolbarTextStyle;
    // out(style);
    return Scaffold(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        // systemOverlayStyle: SystemUiOverlayStyle.light,
        // backgroundColor: Colors.transparent,
        // elevation: 0,
        centerTitle: true,
        // TODO: вставить иконку для unit.sex через RichText
        backgroundColor:
            widget.unit.sex == Sex.male ? Colors.blueAccent : Colors.redAccent,
        title: Text(
          (widget.unit.sex == Sex.male ? 'Male' : 'Female') +
              ' - ' +
              formatAge(widget.unit),
        ),
      ),
      // body: Center(child: Text('(${widget.unit.id})')));

      body: Text("1111"),
      // body: RichText(
      //   text: TextSpan(
      //     text: 'Hello ',
      //     style: Theme.of(context).textTheme.caption,
      //     // DefaultTextStyle.of(context).style,
      //     // children: const <TextSpan>[
      //     //   TextSpan(
      //     //       text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
      //     //   TextSpan(text: ' world!'),
      //     // ],
      //   ),
      // ),
    );
  }
}
