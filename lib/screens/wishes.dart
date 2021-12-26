// import 'package:bot_toast/bot_toast.dart';
// import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/import.dart';

// TODO: добавить Refresh

class WishesScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/wishes',
      builder: (_) => this,
      // fullscreenDialog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // timeDilation = 2.0; // Will slow down animations by a factor of two
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Wishes',
          style: TextStyle(
            color: Colors.grey.shade800,
          ),
        ),
      ),
      body: WishesBody(),
    );
  }
}

class WishesBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              buildWhen: (ProfileState previous, ProfileState current) {
                return previous.wishes != current.wishes;
              },
              builder: (BuildContext context, ProfileState state) {
                return GridView.count(
                  physics: BouncingScrollPhysics(),
                  childAspectRatio: 1 / 1.55,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  children: List.generate(
                    state.wishes.length,
                    (int index) => Unit(unit: state.wishes[index].unit),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
