import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/import.dart';

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
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        _buildImage(
          child: Stack(
            children: [
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
            ],
          ),
        ),
        _buildBottom(),
      ],
    );
  }

  Widget _buildImage({required Widget child}) {
    final unit = widget.unit;
    final width = MediaQuery.of(context).size.width;
    return Hero(
      tag: unit.id,
      child: Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: getImageProvider(unit.images[0].url),
            // TODO: вертикальные фотки не обрезать, а добавлять поля
            fit: BoxFit.cover,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.white.withOpacity(0.24),
            onTap: () {
              navigator.push(UnitScreen(unit: unit).getRoute());
            },
            child: child,
          ),
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
        // Material(
        //   type: MaterialType.transparency,
        //   // borderRadius: BorderRadius.circular(4),
        //   clipBehavior: Clip.antiAlias,
        //   // child: Tooltip(
        //   //   preferBelow: false,
        //   //   message: 'Share',
        //   child: InkWell(
        //     onTap: () {
        //       // TODO: реализовать DeepLink
        //     },
        //     child: Padding(
        //       padding:
        //           const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        //       child: Icon(
        //         Icons.share,
        //         // color: Colors.black.withOpacity(0.8),
        //         // size: iconSize,
        //       ),
        //     ),
        //   ),
        //   // ),
        // ),
        // Tooltip(
        //   preferBelow: false,
        //   message: 'Favorite',
        // child:
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              out('onTap'); // TODO: FullScreen Preview with Zoom
            },
            child: LikeButton(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              likeBuilder: (bool isLiked) {
                return Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).primaryColor,
                );
              },
              likeCount: 123,
            ),
          ),
        ),
        // ),
      ],
    );
  }

  Widget _buildBadge() {
    final unit = widget.unit;
    return Container(
      color: unit.sex == SexValue.male
          ? Colors.blueAccent.withOpacity(0.8)
          : Colors.redAccent.withOpacity(0.8),
      padding: EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 12),
      child: Row(
        children: [
          Icon(
            unit.sex == SexValue.male ? Icons.male : Icons.female,
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
