import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pet_finder/import.dart';

class SignUpScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/sign_up',
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: BlocProvider(
        create: (BuildContext context) =>
            SignUpCubit(getRepository<AuthenticationRepository>(context)),
        child: SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (BuildContext context, SignUpState state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Sign Up Failure')),
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
              _EmailInput(),
              SizedBox(height: 8),
              _PasswordInput(),
              SizedBox(height: 8),
              _ConfirmPasswordInput(),
              SizedBox(height: 8),
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (SignUpState previous, SignUpState current) =>
          previous.emailInput != current.emailInput,
      builder: (BuildContext context, SignUpState state) {
        return TextField(
          key: Key('$runtimeType'),
          onChanged: (String value) =>
              getBloc<SignUpCubit>(context).doEmailChanged(value),
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (SignUpState previous, SignUpState current) =>
          previous.passwordInput != current.passwordInput,
      builder: (BuildContext context, SignUpState state) {
        return TextField(
          key: Key('$runtimeType'),
          onChanged: (String value) =>
              getBloc<SignUpCubit>(context).doPasswordChanged(value),
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

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (SignUpState previous, SignUpState current) =>
          previous.passwordInput != current.passwordInput ||
          previous.confirmedPasswordInput != current.confirmedPasswordInput,
      builder: (context, state) {
        return TextField(
          key: Key('$runtimeType'),
          onChanged: (String value) =>
              getBloc<SignUpCubit>(context).doConfirmedPasswordChanged(value),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'confirm password',
            helperText: '',
            errorText: state.confirmedPasswordInput.invalid
                ? 'passwords do not match'
                : null,
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (SignUpState previous, SignUpState current) =>
          previous.status != current.status,
      builder: (BuildContext context, SignUpState state) {
        return state.status.isSubmissionInProgress ||
                state.status.isSubmissionSuccess
            ? CircularProgressIndicator()
            : RaisedButton(
                key: Key('$runtimeType'),
                shape: StadiumBorder(),
                color: Colors.orangeAccent,
                onPressed: state.status.isValidated
                    ? () => getBloc<SignUpCubit>(context).signUpFormSubmitted()
                    : null,
                child: Text('Sign Up'.toUpperCase()),
              );
      },
    );
  }
}
