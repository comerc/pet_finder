import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_finder/imports.dart';

class EditUnitScreen extends StatefulWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/edit_unit?${isNew ? 'is_new=1' : 'id=${unit!.id}'}',
      builder: (_) => this,
      fullscreenDialog: true,
    );
  }

  const EditUnitScreen({
    Key? key,
    this.isNew = false,
    this.unit,
  }) : super(key: key);

  final bool isNew;
  final UnitModel? unit;

  @override
  State<EditUnitScreen> createState() => _EditUnitScreenState();
}

class _EditUnitScreenState extends State<EditUnitScreen> {
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
          widget.isNew ? 'Add My Pet' : 'Edit My Pet',
          // style: TextStyle(
          //   color: Colors.grey.shade800,
          // ),
        ),
        actions: <Widget>[
          PopupMenuButton<_PopupMenuValue>(
            // icon: Icon(Icons.more_horiz), // TODO: вертикальные точки в Android?
            onSelected: (_PopupMenuValue value) async {
              if (value == _PopupMenuValue.delete) {
                final result = await showConfirmDialog(
                    context: context,
                    title: 'Вы уверены, что хотите удалить объявление?',
                    content:
                        'Размещать его повторно\nзапрещено — возможен бан.',
                    ok: 'Удалить');
                out(result);
                if (result != true) return;
              }
            },
            itemBuilder: (BuildContext context) {
              final result = <PopupMenuEntry<_PopupMenuValue>>[];
              result.add(
                PopupMenuItem(
                  value: _PopupMenuValue.delete,
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.black87),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              );
              return result;
            },
          ),
        ],
      ),
      body: EditUnitForm(
        isNew: widget.isNew,
        unit: widget.unit,
      ),
    );
  }
}

class EditUnitForm extends StatelessWidget {
  EditUnitForm({
    Key? key,
    required this.isNew,
    this.unit,
  }) : super(key: key);

  final bool isNew;
  final UnitModel? unit;

  final _formKey = GlobalKey<FormState>();
  // final _displayNameFieldKey = GlobalKey<FormFieldState<String>>();
  // final _phoneFieldKey = GlobalKey<FormFieldState<String>>();
  // final _whatsAppFieldKey = GlobalKey<SwitchFieldState>();
  // final _viberFieldKey = GlobalKey<SwitchFieldState>();
  // final _emailFieldKey = GlobalKey<FormFieldState<String>>();
  // final _showEmailFieldKey = GlobalKey<FormSwitchState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: width,
              child: isNew
                  ? Material(
                      color: Theme.of(context).primaryColorLight,
                      type: MaterialType.button,
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.white.withOpacity(0.24),
                        onTap: () {},
                        child: Center(
                          child: Icon(
                            Platform.isIOS
                                ? CupertinoIcons.photo_camera
                                : Icons.photo_camera_outlined,
                            size: 40,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                      ),
                    )
                  : Hero(
                      tag: unit!.imageUrl,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Ink.image(
                          fit: BoxFit.cover,
                          image: getImageProvider(unit!.imageUrl),
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.white.withOpacity(0.24),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ElevatedButtonDefaultOverlay extends MaterialStateProperty<Color?> {
  ElevatedButtonDefaultOverlay(this.onPrimary);

  final Color onPrimary;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return onPrimary.withOpacity(0.08);
    }
    if (states.contains(MaterialState.focused) ||
        states.contains(MaterialState.pressed)) {
      return onPrimary.withOpacity(0.24);
    }
    return null;
  }
}

enum _PopupMenuValue { delete }
