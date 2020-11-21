import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:pet_finder/import.dart';

class LoginScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/login',
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocProvider(
        create: (BuildContext context) =>
            LoginCubit(getRepository<AuthenticationRepository>(context)),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (BuildContext context, LoginState state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Align(
          alignment: Alignment(0, -1 / 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/bloc_logo_small.png',
                height: 120,
              ),
              SizedBox(height: 16),
              _EmailInput(),
              SizedBox(height: 8),
              _PasswordInput(),
              SizedBox(height: 8),
              _LoginButton(),
              SizedBox(height: 8),
              _GoogleLoginButton(),
              SizedBox(height: 4),
              _SignUpButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (LoginState previous, LoginState current) =>
          previous.emailInput != current.emailInput,
      builder: (BuildContext context, LoginState state) {
        return TextField(
          key: Key('$runtimeType'),
          onChanged: (String value) =>
              getBloc<LoginCubit>(context).doEmailChanged(value),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'email',
            helperText: '',
            errorText: state.emailInput.invalid ? 'invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (LoginState previous, LoginState current) =>
          previous.passwordInput != current.passwordInput,
      builder: (BuildContext context, LoginState state) {
        return TextField(
          key: Key('$runtimeType'),
          onChanged: (String value) =>
              getBloc<LoginCubit>(context).doPasswordChanged(value),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            helperText: '',
            errorText: state.passwordInput.invalid ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print(runtimeType);
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (LoginState previous, LoginState current) =>
          previous.status != current.status,
      builder: (BuildContext context, LoginState state) {
        return state.status.isSubmissionInProgress
            ? CircularProgressIndicator()
            : RaisedButton(
                key: Key('$runtimeType'),
                shape: StadiumBorder(),
                color: Color(0xFFFFD600),
                onPressed: state.status.isValidated
                    ? () => getBloc<LoginCubit>(context).logInWithCredentials()
                    : null,
                child: Text('Login'.toUpperCase()),
              );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RaisedButton.icon(
      key: Key('$runtimeType'),
      label: Text(
        'Sign In with Google'.toUpperCase(),
        style: TextStyle(color: Colors.white),
      ),
      shape: StadiumBorder(),
      icon: Icon(FontAwesomeIcons.google, color: Colors.white),
      color: theme.accentColor,
      onPressed: () => getBloc<LoginCubit>(context).logInWithGoogle(),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FlatButton(
      key: Key('$runtimeType'),
      shape: StadiumBorder(),
      onPressed: () => navigator.push<void>(SignUpScreen().getRoute()),
      child: Text(
        'Create Account'.toUpperCase(),
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
