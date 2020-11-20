import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/import.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StartBody(),
    );
  }
}

class StartBody extends StatefulWidget {
  @override
  _StartBodyState createState() => _StartBodyState();
}

class _StartBodyState extends State<StartBody> {
  @override
  void initState() {
    super.initState();
    load(() => getBloc<ProfileCubit>(context).load());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (ProfileState previous, ProfileState current) {
        return current.status == ProfileStatus.ready;
      },
      listener: (BuildContext context, ProfileState state) {
        Future.delayed(Duration(milliseconds: 300)).then((_) {
          navigator.pop();
        });
      },
      builder: (BuildContext context, ProfileState state) {
        final cases = {
          ProfileStatus.initial: () => Container(),
          ProfileStatus.loading: () =>
              Center(child: CircularProgressIndicator()),
          ProfileStatus.error: () {
            return Center(
                child: FloatingActionButton(
              onPressed: () {
                BotToast.cleanAll();
                load(() => getBloc<ProfileCubit>(context).load());
              },
              child: Icon(Icons.replay),
            ));
          },
          ProfileStatus.ready: () => Center(child: Text('Profile loaded...')),
        };
        assert(cases.length == ProfileStatus.values.length);
        return cases[state.status]();
      },
    );
  }
}
