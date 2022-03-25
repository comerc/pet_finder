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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.isNew ? 'Add My Pet' : 'Edit My Pet',
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
  // TODO: перенести ImagesField, который реализован для V1

  // color wool size sex age
  final _sexFieldKey = GlobalKey<SelectFieldState<SexValue>>();
  final _ageFieldKey = GlobalKey<SelectFieldState<AgeValue>>();
  final _woolFieldKey = GlobalKey<SelectFieldState<WoolValue>>();
  final _colorFieldKey = GlobalKey<SelectFieldState<ColorModel>>();
  final _sizeFieldKey = GlobalKey<SelectFieldState<SizeModel>>();
  // final _conditionFieldKey = GlobalKey<SelectFieldState<ConditionValue>>();
  // final _breedFieldKey = GlobalKey<SelectFieldState<ColorModel>>();

  // final _displayNameFieldKey = GlobalKey<FormFieldState<String>>();
  // final _phoneFieldKey = GlobalKey<FormFieldState<String>>();
  // final _whatsAppFieldKey = GlobalKey<SwitchFieldState>();
  // final _viberFieldKey = GlobalKey<SwitchFieldState>();
  // final _emailFieldKey = GlobalKey<FormFieldState<String>>();
  // final _showEmailFieldKey = GlobalKey<FormSwitchState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    SexValue? sex; // = SexValue.female;
    AgeValue? age; // = AgeValue.
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
            // DropdownField<SexValue>(
            //     key: _sexFieldKey,
            //     hintText: 'Sex',
            //     values: SexValue.values,
            //     initialValue: sex,
            //     getValueTitle: getSexName,
            //     empty: 'Select Sex'),
            // DropdownField<AgeValue>(
            //     key: _ageFieldKey,
            //     hintText: 'Age',
            //     values: AgeValue.values,
            //     initialValue: age,
            //     getValueTitle: getAgeName,
            //     empty: 'Select Age'),
            SelectField<SexValue>(
              key: _sexFieldKey,
              tooltip: 'Select Sex',
              label: 'Sex',
              title: 'Select Sex',
              values: SexValue.values,
              getValueTitle: getSexName,
            ),
            SelectField<AgeValue>(
              key: _ageFieldKey,
              tooltip: 'Select Age',
              label: 'Age',
              title: 'Select Age',
              values: AgeValue.values,
              getValueTitle: getAgeName,
            ),
            SelectField<WoolValue>(
              key: _woolFieldKey,
              tooltip: 'Select Wool',
              label: 'Wool',
              title: 'Select Wool',
              values: WoolValue.values,
              getValueTitle: getWoolName,
            ),
            SelectField<ColorModel>(
              key: _colorFieldKey,
              tooltip: 'Select Color',
              label: 'Color',
              title: 'Select Color',
              values: DatabaseRepository().colors,
              getValueTitle: (ColorModel value) => value.name,
            ),
            SelectField<SizeModel>(
              key: _sizeFieldKey,
              tooltip: 'Select Size',
              label: 'Size',
              title: 'Select Size',
              values: DatabaseRepository().sizes,
              getValueTitle: (SizeModel value) => value.name,
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
