import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/import.dart';

class Unit extends StatelessWidget {
  Unit({
    required this.unit,
    required this.index,
  });

  final UnitModel unit;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigator.push(UnitScreen(unit).getRoute());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        margin: EdgeInsets.only(
            right: index == null ? 0 : 16,
            left: index == 0 ? 16 : 0,
            bottom: 16),
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: unit.imageUrl,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: getImageProvider(unit.imageUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(19),
                          topRight: Radius.circular(19),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: BlocBuilder<ProfileCubit, ProfileState>(
                        buildWhen: (
                          ProfileState previous,
                          ProfileState current,
                        ) {
                          return previous.wishes != current.wishes;
                        },
                        builder: (
                          BuildContext context,
                          ProfileState state,
                        ) {
                          final isWished =
                              state.status == ProfileStatus.ready &&
                                  state.wishes.indexWhere((WishModel wish) =>
                                          wish.unit.id == unit.id) >
                                      -1;
                          return GestureDetector(
                            onLongPress:
                                () {}, // чтобы сократить время для splashColor
                            onTap: () {
                              save(
                                () => getBloc<ProfileCubit>(context).saveWish(
                                  WishData(
                                    unitId: unit.id,
                                    value: !isWished,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    isWished ? Colors.red[400] : Colors.white,
                              ),
                              child: Icon(
                                Icons.favorite,
                                size: 16,
                                color:
                                    isWished ? Colors.white : Colors.grey[300],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: getConditionBackgroundColor(unit.condition),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      getConditionName(unit.condition),
                      style: TextStyle(
                        color: getConditionForegroundColor(unit.condition),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    unit.breed.name,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey[600],
                        size: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        unit.address,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      // SizedBox(
                      //   width: 4,
                      // ),
                      // Text(
                      //   "(" + unit.location + "km)",
                      //   style: TextStyle(
                      //     color: Colors.grey[600],
                      //     fontSize: 12,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
