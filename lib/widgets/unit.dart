import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/imports.dart';

class Unit extends StatefulWidget {
  const Unit({
    Key? key,
    required this.unit,
  }) : super(key: key);

  final UnitModel unit;

  @override
  State<Unit> createState() => _UnitState();
}

class _UnitState extends State<Unit> {
  @override
  Widget build(BuildContext context) {
    final unit = widget.unit;
    // TODO: InkWell
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onLongPress: () {}, // чтобы сократить время для splashColor
      onTap: () {
        navigator.push(UnitScreen(unit: unit).getRoute());
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 16,
          // left: 16,
          // right: 16,
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
        // margin: EdgeInsets.only(
        //   right: index == null ? 0 : 16,
        //   left: index == 0 ? 16 : 0,
        //   bottom: 16,
        // ),
        // width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: width,
              child: Stack(
                children: [
                  _buildImage(),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: _buildBadge(),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildTitle(),
                  ),
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Padding(
                  //     padding: EdgeInsets.all(12),
                  //     child: BlocBuilder<ProfileCubit, ProfileState>(
                  //       buildWhen: (
                  //         ProfileState previous,
                  //         ProfileState current,
                  //       ) {
                  //         return previous.wishes != current.wishes;
                  //       },
                  //       builder: (
                  //         BuildContext context,
                  //         ProfileState state,
                  //       ) {
                  //         final isWished =
                  //             state.status == ProfileStatus.ready &&
                  //                 state.wishes.indexWhere((WishModel wish) {
                  //                       return wish.unit.id == unit.id;
                  //                     }) >
                  //                     -1;
                  //         return GestureDetector(
                  //           onLongPress:
                  //               () {}, // чтобы сократить время для splashColor
                  //           onTap: () {
                  //             save(
                  //               () => getBloc<ProfileCubit>(context).saveWish(
                  //                 WishData(
                  //                   unitId: unit.id,
                  //                   value: !isWished,
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //           child: Container(
                  //             height: 30,
                  //             width: 30,
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               color: isWished
                  //                   ? Colors.red.shade400
                  //                   : Colors.white,
                  //             ),
                  //             child: Icon(
                  //               Icons.favorite,
                  //               size: 16,
                  //               color: isWished
                  //                   ? Colors.white
                  //                   : Colors.grey.shade300,
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            _buildBottom(),
            // Padding(
            //   padding: EdgeInsets.all(16),
            //   child: Column(
            //     // crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // Container(
            //       //   decoration: BoxDecoration(
            //       //     color: getConditionBackgroundColor(unit.condition),
            //       //     borderRadius: BorderRadius.all(
            //       //       Radius.circular(10),
            //       //     ),
            //       //   ),
            //       //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            //       //   child: Text(
            //       //     getConditionName(unit.condition),
            //       //     style: TextStyle(
            //       //       color: getConditionForegroundColor(unit.condition),
            //       //       fontWeight: FontWeight.bold,
            //       //       fontSize: 12,
            //       //     ),
            //       //   ),
            //       // ),
            //       // SizedBox(
            //       //   height: 8,
            //       // ),
            //       // Text(
            //       //   unit.breed.name,
            //       //   style: TextStyle(
            //       //     color: Colors.grey.shade800,
            //       //     fontSize: 18,
            //       //     fontWeight: FontWeight.bold,
            //       //   ),
            //       // ),
            //       // SizedBox(
            //       //   height: 8,
            //       // ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Icon(
            //             Icons.location_on,
            //             color: Colors.grey.shade600,
            //             size: 18,
            //           ),
            //           SizedBox(
            //             width: 4,
            //           ),
            //           Text(
            //             unit.address,
            //             style: TextStyle(
            //               color: Colors.grey.shade600,
            //               fontSize: 12,
            //             ),
            //           ),
            //           //Expanded(child: child)
            //           Text("1234"),
            //           // SizedBox(
            //           //   width: 4,
            //           // ),
            //           // Text(
            //           //   "(" + unit.location + "km)",
            //           //   style: TextStyle(
            //           //     color: Colors.grey.shade600,
            //           //     fontSize: 12,
            //           //     fontWeight: FontWeight.bold,
            //           //   ),
            //           // ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final unit = widget.unit;
    return Hero(
      tag: unit.imageUrl,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: getImageProvider(unit.imageUrl),
            // TODO: вертикальные фотки не обрезать, а добавлять поля
            fit: BoxFit.cover,
          ),
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(19),
          //   topRight: Radius.circular(19),
          // ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final unit = widget.unit;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: <Color>[
            Colors.grey.withOpacity(0.0),
            Colors.black.withOpacity(0.4),
          ],
        ),
      ),
      padding: EdgeInsets.only(
        left: 8,
        top: 32,
        right: 8,
        bottom: 8,
      ),
      child: Text(
        unit.title,
        // style: Theme.of(context).textTheme.titleLarge,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Colors.white),

        // style: TextStyle(
        //   fontSize: 18,
        //   fontWeight: FontWeight.w600,
        //   color: Colors.white,
        // ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildBottom() {
    // if (!_isBottom) {
    //   return SizedBox(
    //     height: kButtonHeight,
    //   );
    // }
    return Row(
      children: <Widget>[
        // if (unit.price == null) GiftButton(unit) else PriceButton(unit),

        Spacer(),
        // Icon(
        //   Icons.share,
        // ),
        // SizedBox(width: 16),
        // TextButton.icon(
        //   onLongPress: () {}, // чтобы сократить время для splashColor
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.share,
        //   ),
        //   label: Text(""),
        // ),
        Tooltip(
          message: 'Share',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Material(
              child: InkWell(
                onTap: () {
                  // TODO: реализовать DeepLink
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Icon(
                    Icons.share,
                    // color: Colors.black.withOpacity(0.8),
                    // size: iconSize,
                  ),
                ),
              ),
            ),
          ),
        ),
        Tooltip(
          message: 'Favorite',
          child: TextButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.favorite_border,
              ),
              label: Text("123")),
        ),

        // SizedBox(
        //   width: kButtonWidth,
        //   height: kButtonHeight,
        //   child: ShareButton(unit),
        // ),
        // SizedBox(
        //   width: kButtonWidth,
        //   height: kButtonHeight,
        //   child: WishButton(unit),
        // ),
      ],
    );
  }

  Widget _buildBadge() {
    final unit = widget.unit;
    return Container(
      color: unit.sex == Sex.male
          ? Colors.blueAccent.withOpacity(0.8)
          : Colors.redAccent.withOpacity(0.8),
      padding: EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 12),
      child: Row(
        children: [
          Icon(
            unit.sex == Sex.male ? Icons.male : Icons.female,
            color: Colors.white,
          ),
          Text(
            formatAge(unit),
            style: TextStyle(
              // fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
