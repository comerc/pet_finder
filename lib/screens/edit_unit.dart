import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:pet_finder/import.dart';

class EditUnitScreen extends StatefulWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/edit_unit?${(unit == null) ? 'is_new=1' : 'id=${unit!.id}'}',
      builder: (_) => this,
      fullscreenDialog: true,
    );
  }

  const EditUnitScreen({
    Key? key,
    this.unit,
  }) : super(key: key);

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
          (widget.unit == null) ? 'Add My Pet' : 'Edit My Pet',
        ),
        actions: <Widget>[
          if (widget.unit != null)
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
      body: BlocProvider(
        create: (BuildContext context) => EditUnitCubit(
          getRepository<DatabaseRepository>(context),
        ),
        child: EditUnitForm(
          unit: widget.unit,
        ),
      ),
    );
  }
}

class EditUnitForm extends StatefulWidget {
  EditUnitForm({
    Key? key,
    this.unit,
  }) : super(key: key);

  final UnitModel? unit;

  @override
  State<EditUnitForm> createState() => _EditUnitFormState();
}

class _EditUnitFormState extends State<EditUnitForm> {
  final _formKey = GlobalKey<FormState>();
  final _imagesFieldKey = GlobalKey<ImagesFieldState>();
  final _titleFieldKey = GlobalKey<FormFieldState<String>>();
  final _sexFieldKey = GlobalKey<SelectFieldState<SexValue>>();
  final _birthdayFieldKey = GlobalKey<FormFieldState<String>>();
  final _ageFieldKey = GlobalKey<SelectFieldState<AgeValue>>();
  final _weightFieldKey = GlobalKey<FormFieldState<String>>();
  final _sizeFieldKey = GlobalKey<SelectFieldState<SizeModel>>();
  final _woolFieldKey = GlobalKey<SelectFieldState<WoolValue>>();
  final _colorFieldKey = GlobalKey<SelectFieldState<ColorModel>>();
  final _storyFieldKey = GlobalKey<FormFieldState<String>>();
  final _addressFieldKey = GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
    load(() => getBloc<EditUnitCubit>(context).load());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditUnitCubit, EditUnitState>(
        buildWhen: (EditUnitState previous, EditUnitState current) {
      return previous.status != current.status;
    }, builder: (BuildContext context, EditUnitState state) {
      final cases = {
        EditUnitStatus.initial: () => Container(),
        EditUnitStatus.loading: () => Center(child: Progress()),
        EditUnitStatus.error: () => Center(child: _buildReloadButton()),
        EditUnitStatus.ready: () => _buildForm(state),
      };
      assert(cases.length == ShowcaseStatus.values.length);
      return cases[state.status]!();
    });
  }

  Widget _buildReloadButton() {
    return FloatingActionButton(
      onPressed: () {
        BotToast.cleanAll();
        load(() => getBloc<EditUnitCubit>(context).load());
      },
      child: Icon(Icons.replay),
    );
  }

  Widget _buildForm(EditUnitState state) {
    final width = MediaQuery.of(context).size.width;
    SexValue? sex; // = SexValue.female;
    AgeValue? age; // = AgeValue.
    Widget result = Column(
      children: [
        TextFormField(
          key: _titleFieldKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: RequiredValidator(),
          maxLength: kUnitTitleMaxLength,
          minLines: 1,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            labelText: 'Title',
            counterText: '',
          ),
        ),
        SelectField<SexValue>(
          key: _sexFieldKey,
          label: 'Sex',
          title: 'Select Sex',
          values: SexValue.values,
          getValueTitle: getSexName,
        ),
        TextFormField(
          key: _birthdayFieldKey,
          validator: MultiValidator([
            PatternValidator(
              r'^\d{2}-\d{2}-\d{4}$',
              errorText: 'this field must be $kDisplayDateFormat',
            ),
            DateValidator(
              kDateFormat,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              errorText: 'this field must be valid date',
            ),
          ]),
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            labelText: 'Birthday (if known)',
            hintText: kDisplayDateFormat,
          ),
        ),
        SelectField<AgeValue>(
          key: _ageFieldKey,
          label: 'Age',
          title: 'Select Age',
          values: AgeValue.values,
          getValueTitle: getAgeName,
        ),
        TextFormField(
          key: _weightFieldKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: '',
          validator: PatternValidator(
            r'^\d*$',
            errorText: 'this field must be numeric',
          ),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Weight (if known)',
            suffixText: 'grams',
          ),
        ),
        SelectField<SizeModel>(
          key: _sizeFieldKey,
          label: 'Size',
          title: 'Select Size',
          values: state.model!.sizes,
          getValueTitle: (SizeModel value) => value.name,
        ),
        SelectField<WoolValue>(
          key: _woolFieldKey,
          label: 'Wool',
          title: 'Select Wool',
          values: WoolValue.values,
          getValueTitle: getWoolName,
        ),
        SelectField<ColorModel>(
          key: _colorFieldKey,
          label: 'Color',
          title: 'Select Color',
          values: state.model!.colors,
          getValueTitle: (ColorModel value) => value.name,
        ),
        TextFormField(
          key: _storyFieldKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: RequiredValidator(),
          minLines: 1,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            labelText: 'Story',
          ),
        ),
        // SizedBox(
        //   height: width,
        //   child:
        //   (unit == null)
        //       ? Material(
        //           color: Theme.of(context).primaryColorLight,
        //           type: MaterialType.button,
        //           child: InkWell(
        //             highlightColor: Colors.transparent,
        //             splashColor: Colors.white.withOpacity(0.24),
        //             onTap: () {},
        //             child: Center(
        //               child: Icon(
        //                 defaultTargetPlatform == TargetPlatform.iOS
        //                     ? CupertinoIcons.photo_camera
        //                     : Icons.photo_camera_outlined,
        //                 size: 40,
        //                 color: Theme.of(context).primaryColorDark,
        //               ),
        //             ),
        //           ),
        //         )
        //       : Hero(
        //           tag: unit!.imageUrl,
        //           child: Material(
        //             type: MaterialType.transparency,
        //             child: InkWell(
        //               highlightColor: Colors.transparent,
        //               splashColor: Colors.white.withOpacity(0.24),
        //               onTap: () {},
        //               child: Ink.image(
        //                 fit: BoxFit.cover,
        //                 image: getImageProvider(unit!.imageUrl),
        //               ),
        //             ),
        //           ),
        //         ),
        // ),
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
        TextFormField(
          key: _addressFieldKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: RequiredValidator(),
          maxLength: kUnitAddressMaxLength,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Address',
            counterText: '',
          ),
        ),
        SizedBox(
          height: 8,
        ),
        ElevatedButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            // if (!_formKey.currentState!.validate()) {
            //   return;
            // }
            // out(_whatsAppFieldKey.currentState!.value);
            // out(_viberFieldKey.currentState!.value);
            // final data = UnitData(
            //   condition: _conditionFieldKey.currentState!.value,
            //   breedId: _breedFieldKey.currentState!.value?.id,
            //   color: _getTextValue(_colorFieldKey),
            //   weight:
            //       int.parse(_getTextValue(_weightFieldKey), radix: 10),
            //   story: _getTextValue(_storyFieldKey),
            //   imageUrl: _getImageUrl(_imagesFieldKey),
            //   birthday: DateFormat(kDateFormat)
            //       .parse(_getTextValue(_birthdayFieldKey), true),
            //   address: _getTextValue(_addressFieldKey),
            // );
            // save(() async {
            //   await getBloc<AddUnitCubit>(context).add(data);
            //   navigator.pop(true);
            // });
          },
          child: Text('Submit'.toUpperCase()),
        ),
      ],
    );
    result = Padding(
      padding: EdgeInsets.only(left: 32, right: 32, bottom: 16),
      child: result,
    );
    result = Column(
      children: [
        SizedBox(height: 16),
        ImagesField(
          key: _imagesFieldKey,
        ),
        SizedBox(height: 8),
        result,
      ],
    );
    result = SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: result,
      ),
    );
    return result;
  }
}

enum _PopupMenuValue { delete }
