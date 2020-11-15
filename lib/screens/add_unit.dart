import 'package:flutter/material.dart';
import 'package:pet_finder/widgets/user_avatar.dart';
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
          'Add your pet',
          style: TextStyle(
            color: Colors.grey[800],
          ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('breed'),
            trailing: Icon(Icons.arrow_right), // TODO: исправить стрелочку
          ), // TODO: control for breed
          TextField(
            // onChanged: (String value) =>
            //     getBloc<LoginCubit>(context).doEmailChanged(value),
            maxLength: 10,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Color',
              // helperText: '',
              // errorText: state.color.invalid ? 'invalid color' : null,
            ),
          ),
          TextField(
            // onChanged: (String value) =>
            //     getBloc<LoginCubit>(context).doEmailChanged(value),
            maxLength: 4,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Weight',
              // helperText: '',
              // errorText: state.color.invalid ? 'invalid color' : null,
            ),
          ),
          TextField(
            // onChanged: (String value) =>
            //     getBloc<LoginCubit>(context).doEmailChanged(value),
            maxLength: 160,
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: 'Story',
              // helperText: '',
              // errorText: state.color.invalid ? 'invalid color' : null,
            ),
          ),
          Row(
            children: List.generate(
              ConditionValue.values.length,
              (index) => Text(
                getConditionName(ConditionValue.values[index]),
              ),
            ),
          ), // TODO: control for condition
          TextField(
            // onChanged: (String value) =>
            //     getBloc<LoginCubit>(context).doEmailChanged(value),
            keyboardType: TextInputType.datetime,
            decoration: InputDecoration(
              labelText: 'Birthday',
              // helperText: '',
              // errorText: state.color.invalid ? 'invalid color' : null,
            ),
          ),
          TextField(
            // onChanged: (String value) =>
            //     getBloc<LoginCubit>(context).doEmailChanged(value),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Color',
              // helperText: '',
              // errorText: state.color.invalid ? 'invalid color' : null,
            ),
          ),
          TextField(
            // onChanged: (String value) =>
            //     getBloc<LoginCubit>(context).doEmailChanged(value),
            maxLength: 20,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Address',
              // helperText: '',
              // errorText: state.color.invalid ? 'invalid color' : null,
            ),
          ),
        ],
      ),
    );
  }
}
