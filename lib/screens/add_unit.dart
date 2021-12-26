import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/import.dart';

// TODO: новая порода, если нет желанной
// TODO: продублировать кнопку Submit внутри actions

class AddUnitScreen extends StatelessWidget {
  AddUnitScreen({required this.category});

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
        systemOverlayStyle: SystemUiOverlayStyle.light,
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
        create: (BuildContext context) => AddUnitCubit(
          getRepository<DatabaseRepository>(context),
        ),
        child: AddUnitForm(category: category),
      ),
    );
  }
}

class AddUnitForm extends StatelessWidget {
  AddUnitForm({required this.category});

  final CategoryModel category;

  final _formKey = GlobalKey<FormState>();
  final _imagesFieldKey = GlobalKey<ImagesFieldState>();
  final _conditionFieldKey = GlobalKey<SelectFieldState<ConditionValue>>();
  final _breedFieldKey = GlobalKey<SelectFieldState<BreedModel>>();
  final _colorFieldKey = GlobalKey<FormFieldState<String>>();
  final _weightFieldKey = GlobalKey<FormFieldState<String>>();
  final _storyFieldKey = GlobalKey<FormFieldState<String>>();
  final _birthdayFieldKey = GlobalKey<FormFieldState<String>>();
  final _addressFieldKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              ImagesField(
                key: _imagesFieldKey,
              ),
              // TODO: добавить возможность изменять категорию в форме
              // DropdownButtonFormField<CategoryModel>(
              //   decoration: InputDecoration(
              //     labelText: 'Category',
              //     helperText: '',
              //   ),
              //   value: cubit.state.newPet.category,
              //   items: _getDropdownItemsFromList(cubit.state.categories),
              //   onChanged: (CategoryModel value) {
              //     cubit.setCategory(value);
              //     _breedFocusNode.requestFocus();
              //   },
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   validator: (value) =>
              //       (value == null) ? 'Select pet category' : null,
              // ),
              SelectField<BreedModel>(
                key: _breedFieldKey,
                tooltip: 'Select Breed',
                label: 'Breed by ${category.name}',
                title: 'Select Breed',
                values: category.breeds,
                getValueTitle: (BreedModel value) => value.name,
              ),
              SelectField<ConditionValue>(
                key: _conditionFieldKey,
                tooltip: 'Select Condition',
                label: 'Condition',
                title: 'Select Condition',
                values: ConditionValue.values,
                getValueTitle: getConditionName,
                getValueSubtitle:
                    getConditionDescription, // TODO: description text
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
              // ), // отказался, т.к. хочу другой формат даты
              TextFormField(
                key: _birthdayFieldKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: MultiValidator([
                  RequiredValidator(),
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
                    PatternValidator(
                      r'^\d*$',
                      errorText: 'this field must be numeric',
                    ),
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
              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  final data = UnitData(
                    condition: _conditionFieldKey.currentState!.value,
                    breedId: _breedFieldKey.currentState!.value?.id,
                    color: _getTextValue(_colorFieldKey),
                    weight:
                        int.parse(_getTextValue(_weightFieldKey), radix: 10),
                    story: _getTextValue(_storyFieldKey),
                    imageUrl: _getImageUrl(_imagesFieldKey),
                    birthday: DateFormat(kDateFormat)
                        .parse(_getTextValue(_birthdayFieldKey), true),
                    address: _getTextValue(_addressFieldKey),
                  );
                  save(() async {
                    await getBloc<AddUnitCubit>(context).add(data);
                    navigator.pop(true);
                  });
                },
                child: Text('Submit'.toUpperCase()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _getImageUrl(GlobalKey<ImagesFieldState> key) {
    final value = key.currentState!.value;
    if (value.isEmpty) {
      return null;
    }
    return value[0]?.url;
  }

  String _getTextValue(GlobalKey<FormFieldState<String>> key) {
    return key.currentState!.value!.trim();
  }
}
