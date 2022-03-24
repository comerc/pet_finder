import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_finder/imports.dart';

class AddUnitScreen extends StatefulWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/add_unit',
      builder: (_) => this,
      fullscreenDialog: true,
    );
  }

  const AddUnitScreen({Key? key}) : super(key: key);

  @override
  State<AddUnitScreen> createState() => _AddUnitScreenState();
}

class _AddUnitScreenState extends State<AddUnitScreen> {
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
            'Add Your Pet',
            // style: TextStyle(
            //   color: Colors.grey.shade800,
            // ),
          ),
        ),
        body: Center(child: Text("Add Unit")));
  }
}

class AddUnitForm extends StatelessWidget {
  AddUnitForm({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  // final _displayNameFieldKey = GlobalKey<FormFieldState<String>>();
  // final _phoneFieldKey = GlobalKey<FormFieldState<String>>();
  // final _whatsAppFieldKey = GlobalKey<SwitchFieldState>();
  // final _viberFieldKey = GlobalKey<SwitchFieldState>();
  // final _emailFieldKey = GlobalKey<FormFieldState<String>>();
  // final _showEmailFieldKey = GlobalKey<FormSwitchState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
