import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/import.dart';

// TODO: новая порода, если нет желанной

class AddUnitScreen extends StatelessWidget {
  AddUnitScreen({this.category});

  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/add_unit',
      builder: (_) => this,
      fullscreenDialog: true,
    );
  }

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Add Your Pet',
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
      ),
      body: BlocProvider(
        create: (BuildContext context) =>
            AddUnitCubit(getRepository<DatabaseRepository>(context))
              ..load(categoryId: category.id),
        child: AddUnitForm(),
      ),
    );
  }
}

class AddUnitForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _breedFieldKey = GlobalKey<SelectFieldState<BreedModel>>();
  final _colorFieldKey = GlobalKey<FormFieldState<String>>();
  final _weightFieldKey = GlobalKey<FormFieldState<String>>();
  final _storyFieldKey = GlobalKey<FormFieldState<String>>();
  final _birthdayFieldKey = GlobalKey<FormFieldState<String>>();
  final _addressFieldKey = GlobalKey<FormFieldState<String>>();
  final _conditionFieldKey = GlobalKey<SelectFieldState<ConditionValue>>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddUnitCubit, AddUnitState>(
      listenWhen: (AddUnitState previous, AddUnitState current) {
        return previous.status != current.status;
      },
      listener: (BuildContext context, AddUnitState state) {
        if (state.status == AddUnitStatus.loading) {
          BotToast.showLoading();
        } else {
          BotToast.closeAllLoading();
        }
      },
      builder: (BuildContext context, AddUnitState state) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SelectField<BreedModel>(
                    key: _breedFieldKey,
                    tooltip: 'Select Breed',
                    label: 'Breed',
                    title: 'Select Breed',
                    values: state.breeds,
                    getValueTitle: (BreedModel value) => value.name,
                  ),
                  TextFormField(
                    key: _addressFieldKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: RequiredValidator(),
                    maxLength: 20,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      // helperText: '',
                    ),
                  ),
                  // InputDatePickerFormField(
                  //   firstDate: DateTime(2000),
                  //   lastDate: DateTime.now(),
                  //   fieldLabelText: 'Birthday',
                  // ),
                  TextFormField(
                    key: _birthdayFieldKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: MultiValidator([
                      RequiredValidator(),
                      PatternValidator(r'^\d{2}-\d{2}-\d{4}$',
                          errorText: 'this field must be $kDisplayDateFormat'),
                      DateValidator(kDateFormat,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                          errorText: 'this field must be valid date'),
                    ]),
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: 'Birthday',
                      helperText: kDisplayDateFormat,
                    ),
                  ),
                  TextFormField(
                    key: _colorFieldKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: RequiredValidator(),
                    maxLength: 10,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Color',
                      // helperText: '',
                    ),
                  ),
                  TextFormField(
                    key: _weightFieldKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: MultiValidator(
                      [
                        RequiredValidator(),
                        PatternValidator(r'^\d*$',
                            errorText: 'this field must be numeric'),
                      ],
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Weight',
                      helperText: 'in gramms',
                    ),
                  ),
                  TextFormField(
                    key: _storyFieldKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: RequiredValidator(),
                    maxLength: 160,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Story',
                      // helperText: '',
                    ),
                  ),
                  // Row(
                  //   children: List.generate(
                  //     ConditionValue.values.length,
                  //     (index) => Text(
                  //       getConditionName(ConditionValue.values[index]),
                  //     ),
                  //   ),
                  // ), // TODO: control for condition
                  SelectField<ConditionValue>(
                    key: _conditionFieldKey,
                    tooltip: 'Select Condition',
                    label: 'Condition',
                    title: 'Select Condition',
                    values: ConditionValue.values,
                    getValueTitle: getConditionName,
                    getValueSubtitle: getConditionDescription,
                  ), // TODO: FocusScope.of(context).unfocus();
                  ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      // TODO: try catch
                      final unit = AddUnitDTO(
                        breedId: _breedFieldKey.currentState.value.id,
                        color: _getTextValue(_colorFieldKey),
                        weight: int.parse(_getTextValue(_weightFieldKey),
                            radix: 10),
                        story: _getTextValue(_storyFieldKey),
                        birthday: DateFormat(kDateFormat)
                            .parse(_getTextValue(_birthdayFieldKey), true),
                        address: _getTextValue(_addressFieldKey),
                        condition: _conditionFieldKey.currentState.value,
                      );
                      _submit(getBloc<AddUnitCubit>(context), unit);
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getTextValue(GlobalKey<FormFieldState<String>> key) {
    return key.currentState.value.trim();
  }

  void _submit(AddUnitCubit cubit, AddUnitDTO unit) async {
    try {
      await cubit.submit(unit);
    } catch (error) {
      BotToast.showNotification(
        title: (_) => Text(
          '$error',
          overflow: TextOverflow.fade,
          softWrap: false,
        ),
        trailing: (Function close) => FlatButton(
          onLongPress: () {}, // чтобы сократить время для splashColor
          onPressed: () {
            close();
            _submit(cubit, unit);
          },
          child: Text('Repeat'.toUpperCase()),
        ),
      );
    }
  }
}
