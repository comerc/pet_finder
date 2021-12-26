import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_finder/import.dart';

// TODO: переделать login-password без formz

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Login',
          style: TextStyle(
            color: Colors.grey.shade800,
          ),
        ),
      ),
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
    return Container(
      padding: EdgeInsets.all(8),
      child: Align(
        alignment: Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (LoginState previous, LoginState current) =>
          previous.status != current.status,
      builder: (BuildContext context, LoginState state) {
        return ElevatedButton(
          key: Key('$runtimeType'),
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            primary: Color(0xFFFFD600),
          ),
          onPressed: () {
            save(() => getBloc<LoginCubit>(context).logInWithCredentials());
          },
          child: Text(
            'Login'.toUpperCase(),
          ),
        );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      key: Key('$runtimeType'),
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        primary: theme.colorScheme.secondary,
      ),
      label: Text(
        'Sign In with Google'.toUpperCase(),
        style: TextStyle(color: Colors.white),
      ),
      icon: Icon(
        FontAwesomeIcons.google,
        color: Colors.white,
      ),
      onPressed: () {
        save(() => getBloc<LoginCubit>(context).logInWithGoogle());
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: Key('$runtimeType'),
      style: TextButton.styleFrom(
        shape: StadiumBorder(),
      ),
      onPressed: () => navigator.push<void>(SignUpScreen().getRoute()),
      child: Text(
        'Create Account'.toUpperCase(),
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
